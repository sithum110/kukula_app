import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kukula_app/core/providers/egg_providers.dart';
import 'package:kukula_app/core/providers/feed_providers.dart';
import 'package:kukula_app/core/providers/health_providers.dart';
import 'package:kukula_app/core/routing/app_router.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/feeding/feed_model.dart';
import 'package:kukula_app/features/health/health_model.dart';

class StockOverviewScreen extends ConsumerStatefulWidget {
  const StockOverviewScreen({super.key});

  @override
  ConsumerState<StockOverviewScreen> createState() =>
      _StockOverviewScreenState();
}

class _StockOverviewScreenState extends ConsumerState<StockOverviewScreen>
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
    // Compute total alerts across all modules
    final feedTypes = ref.watch(feedTypeListProvider);
    final feedLow = feedTypes.where((f) => f.isLowStock).length;
    ref.watch(medicineStockProvider);
    final medAlerts = ref.watch(medicineStockProvider.notifier).alertCount;
    final totalAlerts = feedLow + medAlerts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Overview'),
        actions: [
          if (totalAlerts > 0)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.warning_amber_rounded),
                  onPressed: () => context.push(AppRoutes.alertCenter),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    width: 16, height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.error, shape: BoxShape.circle),
                    child: Center(
                      child: Text('$totalAlerts',
                          style: const TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
        ],
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryDark,
          tabs: [
            Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('🌾', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                const Text('Feed'),
                if (feedLow > 0) ...[
                  const SizedBox(width: 4),
                  _AlertBadge(count: feedLow),
                ],
              ]),
            ),
            Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('💊', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                const Text('Medicine'),
                if (medAlerts > 0) ...[
                  const SizedBox(width: 4),
                  _AlertBadge(count: medAlerts),
                ],
              ]),
            ),
            const Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('🥚', style: TextStyle(fontSize: 14)),
                SizedBox(width: 4),
                Text('Eggs'),
              ]),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _FeedStockTab(),
          _MedicineStockTab(),
          _EggStockTab(),
        ],
      ),
    );
  }
}

