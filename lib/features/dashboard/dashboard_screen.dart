import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kukula_app/core/providers/farm_providers.dart';
import 'package:kukula_app/core/providers/batch_providers.dart';
import 'package:kukula_app/core/providers/feed_providers.dart';
import 'package:kukula_app/core/providers/finance_providers.dart';
import 'package:kukula_app/core/providers/health_providers.dart';
import 'package:kukula_app/core/providers/theme_provider.dart';
import 'package:kukula_app/core/providers/user_providers.dart';
import 'package:kukula_app/core/routing/app_router.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/core/enums/farm_type.dart';
import 'package:kukula_app/core/enums/user_role.dart';
import 'package:kukula_app/features/flocks/flock_model.dart';
import 'package:kukula_app/features/meat_batches/batch_model.dart';
import 'package:kukula_app/l10n/app_localizations.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final farmType = ref.watch(farmTypeProvider);
    final farmName = ref.watch(farmNameProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final l10n = AppLocalizations.of(context);
    final currentRole = ref.watch(currentRoleProvider);
    final isWorker = currentRole == UserRole.worker;
    final navItems = _navItems(farmType, l10n, isWorker: isWorker);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dashboard,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700)),
            Text(farmName,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondaryDark)),
          ],
        ),
        actions: [
          // Worker mode chip
          if (isWorker)
            Container(
              margin: const EdgeInsets.only(right: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.info.withValues(alpha: 0.4)),
              ),
              child: const Text('👷 Worker',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.info,
                      fontWeight: FontWeight.w700)),
            ),
          // Theme toggle
          Consumer(builder: (_, ref, __) {
            final isDark = ref.watch(themeProvider).isDark;
            return IconButton(
              tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Icon(
                  isDark
                      ? Icons.nights_stay_rounded
                      : Icons.wb_sunny_rounded,
                  key: ValueKey(isDark),
                  color: isDark ? const Color(0xFF90CAF9) : AppColors.warning,
                ),
              ),
              onPressed: () => ref.read(themeProvider.notifier).toggle(),
            );
          }),
          _AlertBell(),
        ],
      ),
      drawer: _AppDrawer(farmType: farmType, isPremium: isPremium, farmName: farmName),
      body: _DashboardBody(farmType: farmType, l10n: l10n, isWorker: isWorker),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) {
          setState(() => _selectedIndex = i);
          final route = navItems[i].route;
          if (route == AppRoutes.dashboard) {
            // Home: go() clears any pushed screens and returns to dashboard root
            context.go(AppRoutes.dashboard);
          } else {
            // Other tabs: push() keeps dashboard in the stack — Back returns here
            context.push(route);
          }
        },
        destinations: navItems
            .map((item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.activeIcon),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }

  List<_NavItem> _navItems(FarmType farmType, AppLocalizations l10n, {bool isWorker = false}) {
    final items = <_NavItem>[
      _NavItem(Icons.home_outlined, Icons.home_rounded, l10n.dashboard, AppRoutes.dashboard),
    ];
    if (farmType.hasEggs) {
      items.add(_NavItem(Icons.egg_outlined, Icons.egg_rounded, l10n.eggs, AppRoutes.eggs));
    }
    if (farmType.hasMeat) {
      items.add(_NavItem(Icons.set_meal_outlined, Icons.set_meal, l10n.batches, AppRoutes.batches));
    }
    items.add(_NavItem(Icons.grass_outlined, Icons.grass, l10n.feeding, AppRoutes.feeding));
    if (!isWorker) {
      items.add(_NavItem(Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, l10n.finance, AppRoutes.finance));
    }
    return items;
  }
}

// ── Dashboard Body ────────────────────────────────────────────────────────
class _DashboardBody extends ConsumerWidget {
  final FarmType farmType;
  final AppLocalizations l10n;
  final bool isWorker;

