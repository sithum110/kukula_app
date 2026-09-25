import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/providers/feed_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/feeding/feed_model.dart';

class FeedLogScreen extends ConsumerStatefulWidget {
  const FeedLogScreen({super.key});

  @override
  ConsumerState<FeedLogScreen> createState() => _FeedLogScreenState();
}

class _FeedLogScreenState extends ConsumerState<FeedLogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lowCount = ref.watch(feedTypeListProvider.notifier).lowStockCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feeding & Stock'),
        actions: [
          if (lowCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.warning),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('$lowCount',
                            style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryDark,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.list_alt, size: 16),
                  SizedBox(width: 4),
                  Text('Feed Log'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 16),
                  const SizedBox(width: 4),
                  const Text('Stock'),
                  if (lowCount > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('$lowCount',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bar_chart_rounded, size: 16),
                  SizedBox(width: 4),
                  Text('Summary'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _FeedLogTab(),
          _StockTab(),
          _SummaryTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFeedSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Feed Entry'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showAddFeedSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddFeedEntrySheet(),
    );
  }
}

// ── Feed Log Tab ──────────────────────────────────────────────────────────
class _FeedLogTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logNotifier = ref.watch(feedLogListProvider.notifier);
    final logs = ref.watch(feedLogListProvider);
    final grouped = logNotifier.groupedByDate;

    if (logs.isEmpty) {
      return _EmptyState(
        emoji: '🌾',
        title: 'No Feed Logs Yet',
        subtitle: 'Tap + to record your first feeding entry.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: grouped.length,
      itemBuilder: (_, i) {
        final dateKey = grouped.keys.toList()[i];
        final dayLogs = grouped[dateKey]!;
        final dayTotal = dayLogs.fold(0.0, (s, l) => s + l.quantityKg);
        final dayCost = dayLogs.fold(0.0, (s, l) => s + (l.costLKR ?? 0));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateHeader(
              dateKey: dateKey,
              totalKg: dayTotal,
              totalCost: dayCost,
            ),
            const SizedBox(height: 8),
            ...dayLogs.map((log) => _FeedLogTile(log: log)),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String dateKey;
  final double totalKg;
  final double totalCost;

  const _DateHeader({
    required this.dateKey,
    required this.totalKg,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(dateKey,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary)),
        ),
        const SizedBox(width: 8),
        Text(
          '${totalKg.toStringAsFixed(1)} kg',
          style: const TextStyle(
              fontSize: 12, color: AppColors.textSecondaryDark),
        ),
        if (totalCost > 0) ...[
          const Text(' · ',
              style: TextStyle(color: AppColors.textHintDark)),
          Text('LKR ${totalCost.toStringAsFixed(0)}',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.success)),
        ],
      ],
    );
  }
}

class _FeedLogTile extends ConsumerWidget {
  final FeedLogModel log;
  const _FeedLogTile({required this.log});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(log.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) {
        // Re-add stock when log is deleted
        ref.read(feedTypeListProvider.notifier).addStock(log.feedTypeId, log.quantityKg);
        ref.read(feedLogListProvider.notifier).deleteLog(log.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted · ${log.quantityKg} kg returned to stock'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                  child: Text('🌾', style: TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.feedTypeName,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryDark)),
                  const SizedBox(height: 2),
                  Text(
                    log.flockName ?? 'Farm-wide',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondaryDark),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${log.quantityKg.toStringAsFixed(1)} kg',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
                if (log.costLKR != null)
                  Text(
                    'LKR ${log.costLKR!.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.success),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stock Tab ─────────────────────────────────────────────────────────────
class _StockTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedTypes = ref.watch(feedTypeListProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Low stock alert banner
        Consumer(builder: (_, ref, __) {
          final lowItems = ref.watch(feedTypeListProvider.notifier).lowStockItems;
          if (lowItems.isEmpty) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('⚠️', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      '${lowItems.length} item${lowItems.length > 1 ? 's' : ''} low on stock',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warning),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ...lowItems.map((f) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '• ${f.name}: ${f.currentStockKg.toStringAsFixed(1)} kg (min ${f.lowStockThresholdKg.toStringAsFixed(0)} kg)',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryDark),
                      ),
                    )),
              ],
            ),
          );
        }),

        // Feed type cards
        const _SectionLabel('Feed Types & Stock'),
        const SizedBox(height: 10),
        ...feedTypes.map((ft) => _FeedStockCard(feedType: ft)),
        const SizedBox(height: 16),

        // Add feed type
        OutlinedButton.icon(
          onPressed: () => _showAddFeedTypeSheet(context, ref),
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Add Feed Type'),
        ),
      ],
    );
  }

  void _showAddFeedTypeSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddFeedTypeSheet(),
    );
  }
}