// ── Feed Stock Tab ─────────────────────────────────────────────────────────
class _FeedStockTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feeds = ref.watch(feedTypeListProvider);
    final notifier = ref.watch(feedTypeListProvider.notifier);
    ref.watch(feedLogListProvider);

    if (feeds.isEmpty) {
      return _EmptyState(
        emoji: '🌾',
        title: 'No Feed Types',
        subtitle: 'Add feed types in the Feeding section.',
        actionLabel: 'Go to Feeding',
        onAction: () => context.push(AppRoutes.feeding),
      );
    }

    final totalKg = feeds.fold(0.0, (s, f) => s + f.currentStockKg);
    final lowFeeds = feeds.where((f) => f.isLowStock).toList();
    final weeklyKg = ref.watch(feedLogListProvider.notifier).totalKgThisWeek;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Summary Banner
        _SummaryBanner(
          items: [
            _SummaryItem('📦 Total Stock', '${totalKg.toStringAsFixed(0)} kg',
                AppColors.primary),
            _SummaryItem('🌾 This Week', '${weeklyKg.toStringAsFixed(1)} kg',
                AppColors.info),
            _SummaryItem('⚠️ Low Stock', '${lowFeeds.length} items',
                lowFeeds.isEmpty ? AppColors.success : AppColors.warning),
          ],
        ),
        const SizedBox(height: 16),

        if (lowFeeds.isNotEmpty) ...[
          _SectionHeader('⚠️ Low Stock — Action Needed', AppColors.warning),
          const SizedBox(height: 8),
          ...lowFeeds.map((f) => _FeedStockCard(
                feed: f,
                highlight: true,
                onRestock: () => _showRestockSheet(context, ref, f),
              )),
          const SizedBox(height: 16),
        ],

        _SectionHeader('✅ All Feed Types', AppColors.textSecondaryDark),
        const SizedBox(height: 8),
        ...feeds
            .where((f) => !f.isLowStock)
            .map((f) => _FeedStockCard(
                  feed: f,
                  highlight: false,
                  onRestock: () => _showRestockSheet(context, ref, f),
                )),

        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.push(AppRoutes.feeding),
          icon: const Icon(Icons.open_in_new, size: 16),
          label: const Text('Manage Feed in Feeding Module'),
        ),
      ],
    );
  }

  void _showRestockSheet(
      BuildContext context, WidgetRef ref, FeedTypeModel feed) {
    final ctrl = TextEditingController();
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
            Text('Restock — ${feed.name}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark)),
            const SizedBox(height: 4),
            Text(
                'Current: ${feed.currentStockKg.toStringAsFixed(1)} kg  |  Min: ${feed.lowStockThresholdKg.toStringAsFixed(0)} kg',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondaryDark)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                  labelText: 'Add quantity (kg)', suffixText: 'kg'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final kg = double.tryParse(ctrl.text) ?? 0;
                if (kg > 0) {
                  ref
                      .read(feedTypeListProvider.notifier)
                      .addStock(feed.id, kg);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('✅ Added ${kg.toStringAsFixed(1)} kg to ${feed.name}'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ));
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              child: const Text('Restock'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedStockCard extends ConsumerWidget {
  final FeedTypeModel feed;
  final bool highlight;
  final VoidCallback onRestock;
  const _FeedStockCard(
      {required this.feed,
      required this.highlight,
      required this.onRestock});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pct = feed.lowStockThresholdKg > 0
        ? (feed.currentStockKg / (feed.lowStockThresholdKg * 3))
            .clamp(0.0, 1.0)
        : 1.0;
    final color = feed.isLowStock ? AppColors.warning : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight
              ? AppColors.warning.withValues(alpha: 0.4)
              : AppColors.borderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                  child: Text('🌾', style: TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(feed.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryDark)),
                  if (feed.brand != null)
                    Text(feed.brand!,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryDark)),
                ],
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                '${feed.currentStockKg.toStringAsFixed(1)} kg',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color),
              ),
              Text('min ${feed.lowStockThresholdKg.toStringAsFixed(0)} kg',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textHintDark)),
            ]),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppColors.borderDark,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 7,
            ),
          ),
          const SizedBox(height: 10),
          Row(children: [
            if (feed.pricePerKg != null)
              Text(
                'LKR ${feed.pricePerKg!.toStringAsFixed(0)}/kg  ·  Value: LKR ${(feed.currentStockKg * feed.pricePerKg!).toStringAsFixed(0)}',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondaryDark),
              ),
            const Spacer(),
            TextButton.icon(
              onPressed: onRestock,
              icon: const Icon(Icons.add_circle_outline, size: 14),
              label: const Text('Restock', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.success,
                backgroundColor: AppColors.success.withValues(alpha: 0.08),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

// ── Medicine Stock Tab ─────────────────────────────────────────────────────
class _MedicineStockTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(medicineStockProvider);
    final notifier = ref.watch(medicineStockProvider.notifier);
    ref.watch(medicineStockProvider);

    final expired = notifier.expiredItems;
    final expiring = notifier.expiringItems;
    final low = notifier.lowStockItems;
    final ok = items
        .where((m) => !m.isLowStock && !m.isExpired && !m.isExpiringSoon)
        .toList();

    final totalValue = items.fold(
        0.0,
        (s, m) =>
            s + m.currentQty * (m.pricePerUnit ?? 0));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Summary banner
        _SummaryBanner(
          items: [
            _SummaryItem('💊 Total Items', '${items.length}', AppColors.info),
            _SummaryItem('⚠️ Alerts',
                '${expired.length + expiring.length + low.length}',
                expired.isNotEmpty ? AppColors.error : AppColors.warning),
            _SummaryItem('💰 Value',
                'LKR ${totalValue.toStringAsFixed(0)}', AppColors.success),
          ],
        ),
        const SizedBox(height: 16),

        if (expired.isNotEmpty) ...[
          _SectionHeader('🚫 Expired — Discard Immediately', AppColors.error),
          const SizedBox(height: 8),
          ...expired.map((m) => _MedStockCard(item: m)),
          const SizedBox(height: 16),
        ],
        if (expiring.isNotEmpty) ...[
          _SectionHeader('⏰ Expiring Within 30 Days', AppColors.warning),
          const SizedBox(height: 8),
          ...expiring.map((m) => _MedStockCard(item: m)),
          const SizedBox(height: 16),
        ],
        if (low.isNotEmpty) ...[
          _SectionHeader('📉 Low Stock', AppColors.warning),
          const SizedBox(height: 8),
          ...low.map((m) => _MedStockCard(item: m)),
          const SizedBox(height: 16),
        ],
        if (ok.isNotEmpty) ...[
          _SectionHeader('✅ In Stock', AppColors.success),
          const SizedBox(height: 8),
          ...ok.map((m) => _MedStockCard(item: m)),
          const SizedBox(height: 16),
        ],

        OutlinedButton.icon(
          onPressed: () => context.push(AppRoutes.health),
          icon: const Icon(Icons.open_in_new, size: 16),
          label: const Text('Manage in Health Module'),
        ),
      ],
    );
  }
}