  const _DashboardBody({required this.farmType, required this.l10n, required this.isWorker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => await Future.delayed(const Duration(milliseconds: 500)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _QuickActions(farmType: farmType, l10n: l10n),
            const SizedBox(height: 20),

            if (farmType.hasEggs) ...[
              _SectionHeader('🥚 Egg Farm Overview'),
              const SizedBox(height: 12),
              _EggSection(l10n: l10n),
              const SizedBox(height: 20),
            ],

            if (farmType.hasMeat) ...[
              _SectionHeader('🐔 Broiler Farm Overview'),
              const SizedBox(height: 12),
              _MeatSection(l10n: l10n),
              const SizedBox(height: 20),
            ],

            // Finance: hidden from workers
            if (!isWorker) ...[
              _SectionHeader('💰 Finance'),
              const SizedBox(height: 12),
              _FinanceDashSection(),
              const SizedBox(height: 20),
            ],

            _SectionHeader('🌾 Feed Stock'),
            const SizedBox(height: 12),
            _FeedDashSection(),
            const SizedBox(height: 20),

            _SectionHeader('🏥 Health & Vaccines'),
            const SizedBox(height: 12),
            _HealthDashSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}


// ── Finance Dashboard Section (live data) ─────────────────────────────────
class _FinanceDashSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(financeProvider);
    final notifier = ref.watch(financeProvider.notifier);
    final monthProfit = notifier.monthProfit;
    final monthIncome = notifier.monthIncome;
    final monthExpense = notifier.monthExpense;
    final isProfit = monthProfit >= 0;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: isProfit ? '📈' : '📉',
            title: 'This Month Net',
            value:
                '${isProfit ? '+' : ''}LKR ${monthProfit.toStringAsFixed(0)}',
            subtitle: isProfit ? '✅ Profitable' : '⚠️ Running at loss',
            color: isProfit ? AppColors.success : AppColors.error,
            onTap: () => context.push(AppRoutes.finance),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: '💰',
            title: 'Income / Expense',
            value: 'LKR ${monthIncome.toStringAsFixed(0)}',
            subtitle: '↓ LKR ${monthExpense.toStringAsFixed(0)} spent',
            color: AppColors.info,
            onTap: () => context.push(AppRoutes.finance),
          ),
        ),
      ],
    );
  }
}

// ── Feed Dashboard Section (live data) ───────────────────────────────────
class _FeedDashSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedTypes = ref.watch(feedTypeListProvider);
    final logNotifier = ref.watch(feedLogListProvider.notifier);
    ref.watch(feedLogListProvider); // subscribe to updates

    final lowCount = feedTypes.where((f) => f.isLowStock).length;
    final weeklyKg = logNotifier.totalKgThisWeek;
    final totalStockKg = feedTypes.fold(0.0, (s, f) => s + f.currentStockKg);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: '🌾',
            title: 'Feed This Week',
            value: '${weeklyKg.toStringAsFixed(1)} kg',
            subtitle: 'consumed',
            color: AppColors.primary,
            onTap: () => context.push(AppRoutes.feeding),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: '📦',
            title: 'Feed Stock',
            value: '${totalStockKg.toStringAsFixed(0)} kg',
            subtitle: lowCount > 0
                ? '⚠️ $lowCount item${lowCount > 1 ? 's' : ''} low'
                : '✅ All stocked',
            color: lowCount > 0 ? AppColors.warning : AppColors.success,
            onTap: () => context.push(AppRoutes.feeding),
          ),
        ),
      ],
    );
  }
}

