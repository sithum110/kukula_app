import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/billing/billing_service.dart';
import 'package:kukula_app/core/providers/farm_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';

// ── Subscription Screen ────────────────────────────────────────────────────
class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  String _selectedPlanId = 'kukula_premium_yearly'; // default to yearly
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isPremium
          ? _buildAlreadyPremium(context)
          : _buildUpgradeView(context),
    );
  }

  // ── Already Premium ────────────────────────────────────────────────────────
  Widget _buildAlreadyPremium(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('👑', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            const Text('You\'re on Premium!',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.premiumGold)),
            const SizedBox(height: 12),
            const Text(
              'Thank you for supporting Easy Poultry Manager. All premium features are unlocked.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: AppColors.textSecondaryDark),
            ),
            const SizedBox(height: 32),
            // Show all unlocked features
            ...premiumFeatures.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(children: [
                    Text(f.icon, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimaryDark)),
                          Text(f.description,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondaryDark)),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 20),
                  ]),
                )),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.premiumGold,
                side: const BorderSide(color: AppColors.premiumGold),
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Back to Settings',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Upgrade View ───────────────────────────────────────────────────────────
  Widget _buildUpgradeView(BuildContext context) {
    final plans = BillingService.plans;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        // ── Hero banner ────────────────────────────────────────────────
        _HeroBanner(shimmerController: _shimmerController),
        const SizedBox(height: 24),

        // ── Features list ──────────────────────────────────────────────
        const _SectionLabel('What you\'ll get'),
        const SizedBox(height: 14),
        _FeaturesList(),
        const SizedBox(height: 28),

        // ── Plan selector ──────────────────────────────────────────────
        const _SectionLabel('Choose your plan'),
        const SizedBox(height: 14),
        ...plans.map((plan) => _PlanCard(
              plan: plan,
              isSelected: _selectedPlanId == plan.id,
              onSelect: () => setState(() => _selectedPlanId = plan.id),
            )),
        const SizedBox(height: 28),

        // ── CTA button ────────────────────────────────────────────────
        _PurchaseButton(
          selectedPlanId: _selectedPlanId,
          plans: plans,
          isPurchasing: _isPurchasing,
          onPurchase: _purchase,
        ),
        const SizedBox(height: 12),

        // ── Restore purchases ──────────────────────────────────────────
        Center(
          child: TextButton(
            onPressed: _restorePurchases,
            child: const Text('Restore Purchases',
                style: TextStyle(
                    color: AppColors.textSecondaryDark, fontSize: 13)),
          ),
        ),

        // ── Dev toggle ────────────────────────────────────────────────
        const SizedBox(height: 20),
        _DevPremiumToggle(),

        const SizedBox(height: 16),

        // ── Legal ─────────────────────────────────────────────────────
        const _LegalFooter(),
      ],
    );
  }

  Future<void> _purchase() async {
    setState(() => _isPurchasing = true);
    final result = await BillingService.purchase(_selectedPlanId);
    if (mounted) {
      setState(() => _isPurchasing = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message ?? (result.success ? 'Purchased!' : 'Purchase failed')),
        backgroundColor: result.success ? AppColors.success : AppColors.cardDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  Future<void> _restorePurchases() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Restoring purchases…'),
      behavior: SnackBarBehavior.floating,
    ));
    await BillingService.restorePurchases();
  }
}

