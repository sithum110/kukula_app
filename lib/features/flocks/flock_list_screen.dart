import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kukula_app/core/providers/farm_providers.dart';
import 'package:kukula_app/core/routing/app_router.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/flocks/flock_model.dart';
import 'package:kukula_app/l10n/app_localizations.dart';

class FlockListScreen extends ConsumerWidget {
  const FlockListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flocks = ref.watch(flockListProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final l10n = AppLocalizations.of(context);

    final active = flocks.where((f) => f.status == FlockStatus.active).toList();
    final closed = flocks.where((f) => f.status == FlockStatus.closed).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.flocks),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: flocks.isEmpty
          ? _EmptyState(onAdd: () => context.push(AppRoutes.addFlock))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary bar
                _SummaryBar(flocks: active),
                const SizedBox(height: 20),

                if (active.isNotEmpty) ...[
                  _SectionLabel(label: 'Active Flocks (${active.length})'),
                  const SizedBox(height: 10),
                  ...active.map((f) => _FlockCard(flock: f)),
                ],

                if (closed.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _SectionLabel(label: 'Closed Flocks (${closed.length})'),
                  const SizedBox(height: 10),
                  ...closed.map((f) => _FlockCard(flock: f)),
                ],

                const SizedBox(height: 80),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Freemium gate: max 3 active flocks
          final activeCount = flocks.where((f) => f.status == FlockStatus.active).length;
          if (!isPremium && activeCount >= 3) {
            _showUpgradeDialog(context);
          } else {
            context.push(AppRoutes.addFlock);
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.addFlock),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('👑 Premium Required',
            style: TextStyle(color: AppColors.textPrimaryDark)),
        content: const Text(
          'Free plan allows up to 3 active flocks.\nUpgrade to Premium for unlimited flocks.',
          style: TextStyle(color: AppColors.textSecondaryDark),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Upgrade Now')),
        ],
      ),
    );
  }
}

// ── Summary Bar ──────────────────────────────────────────────────────────
class _SummaryBar extends StatelessWidget {
  final List<FlockModel> flocks;
  const _SummaryBar({required this.flocks});

  @override
  Widget build(BuildContext context) {
    final totalBirds = flocks.fold(0, (sum, f) => sum + f.currentCount);
    final layers = flocks.where((f) => f.isLayer).length;
    final broilers = flocks.where((f) => f.isBroiler).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryContainer, AppColors.cardDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          _SummaryItem(label: 'Total Birds', value: totalBirds.toString(), icon: '🐔'),
          _Divider(),
          _SummaryItem(label: 'Layer Flocks', value: layers.toString(), icon: '🥚'),
          _Divider(),
          _SummaryItem(label: 'Broiler Flocks', value: broilers.toString(), icon: '🐔'),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  const _SummaryItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 48, color: AppColors.borderDark);
}

// ── Flock Card ───────────────────────────────────────────────────────────
class _FlockCard extends ConsumerWidget {
  final FlockModel flock;
  const _FlockCard({required this.flock});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = flock.status == FlockStatus.active;
    final mortalityRate = flock.initialCount > 0
        ? ((flock.initialCount - flock.currentCount) / flock.initialCount * 100)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('${AppRoutes.flocks}/${flock.id}'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? AppColors.borderDark : AppColors.textHintDark,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Purpose icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: flock.isLayer
                            ? AppColors.eggAccent.withValues(alpha: 0.15)
                            : AppColors.meatAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(flock.isLayer ? '🥚' : '🐔',
                            style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(flock.name,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimaryDark)),
                          if (flock.breed != null)
                            Text(flock.breed!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondaryDark)),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.textHintDark.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isActive ? 'Active' : 'Closed',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive ? AppColors.success : AppColors.textHintDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Stats row
                Row(
                  children: [
                    _StatChip(icon: Icons.pets_rounded,
                        label: '${flock.currentCount} birds'),
                    const SizedBox(width: 8),
                    if (flock.pen != null)
                      _StatChip(icon: Icons.home_work_outlined, label: flock.pen!),
                    const Spacer(),
                    if (mortalityRate > 0)
                      _StatChip(
                        icon: Icons.trending_down_rounded,
                        label: '${mortalityRate.toStringAsFixed(1)}% mort.',
                        color: mortalityRate > 5
                            ? AppColors.error
                            : AppColors.warning,
                      ),
                  ],
                ),

                const SizedBox(height: 10),
                // Progress bar: current / initial
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Bird count',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textHintDark)),
                        Text('${flock.currentCount} / ${flock.initialCount}',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textSecondaryDark)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: flock.initialCount > 0
                            ? flock.currentCount / flock.initialCount
                            : 0,
                        backgroundColor: AppColors.borderDark,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          mortalityRate > 5 ? AppColors.warning : AppColors.success,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),

                if (isActive) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showMortalityDialog(context, ref, flock),
                          icon: const Icon(Icons.remove_circle_outline, size: 16),
                          label: const Text('Log Mortality', style: TextStyle(fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('${AppRoutes.flocks}/${flock.id}'),
                          icon: const Icon(Icons.visibility_outlined, size: 16),
                          label: const Text('View Detail', style: TextStyle(fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMortalityDialog(BuildContext context, WidgetRef ref, FlockModel flock) {
    final countController = TextEditingController(text: '1');
    final causeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text('💀', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Text('Log Mortality — ${flock.name}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryDark)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: countController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of birds died',
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: causeController,
              decoration: const InputDecoration(
                labelText: 'Cause (optional)',
                hintText: 'e.g. Disease, Heat stress',
                prefixIcon: Icon(Icons.info_outline),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final count = int.tryParse(countController.text) ?? 0;
                if (count > 0) {
                  ref.read(flockListProvider.notifier).logBirdEvent(
                    flock.id,
                    BirdEventType.mortality,
                    count,
                    cause: causeController.text.isEmpty ? null : causeController.text,
                  );
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Record Mortality'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _StatChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textSecondaryDark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: c),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: c)),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondaryDark,
          letterSpacing: 0.5,
        ),
      );
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🐔', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            const Text('No Flocks Yet',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryDark)),
            const SizedBox(height: 8),
            const Text('Add your first flock to start tracking\nyour birds and egg production.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondaryDark)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add First Flock'),
            ),
          ],
        ),
      ),
    );
  }
}