// ── Health Dashboard Section (live data) ──────────────────────────────────
class _HealthDashSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(vaccinationScheduleProvider);
    ref.watch(medicineStockProvider);
    final scheduleNotifier = ref.watch(vaccinationScheduleProvider.notifier);
    final medNotifier = ref.watch(medicineStockProvider.notifier);

    final overdueCount = scheduleNotifier.overdue.length;
    final dueSoonCount = scheduleNotifier.dueSoon.length;
    final medAlertCount = medNotifier.alertCount;

    String schedSub;
    Color schedColor;
    if (overdueCount > 0) {
      schedSub = '🚨 $overdueCount vaccine overdue!';
      schedColor = AppColors.error;
    } else if (dueSoonCount > 0) {
      schedSub = '⚠️ $dueSoonCount due within 7 days';
      schedColor = AppColors.warning;
    } else {
      schedSub = '✅ Schedule up to date';
      schedColor = AppColors.success;
    }

    String medSub;
    Color medColor;
    if (medNotifier.expiredItems.isNotEmpty) {
      medSub = '🚫 ${medNotifier.expiredItems.length} expired item';
      medColor = AppColors.error;
    } else if (medAlertCount > 0) {
      medSub = '⚠️ $medAlertCount item needs attention';
      medColor = AppColors.warning;
    } else {
      medSub = '✅ Medicine stock OK';
      medColor = AppColors.success;
    }

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: '💉',
            title: 'Vaccinations',
            value: overdueCount > 0 ? '$overdueCount Overdue' : '${scheduleNotifier.upcoming.length + dueSoonCount} Upcoming',
            subtitle: schedSub,
            color: schedColor,
            onTap: () => context.push(AppRoutes.health),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: '💊',
            title: 'Medicine Stock',
            value: medAlertCount > 0 ? '$medAlertCount Alerts' : 'Normal',
            subtitle: medSub,
            color: medColor,
            onTap: () => context.push(AppRoutes.health),
          ),
        ),
      ],
    );
  }
}

// ── Egg Section (live data) ───────────────────────────────────────────────
class _EggSection extends ConsumerWidget {
  final AppLocalizations l10n;
  const _EggSection({required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flocks = ref.watch(flockListProvider);
    final activeFlocks = flocks.where((f) => f.status == FlockStatus.active).toList();
    final totalBirds = activeFlocks.fold(0, (s, f) => s + f.currentCount);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: '🥚',
                title: l10n.todaysCollection,
                value: '342',
                subtitle: '11.4 trays',
                color: AppColors.eggAccent,
                onTap: () => context.push(AppRoutes.eggs),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: '📦',
                title: 'Egg Stock',
                value: '1,240',
                subtitle: '41 trays on hand',
                color: AppColors.primary,
                onTap: () => context.push(AppRoutes.eggs),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: '🐔',
                title: 'Active Flocks',
                value: activeFlocks.length.toString(),
                subtitle: '$totalBirds birds total',
                color: AppColors.info,
                onTap: () => context.push(AppRoutes.flocks),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: '💸',
                title: 'Last Egg Sale',
                value: 'LKR 8,400',
                subtitle: 'Today',
                color: AppColors.success,
                onTap: () => context.push(AppRoutes.eggSales),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Meat Section (live data) ──────────────────────────────────────────────
class _MeatSection extends ConsumerWidget {
  final AppLocalizations l10n;
  const _MeatSection({required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batches = ref.watch(batchListProvider);
    final sales = ref.watch(meatSalesProvider);
    final growing = batches.where((b) => b.status == BatchStatus.growing).toList();
    final totalBirds = growing.fold(0, (s, b) => s + b.currentCount);
    final totalRevenue = sales.fold(0.0, (s, sale) => s + sale.totalAmount);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: '🐔',
            title: 'Active Batches',
            value: growing.length.toString(),
            subtitle: '$totalBirds birds growing',
            color: AppColors.meatAccent,
            onTap: () => context.push(AppRoutes.batches),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: '💸',
            title: 'Total Sales',
            value: totalRevenue > 0
                ? 'LKR ${totalRevenue.toStringAsFixed(0)}'
                : 'No sales yet',
            subtitle: '${sales.length} transactions',
            color: AppColors.success,
            onTap: () => context.push(AppRoutes.meatSales),
          ),
        ),
      ],
    );
  }
}