// ── Hero Banner ────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final AnimationController shimmerController;
  const _HeroBanner({required this.shimmerController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmerController,
      builder: (_, __) {
        final shimmer = shimmerController.value;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A1208),
                const Color(0xFF2C1E0A),
                Color.lerp(const Color(0xFFD4A017), const Color(0xFFF5C842),
                    shimmer)!
                    .withValues(alpha: 0.25),
                const Color(0xFF2C1E0A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0, 0.3, 0.6, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.premiumGold.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            children: [
              const Text('👑', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 12),
              const Text('Unlock Premium',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.premiumGold,
                      letterSpacing: -0.5)),
              const SizedBox(height: 8),
              const Text(
                'Everything you need to run a professional poultry farm',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondaryDark,
                    height: 1.4),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Features List ──────────────────────────────────────────────────────────
class _FeaturesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        children: premiumFeatures.asMap().entries.map((entry) {
          final f = entry.value;
          final isLast = entry.key == premiumFeatures.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.premiumGold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(f.icon,
                            style: const TextStyle(fontSize: 20))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f.title,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimaryDark)),
                        Text(f.description,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondaryDark)),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.premiumGold, size: 20),
                ]),
              ),
              if (!isLast)
                const Divider(height: 1, color: AppColors.borderDark),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Plan Card ──────────────────────────────────────────────────────────────
class _PlanCard extends StatelessWidget {
  final PricingInfo plan;
  final bool isSelected;
  final VoidCallback onSelect;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.premiumGold.withValues(alpha: 0.08)
              : AppColors.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.premiumGold : AppColors.borderDark,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.premiumGold
                      : AppColors.textHintDark,
                  width: 2,
                ),
                color: isSelected
                    ? AppColors.premiumGold.withValues(alpha: 0.2)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.premiumGold,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            // Label + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(plan.label,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.premiumGold
                                : AppColors.textPrimaryDark)),
                    if (plan.isPopular) ...const [
                      SizedBox(width: 8),
                      _PopularBadge(),
                    ],
                  ]),
                  const SizedBox(height: 3),
                  Text(plan.description,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryDark)),
                ],
              ),
            ),

            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(plan.price,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? AppColors.premiumGold
                            : AppColors.textPrimaryDark)),
                Text(plan.period,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondaryDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Popular Badge ──────────────────────────────────────────────────────────
class _PopularBadge extends StatelessWidget {
  const _PopularBadge();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.premiumGold,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text('POPULAR',
            style: TextStyle(
                fontSize: 9,
                color: Colors.black,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5)),
      );
}

// ── Purchase Button ────────────────────────────────────────────────────────
class _PurchaseButton extends StatelessWidget {
  final String selectedPlanId;
  final List<PricingInfo> plans;
  final bool isPurchasing;
  final VoidCallback onPurchase;

  const _PurchaseButton({
    required this.selectedPlanId,
    required this.plans,
    required this.isPurchasing,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final plan = plans.firstWhere(
      (p) => p.id == selectedPlanId,
      orElse: () => plans.first,
    );

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isPurchasing ? null : onPurchase,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.premiumGold,
          foregroundColor: Colors.black,
          disabledBackgroundColor: AppColors.premiumGold.withValues(alpha: 0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: AppColors.premiumGold.withValues(alpha: 0.4),
        ),
        child: isPurchasing
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.black),
              )
            : Text(
                'Start ${plan.label} Plan — ${plan.price}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800),
              ),
      ),
    );
  }
}

// ── Dev Premium Toggle ─────────────────────────────────────────────────────
class _DevPremiumToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(children: [
        const Icon(Icons.science_outlined,
            size: 18, color: AppColors.textSecondaryDark),
        const SizedBox(width: 10),
        const Expanded(
          child: Text('Dev: Toggle Premium',
              style:
                  TextStyle(fontSize: 13, color: AppColors.textSecondaryDark)),
        ),
        Switch(
          value: isPremium,
          onChanged: (v) =>
              ref.read(isPremiumProvider.notifier).state = v,
          activeColor: AppColors.premiumGold,
        ),
      ]),
    );
  }
}

// ── Legal Footer ───────────────────────────────────────────────────────────
class _LegalFooter extends StatelessWidget {
  const _LegalFooter();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Subscriptions auto-renew unless cancelled 24h before period ends. '
      'Manage or cancel subscriptions in Google Play. '
      'By subscribing you agree to our Terms of Service and Privacy Policy.',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 10,
          color: AppColors.textHintDark,
          height: 1.5),
    );
  }
}

// ── Section Label ──────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondaryDark,
          letterSpacing: 0.3));
}
