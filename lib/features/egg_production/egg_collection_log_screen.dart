import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kukula_app/core/providers/egg_providers.dart';
import 'package:kukula_app/core/routing/app_router.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/egg_production/egg_model.dart';
import 'package:kukula_app/l10n/app_localizations.dart';

class EggCollectionLogScreen extends ConsumerStatefulWidget {
  const EggCollectionLogScreen({super.key});

  @override
  ConsumerState<EggCollectionLogScreen> createState() =>
      _EggCollectionLogScreenState();
}

class _EggCollectionLogScreenState
    extends ConsumerState<EggCollectionLogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = ref.watch(eggRecordListProvider);
    final stock = ref.watch(eggStockProvider);
    final notifier = ref.read(eggRecordListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.eggCollection),
        actions: [
          IconButton(
            icon: const Icon(Icons.sell_outlined),
            tooltip: 'Egg Sales',
            onPressed: () => context.push(AppRoutes.eggSales),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppColors.eggAccent,
          labelColor: AppColors.eggAccent,
          unselectedLabelColor: AppColors.textSecondaryDark,
          tabs: const [
            Tab(text: 'Collection Log'),
            Tab(text: 'Overview'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _LogTab(records: records, stock: stock),
          _OverviewTab(records: records, stock: stock, notifier: notifier),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addEggCollection),
        icon: const Icon(Icons.add),
        label: Text(l10n.addEggCollection),
        backgroundColor: AppColors.eggAccent,
      ),
    );
  }
}

// ── Log Tab ───────────────────────────────────────────────────────────────
class _LogTab extends ConsumerWidget {
  final List<EggRecordModel> records;
  final int stock;

  const _LogTab({required this.records, required this.stock});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (records.isEmpty) {
      return const _EmptyLog();
    }

    // Group by date
    final grouped = <String, List<EggRecordModel>>{};
    for (final r in records) {
      final key = _dateKey(r.date);
      grouped.putIfAbsent(key, () => []).add(r);
    }

    return Column(
      children: [
        // Stock banner
        _StockBanner(stock: stock),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
            itemCount: grouped.length,
            itemBuilder: (_, i) {
              final dateKey = grouped.keys.toList()[i];
              final dayRecords = grouped[dateKey]!;
              final dayTotal = dayRecords.fold(0, (s, r) => s + r.goodEggs);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.eggAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(dateKey,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.eggAccent)),
                        ),
                        const SizedBox(width: 8),
                        Text('$dayTotal eggs · ${dayTotal ~/ 30} trays',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondaryDark)),
                      ],
                    ),
                  ),
                  ...dayRecords.map((r) => _EggRecordTile(record: r)),
                  const SizedBox(height: 4),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String _dateKey(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (d.year == yesterday.year &&
        d.month == yesterday.month &&
        d.day == yesterday.day) {
      return 'Yesterday';
    }
    return '${d.day.toString().padLeft(2, '0')} ${_month(d.month)} ${d.year}';
  }

  String _month(int m) => [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
}

// ── Overview Tab ──────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final List<EggRecordModel> records;
  final int stock;
  final EggRecordNotifier notifier;

  const _OverviewTab({
    required this.records,
    required this.stock,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final weekTotals = notifier.weeklyTotals;
    final weekSum = weekTotals.fold(0, (a, b) => a + b);
    final avgPerDay = records.isEmpty ? 0 : weekSum ~/ 7;
    final maxVal = weekTotals.reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI row
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  emoji: '🥚',
                  label: "Today's Eggs",
                  value: notifier.todayTotal.toString(),
                  sub: '${notifier.todayTotal ~/ 30} trays',
                  color: AppColors.eggAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiCard(
                  emoji: '📦',
                  label: 'Stock on Hand',
                  value: stock.toString(),
                  sub: '${stock ~/ 30} trays',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  emoji: '📅',
                  label: '7-Day Total',
                  value: weekSum.toString(),
                  sub: '${weekSum ~/ 30} trays',
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiCard(
                  emoji: '📊',
                  label: 'Daily Avg',
                  value: avgPerDay.toString(),
                  sub: '${avgPerDay ~/ 30} trays/day',
                  color: AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text('7-Day Collection Chart',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark)),
          const SizedBox(height: 16),

          // Simple bar chart
          _BarChart(weeklyTotals: weekTotals, maxVal: maxVal),

          const SizedBox(height: 24),
          const Text('Grade Breakdown (Latest)',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark)),
          const SizedBox(height: 12),
          if (records.isNotEmpty)
            _GradeBreakdown(record: records.first)
          else
            const Text('No records yet.',
                style: TextStyle(color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }
}

// ── Bar Chart (custom, no package needed) ────────────────────────────────
class _BarChart extends StatelessWidget {
  final List<int> weeklyTotals;
  final int maxVal;

  const _BarChart({required this.weeklyTotals, required this.maxVal});

  @override
  Widget build(BuildContext context) {
    final days = ['6d', '5d', '4d', '3d', '2d', 'Yest', 'Today'];

    return Container(
      height: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (i) {
          final val = weeklyTotals[i];
          final height = maxVal > 0 ? (val / maxVal * 100.0) : 0.0;
          final isToday = i == 6;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(val > 0 ? val.toString() : '',
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.textHintDark)),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: 28,
                height: height,
                decoration: BoxDecoration(
                  color: isToday
                      ? AppColors.eggAccent
                      : AppColors.eggAccent.withValues(alpha: 0.45),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6)),
                ),
              ),
              const SizedBox(height: 4),
              Text(days[i],
                  style: TextStyle(
                      fontSize: 9,
                      color: isToday
                          ? AppColors.eggAccent
                          : AppColors.textHintDark,
                      fontWeight:
                          isToday ? FontWeight.w700 : FontWeight.normal)),
            ],
          );
        }),
      ),
    );
  }
}

