import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kukula_app/core/providers/batch_providers.dart';
import 'package:kukula_app/core/routing/app_router.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/meat_batches/batch_model.dart';
import 'package:kukula_app/l10n/app_localizations.dart';

class BatchListScreen extends ConsumerWidget {
  const BatchListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batches = ref.watch(batchListProvider);
    final l10n = AppLocalizations.of(context);

    final growing = batches.where((b) => b.status == BatchStatus.growing).toList();
    final others = batches.where((b) => b.status != BatchStatus.growing).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.batches)),
      body: batches.isEmpty
          ? _EmptyState(onAdd: () => context.push(AppRoutes.addBatch))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _BatchSummaryBar(batches: growing),
                const SizedBox(height: 20),
                if (growing.isNotEmpty) ...[
                  _SectionLabel('Growing Batches (${growing.length})'),
                  const SizedBox(height: 10),
                  ...growing.map((b) => _BatchCard(batch: b)),
                ],
                if (others.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _SectionLabel('Past Batches (${others.length})'),
                  const SizedBox(height: 10),
                  ...others.map((b) => _BatchCard(batch: b)),
                ],
                const SizedBox(height: 80),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addBatch),
        icon: const Icon(Icons.add),
        label: Text(l10n.addBatch),
        backgroundColor: AppColors.meatAccent,
      ),
    );
  }
}

class _BatchSummaryBar extends StatelessWidget {
  final List<BatchModel> batches;
  const _BatchSummaryBar({required this.batches});

  @override
  Widget build(BuildContext context) {
    final totalBirds = batches.fold(0, (s, b) => s + b.currentCount);
    final avgAge = batches.isEmpty
        ? 0
        : batches
                .map((b) => DateTime.now().difference(b.arrivalDate).inDays)
                .reduce((a, b) => a + b) ~/
            batches.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.meatAccent.withValues(alpha: 0.2),
            AppColors.cardDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.meatAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          _SummaryItem(label: 'Active Batches', value: batches.length.toString(), icon: '🐔'),
          Container(width: 1, height: 48, color: AppColors.borderDark),
          _SummaryItem(label: 'Total Birds', value: totalBirds.toString(), icon: '🐔'),
          Container(width: 1, height: 48, color: AppColors.borderDark),
          _SummaryItem(label: 'Avg Age', value: '$avgAge days', icon: '📅'),
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
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.meatAccent)),
            Text(label,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                textAlign: TextAlign.center),
          ],
        ),
      );
}

class _BatchCard extends ConsumerWidget {
  final BatchModel batch;
  const _BatchCard({required this.batch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final age = DateTime.now().difference(batch.arrivalDate).inDays;
    final isGrowing = batch.status == BatchStatus.growing;
    final mortality = batch.initialCount - batch.currentCount;
    final mortalityPct = batch.initialCount > 0
        ? (mortality / batch.initialCount * 100)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('${AppRoutes.batches}/${batch.id}'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isGrowing
                    ? AppColors.meatAccent.withValues(alpha: 0.3)
                    : AppColors.borderDark,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.meatAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                          child: Text('🐔', style: TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(batch.name,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimaryDark)),
                          if (batch.breed != null)
                            Text(batch.breed!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondaryDark)),
                        ],
                      ),
                    ),
                    _StatusBadge(status: batch.status),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 12),

                Row(
                  children: [
                    _Chip(icon: Icons.pets_rounded, label: '${batch.currentCount} birds'),
                    const SizedBox(width: 8),
                    _Chip(icon: Icons.schedule, label: '$age days old'),
                    if (batch.supplier != null) ...[
                      const SizedBox(width: 8),
                      _Chip(icon: Icons.store_outlined, label: batch.supplier!),
                    ],
                  ],
                ),

                if (mortality > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.trending_down_rounded,
                          size: 13,
                          color: mortalityPct > 3
                              ? AppColors.error
                              : AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        '$mortality deaths (${mortalityPct.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          fontSize: 12,
                          color: mortalityPct > 3
                              ? AppColors.error
                              : AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 12),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: batch.initialCount > 0
                        ? batch.currentCount / batch.initialCount
                        : 0,
                    backgroundColor: AppColors.borderDark,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.meatAccent),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${batch.currentCount} / ${batch.initialCount} birds',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textHintDark)),
                    Text('Arrived ${_daysSince(batch.arrivalDate)}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textHintDark)),
                  ],
                ),

                if (isGrowing) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showMortalitySheet(context, ref, batch),
                          icon: const Icon(Icons.remove_circle_outline, size: 16),
                          label: const Text('Mortality', style: TextStyle(fontSize: 13)),
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
                          onPressed: () => context.push(AppRoutes.meatSales,
                              extra: batch.id),
                          icon: const Icon(Icons.sell_outlined, size: 16),
                          label: const Text('Sell Birds', style: TextStyle(fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.meatAccent,
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

  void _showMortalitySheet(BuildContext context, WidgetRef ref, BatchModel batch) {
    final ctrl = TextEditingController(text: '1');
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Record Mortality — ${batch.name}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Number of birds died',
                  prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final n = int.tryParse(ctrl.text) ?? 0;
                if (n > 0) {
                  ref.read(batchListProvider.notifier).reduceBirds(batch.id, n);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Record'),
            ),
          ],
        ),
      ),
    );
  }

  String _daysSince(DateTime date) {
    final days = DateTime.now().difference(date).inDays;
    if (days == 0) return 'today';
    if (days == 1) return 'yesterday';
    return '$days days ago';
  }
}

class _StatusBadge extends StatelessWidget {
  final BatchStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case BatchStatus.growing:
        color = AppColors.success;
        label = 'Growing';
        break;
      case BatchStatus.sold:
        color = AppColors.info;
        label = 'Sold';
        break;
      case BatchStatus.closed:
        color = AppColors.textHintDark;
        label = 'Closed';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondaryDark),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
        ],
      );
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) => Text(label,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondaryDark,
          letterSpacing: 0.5));
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🐔', style: TextStyle(fontSize: 72)),
              const SizedBox(height: 16),
              const Text('No Batches Yet',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              const Text('Add your first broiler batch to start\ntracking your meat production.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondaryDark)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('Add First Batch'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.meatAccent),
              ),
            ],
          ),
        ),
      );
}