class _MedStockCard extends ConsumerWidget {
  final MedicineStockModel item;
  const _MedStockCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysToExpiry = item.expiryDate != null
        ? item.expiryDate!.difference(DateTime.now()).inDays
        : null;
    final stockPct = item.lowStockThreshold > 0
        ? (item.currentQty / (item.lowStockThreshold * 3)).clamp(0.0, 1.0)
        : 1.0;

    Color accent;
    if (item.isExpired) {
      accent = AppColors.error;
    } else if (item.isExpiringSoon || item.isLowStock) {
      accent = AppColors.warning;
    } else {
      accent = AppColors.success;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                    item.stockType == MedicineStockType.vaccine
                        ? '💉'
                        : '💊',
                    style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryDark)),
                  if (item.manufacturer != null)
                    Text(item.manufacturer!,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryDark)),
                ],
              ),
            ),
            if (item.expiryDate != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.isExpired
                      ? 'EXPIRED'
                      : daysToExpiry != null && daysToExpiry <= 30
                          ? 'Exp in $daysToExpiry d'
                          : '${item.expiryDate!.day}/${item.expiryDate!.month}/${item.expiryDate!.year}',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: accent),
                ),
              ),
          ]),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${item.currentQty.toStringAsFixed(0)} ${item.unit ?? 'units'}',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: item.isLowStock
                        ? AppColors.warning
                        : AppColors.textPrimaryDark),
              ),
              Text('Min: ${item.lowStockThreshold.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textHintDark)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stockPct,
              backgroundColor: AppColors.borderDark,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            if (item.pricePerUnit != null)
              Text(
                'LKR ${item.pricePerUnit!.toStringAsFixed(0)}/${item.unit ?? 'unit'}  ·  Value: LKR ${(item.currentQty * item.pricePerUnit!).toStringAsFixed(0)}',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondaryDark),
              ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _showRestockSheet(context, ref, item),
              icon: const Icon(Icons.add_circle_outline, size: 14),
              label: const Text('Restock', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.success,
                backgroundColor: AppColors.success.withValues(alpha: 0.08),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  void _showRestockSheet(
      BuildContext context, WidgetRef ref, MedicineStockModel item) {
    final ctrl = TextEditingController();
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
            Text('Restock — ${item.name}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark)),
            const SizedBox(height: 4),
            Text(
                'Current: ${item.currentQty.toStringAsFixed(0)} ${item.unit ?? 'units'}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondaryDark)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Add quantity',
                  suffixText: item.unit ?? 'units'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final qty = double.tryParse(ctrl.text) ?? 0;
                if (qty > 0) {
                  ref
                      .read(medicineStockProvider.notifier)
                      .addStock(item.id, qty);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      '✅ Added ${qty.toStringAsFixed(0)} ${item.unit ?? 'units'} to ${item.name}'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ));
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

// ── Egg Stock Tab ──────────────────────────────────────────────────────────
class _EggStockTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockEggs = ref.watch(eggStockProvider);
    final totalTrays = stockEggs / 30;
    final collections = ref.watch(eggRecordListProvider);
    final recentCollections = collections.take(5).toList();

    // Stats
    final todayCount = collections.isEmpty
        ? 0
        : collections
            .where((e) {
              final now = DateTime.now();
              return e.date.year == now.year &&
                  e.date.month == now.month &&
                  e.date.day == now.day;
            })
            .fold(0, (s, e) => s + e.goodEggs);

    final weekTotal = collections
        .where((e) =>
            e.date.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .fold(0, (s, e) => s + e.goodEggs);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Summary banner
        _SummaryBanner(
          items: [
            _SummaryItem('🥚 In Stock', '$stockEggs eggs', AppColors.eggAccent),
            _SummaryItem('📦 Trays', '${totalTrays.toStringAsFixed(1)}',
                AppColors.eggAccent),
            _SummaryItem('📅 This Week', '$weekTotal eggs', AppColors.info),
          ],
        ),
        const SizedBox(height: 16),

        // Stock value card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.eggAccent.withValues(alpha: 0.3),
                AppColors.eggAccent.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.eggAccent.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Text('🥚', style: TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Egg Stock',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryDark)),
                    Text(
                      '$stockEggs eggs',
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.eggAccent),
                    ),
                    Text(
                      '${totalTrays.toStringAsFixed(1)} trays · ${(totalTrays / 10).toStringAsFixed(1)} crates',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Today's stats
        Row(children: [
          Expanded(
            child: _StatMiniCard(
              emoji: '☀️',
              label: "Today's Collection",
              value: '$todayCount eggs',
              color: AppColors.info,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatMiniCard(
              emoji: '📦',
              label: 'Est. Value @ LKR 50',
              value:
                  'LKR ${(stockEggs * 50).toStringAsFixed(0)}',
              color: AppColors.success,
            ),
          ),
        ]),
        const SizedBox(height: 20),

        // Recent collections
        _SectionHeader('🕐 Recent Collections', AppColors.textSecondaryDark),
        const SizedBox(height: 10),
        if (recentCollections.isEmpty)
          const _EmptyCard(label: 'No collections recorded yet')
        else
          ...recentCollections.map((c) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(children: [
                  const Text('🥚', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.flockId != null ? 'Flock ${c.flockId}' : 'Farm-wide',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryDark),
                        ),
                        Text(
                          '${c.date.day}/${c.date.month}/${c.date.year}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondaryDark),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${c.goodEggs} eggs',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.eggAccent),
                      ),
                      Text(
                        '${c.traysCount} trays',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondaryDark),
                      ),
                    ],
                  ),
                ]),
              )),

        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => context.push(AppRoutes.eggs),
          icon: const Icon(Icons.open_in_new, size: 16),
          label: const Text('Manage Egg Production'),
        ),
      ],
    );
  }
}