class _FeedStockCard extends ConsumerWidget {
  final FeedTypeModel feedType;
  const _FeedStockCard({required this.feedType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLow = feedType.isLowStock;
    final stockPct = feedType.lowStockThresholdKg > 0
        ? (feedType.currentStockKg / (feedType.lowStockThresholdKg * 3))
            .clamp(0.0, 1.0)
        : 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLow
              ? AppColors.warning.withValues(alpha: 0.5)
              : AppColors.borderDark,
          width: isLow ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isLow
                      ? AppColors.warning.withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: Text(isLow ? '⚠️' : '🌾',
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feedType.name,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryDark)),
                    if (feedType.brand != null)
                      Text(feedType.brand!,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryDark)),
                  ],
                ),
              ),
              if (feedType.pricePerKg != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('LKR ${feedType.pricePerKg!.toStringAsFixed(0)}/kg',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryDark)),
                    Text(
                      'LKR ${(feedType.currentStockKg * feedType.pricePerKg!).toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${feedType.currentStockKg.toStringAsFixed(1)} kg on hand',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isLow ? AppColors.warning : AppColors.textPrimaryDark),
              ),
              Text(
                'Min: ${feedType.lowStockThresholdKg.toStringAsFixed(0)} kg',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textHintDark),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stockPct,
              backgroundColor: AppColors.borderDark,
              valueColor: AlwaysStoppedAnimation<Color>(
                isLow ? AppColors.warning : AppColors.success,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _showRestockSheet(context, ref, feedType),
                  icon: const Icon(Icons.add_shopping_cart, size: 15),
                  label: const Text('Restock', style: TextStyle(fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                    side: BorderSide(
                        color: AppColors.success.withValues(alpha: 0.4)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined, size: 15),
                  label: const Text('Edit', style: TextStyle(fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRestockSheet(
      BuildContext context, WidgetRef ref, FeedTypeModel feedType) {
    final ctrl = TextEditingController();
    final costCtrl = TextEditingController();

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
            Text('Restock — ${feedType.name}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark)),
            const SizedBox(height: 4),
            Text('Current: ${feedType.currentStockKg.toStringAsFixed(1)} kg',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondaryDark)),
            const SizedBox(height: 20),
            TextField(
              controller: ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Quantity to add (kg)',
                prefixIcon: Icon(Icons.add_circle_outline),
                suffixText: 'kg',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: costCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Total cost (LKR) — optional',
                prefixIcon: Icon(Icons.attach_money),
                prefixText: 'LKR ',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final kg = double.tryParse(ctrl.text) ?? 0;
                if (kg > 0) {
                  ref
                      .read(feedTypeListProvider.notifier)
                      .addStock(feedType.id, kg);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '✅ Added ${kg.toStringAsFixed(1)} kg to ${feedType.name}'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success),
              child: const Text('Add to Stock'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Summary Tab ───────────────────────────────────────────────────────────
class _SummaryTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logNotifier = ref.watch(feedLogListProvider.notifier);
    final logs = ref.watch(feedLogListProvider);
    final feedTypes = ref.watch(feedTypeListProvider);

    final weeklyKg = logNotifier.totalKgThisWeek;
    final monthCost = logNotifier.totalCostThisMonth;
    final totalStockValue = feedTypes.fold(
        0.0,
        (s, f) => s + f.currentStockKg * (f.pricePerKg ?? 0));

    // Per-feed-type consumption
    final consumption = <String, double>{};
    for (final log in logs) {
      consumption[log.feedTypeName] =
          (consumption[log.feedTypeName] ?? 0) + log.quantityKg;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Cards
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  emoji: '📅',
                  label: 'This Week',
                  value: '${weeklyKg.toStringAsFixed(1)} kg',
                  sub: 'feed used',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiCard(
                  emoji: '💰',
                  label: 'This Month',
                  value: 'LKR ${monthCost.toStringAsFixed(0)}',
                  sub: 'feed cost',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  emoji: '📦',
                  label: 'Stock Value',
                  value: 'LKR ${totalStockValue.toStringAsFixed(0)}',
                  sub: '${feedTypes.length} feed types',
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiCard(
                  emoji: '⚠️',
                  label: 'Low Stock',
                  value: '${feedTypes.where((f) => f.isLowStock).length}',
                  sub: 'items need restock',
                  color: feedTypes.any((f) => f.isLowStock)
                      ? AppColors.warning
                      : AppColors.success,
                ),
              ),
            ],
          ),

          if (consumption.isNotEmpty) ...[
            const SizedBox(height: 24),
            const _SectionLabel('Feed Consumption Breakdown'),
            const SizedBox(height: 12),
            _ConsumptionChart(consumption: consumption),
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _ConsumptionChart extends StatelessWidget {
  final Map<String, double> consumption;
  const _ConsumptionChart({required this.consumption});

  @override
  Widget build(BuildContext context) {
    final total = consumption.values.fold(0.0, (a, b) => a + b);
    final colors = [
      AppColors.primary,
      AppColors.eggAccent,
      AppColors.meatAccent,
      AppColors.info,
      AppColors.success,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        children: consumption.entries.toList().asMap().entries.map((e) {
          final idx = e.key;
          final name = e.value.key;
          final kg = e.value.value;
          final pct = total > 0 ? kg / total : 0.0;
          final color = colors[idx % colors.length];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(name,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimaryDark)),
                      ],
                    ),
                    Text(
                      '${kg.toStringAsFixed(1)} kg (${(pct * 100).toStringAsFixed(0)}%)',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryDark),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: AppColors.borderDark,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Add Feed Entry Sheet ──────────────────────────────────────────────────
class _AddFeedEntrySheet extends ConsumerStatefulWidget {
  const _AddFeedEntrySheet();

  @override
  ConsumerState<_AddFeedEntrySheet> createState() => _AddFeedEntrySheetState();
}

class _AddFeedEntrySheetState extends ConsumerState<_AddFeedEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  FeedTypeModel? _selectedFeed;
  final _qtyCtrl = TextEditingController();
  final _flockCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  bool _isLoading = false;

  double get _autoCost {
    final kg = double.tryParse(_qtyCtrl.text) ?? 0;
    return kg * (_selectedFeed?.pricePerKg ?? 0);
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _flockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedTypes = ref.watch(feedTypeListProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Log Feed Entry',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark)),
              const SizedBox(height: 20),

              // Feed type selector
              const _Label('Feed Type'),
              const SizedBox(height: 8),
              DropdownButtonFormField<FeedTypeModel>(
                initialValue: _selectedFeed,
                dropdownColor: AppColors.cardDark2,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.grass_outlined),
                    hintText: 'Select feed type'),
                items: feedTypes
                    .map((f) => DropdownMenuItem(
                          value: f,
                          child: Row(
                            children: [
                              Text(f.name,
                                  style: const TextStyle(
                                      color: AppColors.textPrimaryDark,
                                      fontSize: 14)),
                              const SizedBox(width: 6),
                              Text(
                                '(${f.currentStockKg.toStringAsFixed(1)} kg)',
                                style: TextStyle(
                                  color: f.isLowStock
                                      ? AppColors.warning
                                      : AppColors.textHintDark,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedFeed = v),
                validator: (v) => v == null ? 'Select a feed type' : null,
              ),
              const SizedBox(height: 12),

              // Quantity
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Quantity (kg)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _qtyCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            hintText: '25.0',
                            suffixText: 'kg',
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            final n = double.tryParse(v);
                            if (n == null || n <= 0) return 'Invalid';
                            if (_selectedFeed != null &&
                                n > _selectedFeed!.currentStockKg) {
                              return 'Exceeds stock (${_selectedFeed!.currentStockKg.toStringAsFixed(1)} kg)';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_autoCost > 0) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Est. Cost',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondaryDark)),
                            const SizedBox(height: 4),
                            Text(
                              'LKR ${_autoCost.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // Flock / batch
              const _Label('Given To (optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _flockCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Flock A, Batch Jan 2026',
                  prefixIcon: Icon(Icons.group_work_outlined),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Save Feed Log'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedFeed == null) return;
    setState(() => _isLoading = true);

    final kg = double.parse(_qtyCtrl.text);
    final log = FeedLogModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      farmId: 'farm1',
      feedTypeId: _selectedFeed!.id,
      feedTypeName: _selectedFeed!.name,
      flockId: null,
      flockName: _flockCtrl.text.trim().isEmpty
          ? 'Farm-wide'
          : _flockCtrl.text.trim(),
      quantityKg: kg,
      costLKR: _autoCost > 0 ? _autoCost : null,
      date: _date,
      createdAt: DateTime.now(),
    );

    ref.read(feedLogListProvider.notifier).addLog(log);
    ref.read(feedTypeListProvider.notifier).deductStock(_selectedFeed!.id, kg);

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '✅ ${kg.toStringAsFixed(1)} kg of ${_selectedFeed!.name} logged'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// ── Add Feed Type Sheet ───────────────────────────────────────────────────
class _AddFeedTypeSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AddFeedTypeSheet> createState() => _AddFeedTypeSheetState();
}

class _AddFeedTypeSheetState extends ConsumerState<_AddFeedTypeSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _threshCtrl = TextEditingController(text: '50');
  final _priceCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    _stockCtrl.dispose();
    _threshCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Add Feed Type',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark)),
              const SizedBox(height: 20),

              const _Label('Feed Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Layer Pellets, Broiler Starter',
                  prefixIcon: Icon(Icons.grass_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 12),

              const _Label('Brand (optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _brandCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. CIC Feeds, Prima Feeds',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Opening Stock (kg)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _stockCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                              hintText: '100', suffixText: 'kg'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (double.tryParse(v) == null) return 'Invalid';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Low Stock Alert'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _threshCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                              hintText: '50', suffixText: 'kg'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (double.tryParse(v) == null) return 'Invalid';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _Label('Price per kg (LKR) — optional'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: '95',
                  prefixText: 'LKR ',
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _save,
                child: const Text('Add Feed Type'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final ft = FeedTypeModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      farmId: 'farm1',
      name: _nameCtrl.text.trim(),
      brand: _brandCtrl.text.trim().isEmpty ? null : _brandCtrl.text.trim(),
      currentStockKg: double.parse(_stockCtrl.text),
      lowStockThresholdKg: double.parse(_threshCtrl.text),
      pricePerKg: double.tryParse(_priceCtrl.text),
      createdAt: DateTime.now(),
    );
    ref.read(feedTypeListProvider.notifier).addFeedType(ft);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${ft.name} added to feed types'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────
class _KpiCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final String sub;
  final Color color;

  const _KpiCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondaryDark),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color)),
            Text(sub,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textHintDark)),
          ],
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) => Text(label,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark));
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondaryDark));
}

class _EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  const _EmptyState(
      {required this.emoji, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 72)),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: AppColors.textSecondaryDark)),
            ],
          ),
        ),
      );
}