// ── Quick Actions ─────────────────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  final FarmType farmType;
  final AppLocalizations l10n;

  const _QuickActions({required this.farmType, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final actions = <_ActionItem>[];
    if (farmType.hasEggs) {
      actions.add(_ActionItem('🥚', l10n.addEggCollection, AppRoutes.addEggCollection, AppColors.eggAccent));
    }
    if (farmType.hasMeat) {
      actions.add(_ActionItem('🍗', l10n.addMeatSale, AppRoutes.meatSales, AppColors.meatAccent));
    }
    actions.addAll([
      _ActionItem('🌾', l10n.addFeedLog, AppRoutes.feeding, AppColors.primary),
      _ActionItem('💊', l10n.addHealthRecord, AppRoutes.health, AppColors.info),
    ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondaryDark,
                letterSpacing: 0.5)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: actions
                .map((a) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => context.push(a.route),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: a.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: a.color.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(a.icon,
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(a.label,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: a.color)),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ── Alert Bell (live total count) ─────────────────────────────────────────
class _AlertBell extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedTypes = ref.watch(feedTypeListProvider);
    final feedLow = feedTypes.where((f) => f.isLowStock).length;
    ref.watch(vaccinationScheduleProvider);
    ref.watch(medicineStockProvider);
    final scheduleAlerts =
        ref.watch(vaccinationScheduleProvider.notifier).alertCount;
    final medAlerts = ref.watch(medicineStockProvider.notifier).alertCount;
    final total = feedLow + scheduleAlerts + medAlerts;

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => context.push(AppRoutes.alertCenter),
        ),
        if (total > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: total > 9 ? 16 : 14,
              height: 14,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  total > 9 ? '9+' : '$total',
                  style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── App Drawer ────────────────────────────────────────────────────────────
class _AppDrawer extends StatelessWidget {
  final FarmType farmType;
  final bool isPremium;
  final String farmName;

  const _AppDrawer({
    required this.farmType,
    required this.isPremium,
    required this.farmName,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cardDark,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Text('🐔', style: TextStyle(fontSize: 26))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(farmName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppColors.textPrimaryDark),
                            overflow: TextOverflow.ellipsis),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPremium
                                ? AppColors.premiumGold.withValues(alpha: 0.2)
                                : AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isPremium ? '👑 Premium' : 'Free Plan',
                            style: TextStyle(
                                fontSize: 11,
                                color: isPremium
                                    ? AppColors.premiumGold
                                    : AppColors.primary,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  if (farmType.hasEggs)
                    _DrawerItem(
                        icon: Icons.egg_outlined,
                        label: 'Flocks',
                        route: AppRoutes.flocks),
                  if (farmType.hasMeat)
                    _DrawerItem(
                        icon: Icons.set_meal_outlined,
                        label: 'Batches',
                        route: AppRoutes.batches),
                  _DrawerItem(
                      icon: Icons.inventory_2_outlined,
                      label: 'Stock',
                      route: AppRoutes.stock),
                  _DrawerItem(
                      icon: Icons.medical_services_outlined,
                      label: 'Health',
                      route: AppRoutes.health),
                  _DrawerItem(
                      icon: Icons.bar_chart_rounded,
                      label: 'Reports',
                      route: AppRoutes.reports,
                      isPremiumLocked: !isPremium),
                  _DrawerItem(
                      icon: Icons.people_outline,
                      label: 'Users',
                      route: AppRoutes.users,
                      isPremiumLocked: !isPremium),
                  _DrawerItem(
                      icon: Icons.backup_outlined,
                      label: 'Backup',
                      route: AppRoutes.backup),
                  const Divider(),
                  _DrawerItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      route: AppRoutes.settings),
                ],
              ),
            ),
            if (!isPremium)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Text('👑', style: TextStyle(fontSize: 16)),
                  label: const Text('Upgrade to Premium'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isPremiumLocked;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
    this.isPremiumLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondaryDark, size: 22),
      title: Text(label,
          style: const TextStyle(
              fontSize: 15, color: AppColors.textPrimaryDark)),
      trailing: isPremiumLocked
          ? const Text('👑', style: TextStyle(fontSize: 14))
          : null,
      onTap: () {
        Navigator.pop(context);
        if (!isPremiumLocked) context.push(route);
      },
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryDark,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis),
                ),
                if (onTap != null)
                  const Icon(Icons.chevron_right,
                      size: 16, color: AppColors.textHintDark),
              ],
            ),
            const SizedBox(height: 8),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: color)),
            const SizedBox(height: 2),
            Text(subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textHintDark)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) => Text(title,
      style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark));
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  const _NavItem(this.icon, this.activeIcon, this.label, this.route);
}

class _ActionItem {
  final String icon;
  final String label;
  final String route;
  final Color color;
  const _ActionItem(this.icon, this.label, this.route, this.color);
}