// ── Shared Widgets ─────────────────────────────────────────────────────────
class _SummaryBanner extends StatelessWidget {
  final List<_SummaryItem> items;
  const _SummaryBanner({required this.items});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: items
              .expand((item) => [
                    Expanded(child: item),
                    if (item != items.last)
                      Container(
                          width: 1,
                          height: 36,
                          color: AppColors.borderDark),
                  ])
              .toList(),
        ),
      );
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryItem(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondaryDark)),
        ],
      );
}

class _StatMiniCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  const _StatMiniCard(
      {required this.emoji,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondaryDark)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700, color: color),
              overflow: TextOverflow.ellipsis),
        ]),
      );
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionHeader(this.label, this.color);
  @override
  Widget build(BuildContext context) => Text(label,
      style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w700, color: color));
}

class _AlertBadge extends StatelessWidget {
  final int count;
  const _AlertBadge({required this.count});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('$count',
            style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w700)),
      );
}

class _EmptyCard extends StatelessWidget {
  final String label;
  const _EmptyCard({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Center(
            child: Text(label,
                style: const TextStyle(color: AppColors.textHintDark))),
      );
}

class _EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;
  const _EmptyState(
      {required this.emoji,
      required this.title,
      required this.subtitle,
      required this.actionLabel,
      required this.onAction});
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondaryDark)),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel)),
            ],
          ),
        ),
      );
}
