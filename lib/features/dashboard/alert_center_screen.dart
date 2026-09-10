import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kukula_app/core/providers/feed_providers.dart';
import 'package:kukula_app/core/providers/health_providers.dart';
import 'package:kukula_app/core/routing/app_router.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/feeding/feed_model.dart';
import 'package:kukula_app/l10n/app_localizations.dart';

class AlertCenterScreen extends ConsumerWidget {
  const AlertCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final feedTypes = ref.watch(feedTypeListProvider);
    final lowStockFeeds = feedTypes.where((f) => f.isLowStock).toList();
    final scheduleNotifier = ref.watch(vaccinationScheduleProvider.notifier);
    final medNotifier = ref.watch(medicineStockProvider.notifier);
    ref.watch(vaccinationScheduleProvider);
    ref.watch(medicineStockProvider);

    // Build fully dynamic alert list
    final alerts = <_AlertData>[
      // Feed low stock (live)
      ...lowStockFeeds.map((f) => _AlertData(
            icon: '🌾',
            type: AlertType.warning,
            title: 'Low Feed Stock',
            subtitle:
                '${f.name}: ${f.currentStockKg.toStringAsFixed(1)} kg remaining (min ${f.lowStockThresholdKg.toStringAsFixed(0)} kg)',
            actionLabel: 'Restock',
            actionRoute: AppRoutes.feeding,
            timestamp: DateTime.now(),
          )),

      // Overdue vaccinations (live)
      ...scheduleNotifier.overdue.map((s) => _AlertData(
            icon: '🚨',
            type: AlertType.error,
            title: 'Vaccination Overdue!',
            subtitle:
                '${s.vaccineName}${s.flockName != null ? ' — ${s.flockName}' : ''} — ${s.daysUntilDue.abs()} day${s.daysUntilDue.abs() != 1 ? 's' : ''} overdue',
            actionLabel: 'View Schedule',
            actionRoute: AppRoutes.health,
            timestamp: DateTime.now(),
          )),

      // Due soon vaccinations (live)
      ...scheduleNotifier.dueSoon.map((s) => _AlertData(
            icon: '💉',
            type: AlertType.warning,
            title: 'Vaccination Due Soon',
            subtitle:
                '${s.vaccineName}${s.flockName != null ? ' — ${s.flockName}' : ''} — due in ${s.daysUntilDue} day${s.daysUntilDue != 1 ? 's' : ''}',
            actionLabel: 'View Schedule',
            actionRoute: AppRoutes.health,
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          )),

      // Expired medicines (live)
      ...medNotifier.expiredItems.map((m) => _AlertData(
            icon: '🚫',
            type: AlertType.error,
            title: 'Medicine Expired',
            subtitle: '${m.name} — expired. Remove from use immediately.',
            actionLabel: 'View Stock',
            actionRoute: AppRoutes.health,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          )),

      // Expiring medicines (live)
      ...medNotifier.expiringItems.map((m) {
        final days = m.expiryDate!.difference(DateTime.now()).inDays;
        return _AlertData(
          icon: '⏰',
          type: AlertType.warning,
          title: 'Medicine Expiring Soon',
          subtitle: '${m.name} — expires in $days day${days != 1 ? 's' : ''}',
          actionLabel: 'View Stock',
          actionRoute: AppRoutes.health,
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        );
      }),

      // Low medicine stock (live)
      ...medNotifier.lowStockItems
          .where((m) => !m.isExpired && !m.isExpiringSoon)
          .map((m) => _AlertData(
                icon: '💊',
                type: AlertType.warning,
                title: 'Low Medicine Stock',
                subtitle:
                    '${m.name}: ${m.currentQty.toStringAsFixed(0)} ${m.unit ?? 'units'} remaining',
                actionLabel: 'Restock',
                actionRoute: AppRoutes.health,
                timestamp: DateTime.now().subtract(const Duration(hours: 4)),
              )),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.alerts),
        actions: [
          if (alerts.isNotEmpty)
            TextButton(
              onPressed: () {},
              child: const Text('Clear All',
                  style: TextStyle(color: AppColors.textSecondaryDark)),
            ),
        ],
      ),
      body: alerts.isEmpty
          ? _NoAlerts()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Text('🔔',
                          style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Text(
                        '${alerts.length} alert${alerts.length > 1 ? 's' : ''} require your attention',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Alert tiles
                ...alerts.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AlertTile(alert: a),
                    )),
              ],
            ),
    );
  }
}

enum AlertType { warning, info, error, success }

class _AlertData {
  final String icon;
  final AlertType type;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final String? actionRoute;
  final DateTime timestamp;

  const _AlertData({
    required this.icon,
    required this.type,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.actionRoute,
    required this.timestamp,
  });

  Color get color {
    switch (type) {
      case AlertType.warning: return AppColors.warning;
      case AlertType.info: return AppColors.info;
      case AlertType.error: return AppColors.error;
      case AlertType.success: return AppColors.success;
    }
  }
}

class _AlertTile extends StatelessWidget {
  final _AlertData alert;
  const _AlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: alert.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: alert.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(alert.icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alert.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: alert.color,
                            fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(alert.subtitle,
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondaryDark)),
                  ],
                ),
              ),
              Text(
                _timeAgo(alert.timestamp),
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textHintDark),
              ),
            ],
          ),
          if (alert.actionLabel != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (alert.actionRoute != null) {
                    context.push(alert.actionRoute!);
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: alert.color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  backgroundColor: alert.color.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(alert.actionLabel!,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, size: 10),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _NoAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('✅', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          Text('All Clear!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark)),
          SizedBox(height: 8),
          Text('No alerts at this time.\nYour farm is running smoothly.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }
}