// ── Grade Breakdown ───────────────────────────────────────────────────────
class _GradeBreakdown extends StatelessWidget {
  final EggRecordModel record;
  const _GradeBreakdown({required this.record});

  @override
  Widget build(BuildContext context) {
    final total = record.goodEggs;
    final grades = [
      _GradeItem('Grade A', record.gradeA ?? 0, AppColors.success),
      _GradeItem('Grade B', record.gradeB ?? 0, AppColors.warning),
      _GradeItem('Grade C', record.gradeC ?? 0, AppColors.error),
      _GradeItem('Broken', record.brokenEggs, AppColors.textHintDark),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        children: grades.map((g) {
          final pct = total > 0 ? g.count / record.totalEggs : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(g.label,
                        style: TextStyle(
                            fontSize: 13,
                            color: g.color,
                            fontWeight: FontWeight.w600)),
                    Text('${g.count} eggs (${(pct * 100).toStringAsFixed(0)}%)',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryDark)),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: AppColors.borderDark,
                    valueColor: AlwaysStoppedAnimation<Color>(g.color),
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

class _GradeItem {
  final String label;
  final int count;
  final Color color;
  const _GradeItem(this.label, this.count, this.color);
}

// ── Record Tile ───────────────────────────────────────────────────────────
class _EggRecordTile extends ConsumerWidget {
  final EggRecordModel record;
  const _EggRecordTile({required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) {
        ref.read(eggRecordListProvider.notifier).deleteRecord(record.id);
        ref.read(eggStockProvider.notifier).removeEggs(record.goodEggs);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Record deleted'),
          behavior: SnackBarBehavior.floating,
        ));
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
                color: AppColors.eggAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                  child: Text('🥚', style: TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${record.goodEggs} eggs',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryDark)),
                      const SizedBox(width: 6),
                      Text('· ${record.traysCount} trays',
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondaryDark)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      _Pip('A: ${record.gradeA ?? '–'}',
                          AppColors.success),
                      const SizedBox(width: 6),
                      _Pip('B: ${record.gradeB ?? '–'}', AppColors.warning),
                      const SizedBox(width: 6),
                      _Pip('Broken: ${record.brokenEggs}', AppColors.error),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_timeStr(record.date),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHintDark)),
                const SizedBox(height: 4),
                Text('by ${record.collectedBy}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondaryDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeStr(DateTime d) {
    final now = DateTime.now();
    if (d.day == now.day) return 'Today';
    return '${d.day}/${d.month}';
  }
}

class _Pip extends StatelessWidget {
  final String label;
  final Color color;
  const _Pip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style:
                TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
      );
}

// ── Stock Banner ──────────────────────────────────────────────────────────
class _StockBanner extends StatelessWidget {
  final int stock;
  const _StockBanner({required this.stock});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.eggAccent.withValues(alpha: 0.2),
            AppColors.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.eggAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('📦', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Egg Stock on Hand',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondaryDark)),
              Text('$stock eggs · ${stock ~/ 30} trays',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.eggAccent)),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.eggAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Sell',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

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
  Widget build(BuildContext context) {
    return Container(
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
                        fontSize: 11, color: AppColors.textSecondaryDark),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: color)),
          Text(sub,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textHintDark)),
        ],
      ),
    );
  }
}

class _EmptyLog extends StatelessWidget {
  const _EmptyLog();
  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🥚', style: TextStyle(fontSize: 72)),
            SizedBox(height: 16),
            Text('No Collections Yet',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryDark)),
            SizedBox(height: 8),
            Text('Tap + to log your first egg collection.',
                style: TextStyle(color: AppColors.textSecondaryDark)),
          ],
        ),
      );
}
