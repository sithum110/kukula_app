import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kukula_app/core/providers/locale_provider.dart';
import 'package:kukula_app/core/routing/app_router.dart';
import 'package:kukula_app/core/theme/app_theme.dart';

/// Shown once during sign-up onboarding so the user can choose
/// their preferred language before setting up their farm.
class OnboardingLanguageScreen extends ConsumerStatefulWidget {
  const OnboardingLanguageScreen({super.key});

  @override
  ConsumerState<OnboardingLanguageScreen> createState() =>
      _OnboardingLanguageScreenState();
}

class _OnboardingLanguageScreenState
    extends ConsumerState<OnboardingLanguageScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<void> _pick(BuildContext context, String langCode) async {
    final notifier = ref.read(localeProvider.notifier);
    final router = GoRouter.of(context);
    if (langCode == 'si') {
      await notifier.setSinhala();
    } else {
      await notifier.setEnglish();
    }
    router.go(AppRoutes.farmSetup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideIn,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),

                  // ── Step indicator ──────────────────────────────────────
                  Row(
                    children: List.generate(3, (i) {
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: i == 0 ? 24 : 8,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == 0
                              ? AppColors.primary
                              : AppColors.borderDark,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),

                  // ── Icon ───────────────────────────────────────────────
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: const Center(
                      child: Text('🌐', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Heading ────────────────────────────────────────────
                  const Text(
                    'Choose Your Language',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimaryDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select Language / භාෂාව තෝරන්න',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // ── Language cards ─────────────────────────────────────
                  _LanguageOptionCard(
                    flag: '🇬🇧',
                    label: 'English',
                    sublabel: 'Continue in English',
                    onTap: () => _pick(context, 'en'),
                  ),
                  const SizedBox(height: 16),
                  _LanguageOptionCard(
                    flag: '🇱🇰',
                    label: 'සිංහල',
                    sublabel: 'සිංහලෙන් දිගටම කරගෙන යන්න',
                    onTap: () => _pick(context, 'si'),
                  ),

                  const Spacer(flex: 3),

                  // ── Step note ──────────────────────────────────────────
                  const Text(
                    'Step 1 of 3  ·  You can change this later in Settings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHintDark,
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Language Option Card ────────────────────────────────────────────────────
class _LanguageOptionCard extends StatefulWidget {
  final String flag;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  const _LanguageOptionCard({
    required this.flag,
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  @override
  State<_LanguageOptionCard> createState() => _LanguageOptionCardState();
}

class _LanguageOptionCardState extends State<_LanguageOptionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: _pressed
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.cardDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _pressed ? AppColors.primary : AppColors.borderDark,
            width: _pressed ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag emoji in a pill
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.cardDark2,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(widget.flag,
                    style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.sublabel,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _pressed
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: _pressed
                    ? Colors.white
                    : AppColors.primary,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
