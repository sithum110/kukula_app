import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/providers/health_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/health/health_model.dart';

class HealthLogScreen extends ConsumerStatefulWidget {
  const HealthLogScreen({super.key});

  @override
  ConsumerState<HealthLogScreen> createState() => _HealthLogScreenState();
}

class _HealthLogScreenState extends ConsumerState<HealthLogScreen>
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
    final scheduleNotifier = ref.watch(vaccinationScheduleProvider.notifier);
    final medNotifier = ref.watch(medicineStockProvider.notifier);
    final scheduleAlerts = scheduleNotifier.alertCount;
    final medAlerts = medNotifier.alertCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health & Medicine'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppColors.info,
          labelColor: AppColors.info,
          unselectedLabelColor: AppColors.textSecondaryDark,
          tabs: [
            const Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('💉', style: TextStyle(fontSize: 14)),
                SizedBox(width: 4),
                Text('Records'),
              ]),
            ),
            Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('📅', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                const Text('Schedule'),
                if (scheduleAlerts > 0) ...[
                  const SizedBox(width: 4),
                  _AlertBadge(count: scheduleAlerts),
                ],
              ]),
            ),
            Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('💊', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                const Text('Stock'),
                if (medAlerts > 0) ...[
                  const SizedBox(width: 4),
                  _AlertBadge(count: medAlerts),
                ],
              ]),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _RecordsTab(),
          _ScheduleTab(),
          _MedicineStockTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRecordSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showAddRecordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddHealthRecordSheet(),
    );
  }
}

// ── Records Tab ────────────────────────────────────────────────────────────
class _RecordsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(healthRecordListProvider.notifier);
    final records = ref.watch(healthRecordListProvider);
    final grouped = notifier.groupedByDate;

    if (records.isEmpty) {
      return const _EmptyState(
        emoji: '🩺',
        title: 'No Health Records',
        subtitle: 'Tap + to log a vaccination, medication,\ntreatment or observation.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: grouped.length,
      itemBuilder: (_, i) {
        final dateKey = grouped.keys.toList()[i];
        final dayRecords = grouped[dateKey]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateChip(label: dateKey),
            const SizedBox(height: 8),
            ...dayRecords.map((r) => _HealthRecordTile(record: r)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

class _HealthRecordTile extends ConsumerWidget {
  final HealthRecordModel record;
  const _HealthRecordTile({required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(record.id),
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
        ref.read(healthRecordListProvider.notifier).deleteRecord(record.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health record deleted'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _typeColor(record.type).withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _typeColor(record.type).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(record.type.emoji,
                        style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(record.productName,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryDark)),
                      Row(
                        children: [
                          _TypeBadge(type: record.type),
                          if (record.flockName != null) ...[
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '· ${record.flockName}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondaryDark),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (record.dosage != null)
                      Text(record.dosage!,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondaryDark)),
                    if (record.administeredBy != null)
                      Text('by ${record.administeredBy}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textHintDark)),
                  ],
                ),
              ],
            ),
            if (record.notes != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cardDark2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(record.notes!,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryDark,
                        fontStyle: FontStyle.italic)),
              ),
            ],
            if (record.nextDueDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded,
                      size: 13, color: AppColors.info),
                  const SizedBox(width: 4),
                  Text(
                    'Next due: ${_fmt(record.nextDueDate!)}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.info),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _typeColor(HealthRecordType t) {
    switch (t) {
      case HealthRecordType.vaccination: return AppColors.info;
      case HealthRecordType.medication: return AppColors.warning;
      case HealthRecordType.treatment: return AppColors.success;
      case HealthRecordType.observation: return AppColors.textSecondaryDark;
    }
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

// ── Schedule Tab ───────────────────────────────────────────────────────────
class _ScheduleTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(vaccinationScheduleProvider.notifier);
    final all = ref.watch(vaccinationScheduleProvider);
    ref.watch(vaccinationScheduleProvider); // subscribe

    final overdue = notifier.overdue;
    final dueSoon = notifier.dueSoon;
    final upcoming = notifier.upcoming;
    final completed =
        all.where((s) => s.isCompleted).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        // Overdue
        if (overdue.isNotEmpty) ...[
          _SectionLabel('🚨 Overdue (${overdue.length})', AppColors.error),
          const SizedBox(height: 8),
          ...overdue.map((s) => _ScheduleTile(schedule: s)),
          const SizedBox(height: 16),
        ],

        // Due soon (≤7 days)
        if (dueSoon.isNotEmpty) ...[
          _SectionLabel('⚠️ Due Within 7 Days (${dueSoon.length})', AppColors.warning),
          const SizedBox(height: 8),
          ...dueSoon.map((s) => _ScheduleTile(schedule: s)),
          const SizedBox(height: 16),
        ],

        // Upcoming
        if (upcoming.isNotEmpty) ...[
          _SectionLabel('📅 Upcoming (${upcoming.length})', AppColors.info),
          const SizedBox(height: 8),
          ...upcoming.map((s) => _ScheduleTile(schedule: s)),
          const SizedBox(height: 16),
        ],

        // Completed
        if (completed.isNotEmpty) ...[
          _SectionLabel('✅ Completed (${completed.length})', AppColors.success),
          const SizedBox(height: 8),
          ...completed.map((s) => _ScheduleTile(schedule: s)),
          const SizedBox(height: 16),
        ],

        // Add schedule
        OutlinedButton.icon(
          onPressed: () => _showAddScheduleSheet(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Vaccination Schedule'),
        ),
      ],
    );
  }

  void _showAddScheduleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddScheduleSheet(),
    );
  }
}

class _ScheduleTile extends ConsumerWidget {
  final VaccinationScheduleModel schedule;
  const _ScheduleTile({required this.schedule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverdue = schedule.isOverdue;
    final dueSoon =
        !schedule.isCompleted && schedule.daysUntilDue <= 7 && schedule.daysUntilDue >= 0;

    Color cardColor;
    Color borderColor;
    if (schedule.isCompleted) {
      cardColor = AppColors.success.withValues(alpha: 0.06);
      borderColor = AppColors.success.withValues(alpha: 0.2);
    } else if (isOverdue) {
      cardColor = AppColors.error.withValues(alpha: 0.08);
      borderColor = AppColors.error.withValues(alpha: 0.4);
    } else if (dueSoon) {
      cardColor = AppColors.warning.withValues(alpha: 0.08);
      borderColor = AppColors.warning.withValues(alpha: 0.4);
    } else {
      cardColor = AppColors.cardDark;
      borderColor = AppColors.borderDark;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: (schedule.isCompleted
                      ? AppColors.success
                      : isOverdue
                          ? AppColors.error
                          : AppColors.info)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                schedule.isCompleted ? '✅' : isOverdue ? '🚨' : '💉',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(schedule.vaccineName,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryDark)),
                if (schedule.flockName != null)
                  Text(schedule.flockName!,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryDark)),
                const SizedBox(height: 4),
                Text(
                  _dueLabel(schedule),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: schedule.isCompleted
                        ? AppColors.success
                        : isOverdue
                            ? AppColors.error
                            : dueSoon
                                ? AppColors.warning
                                : AppColors.info,
                  ),
                ),
              ],
            ),
          ),
          if (!schedule.isCompleted)
            TextButton(
              onPressed: () {
                ref
                    .read(vaccinationScheduleProvider.notifier)
                    .markComplete(schedule.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ ${schedule.vaccineName} marked complete'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                backgroundColor: AppColors.success.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Done', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }

  String _dueLabel(VaccinationScheduleModel s) {
    if (s.isCompleted) return 'Completed';
    if (s.isOverdue) {
      return '${s.daysUntilDue.abs()} day${s.daysUntilDue.abs() != 1 ? 's' : ''} overdue!';
    }
    if (s.daysUntilDue == 0) return 'Due today!';
    return 'Due in ${s.daysUntilDue} day${s.daysUntilDue != 1 ? 's' : ''}';
  }
}

// ── Medicine Stock Tab ─────────────────────────────────────────────────────
class _MedicineStockTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockItems = ref.watch(medicineStockProvider);
    final notifier = ref.watch(medicineStockProvider.notifier);

    final expired = notifier.expiredItems;
    final expiring = notifier.expiringItems;
    final low = notifier.lowStockItems;
    final ok = stockItems
        .where((m) => !m.isLowStock && !m.isExpired && !m.isExpiringSoon)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        // Alert banner
        if (expired.isNotEmpty || expiring.isNotEmpty || low.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Text('⚠️', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Text('Medicine Alerts',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error)),
                ]),
                const SizedBox(height: 6),
                if (expired.isNotEmpty)
                  Text('• ${expired.length} expired item${expired.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.error)),
                if (expiring.isNotEmpty)
                  Text('• ${expiring.length} expiring within 30 days',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.warning)),
                if (low.isNotEmpty)
                  Text('• ${low.length} low stock item${low.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.warning)),
              ],
            ),
          ),

        if (expired.isNotEmpty) ...[
          _SectionLabel('🚫 Expired', AppColors.error),
          const SizedBox(height: 8),
          ...expired.map((m) => _MedicineTile(item: m)),
          const SizedBox(height: 12),
        ],
        if (expiring.isNotEmpty) ...[
          _SectionLabel('⏰ Expiring Soon', AppColors.warning),
          const SizedBox(height: 8),
          ...expiring.map((m) => _MedicineTile(item: m)),
          const SizedBox(height: 12),
        ],
        if (low.isNotEmpty) ...[
          _SectionLabel('📉 Low Stock', AppColors.warning),
          const SizedBox(height: 8),
          ...low.map((m) => _MedicineTile(item: m)),
          const SizedBox(height: 12),
        ],
        if (ok.isNotEmpty) ...[
          _SectionLabel('✅ In Stock', AppColors.success),
          const SizedBox(height: 8),
          ...ok.map((m) => _MedicineTile(item: m)),
          const SizedBox(height: 12),
        ],

        OutlinedButton.icon(
          onPressed: () => _showAddMedicineSheet(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Medicine / Vaccine'),
        ),
      ],
    );
  }

  void _showAddMedicineSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddMedicineSheet(),
    );
  }
}

class _MedicineTile extends ConsumerWidget {
  final MedicineStockModel item;
  const _MedicineTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysToExpiry = item.expiryDate != null
        ? item.expiryDate!.difference(DateTime.now()).inDays
        : null;
    final stockPct = item.lowStockThreshold > 0
        ? (item.currentQty / (item.lowStockThreshold * 3)).clamp(0.0, 1.0)
        : 1.0;

    Color accentColor;
    if (item.isExpired) {
      accentColor = AppColors.error;
    } else if (item.isExpiringSoon || item.isLowStock) {
      accentColor = AppColors.warning;
    } else {
      accentColor = AppColors.success;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    item.stockType == MedicineStockType.vaccine ? '💉' : '💊',
                    style: const TextStyle(fontSize: 20),
                  ),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.isExpired
                        ? 'EXPIRED'
                        : 'Exp: ${_fmtDate(item.expiryDate!)}',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: accentColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${item.currentQty.toStringAsFixed(0)} ${item.unit ?? 'units'} on hand',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: item.isLowStock
                        ? AppColors.warning
                        : AppColors.textPrimaryDark),
              ),
              Text('Min: ${item.lowStockThreshold.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textHintDark)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stockPct,
              backgroundColor: AppColors.borderDark,
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showRestockSheet(context, ref, item),
                  icon: const Icon(Icons.add_circle_outline, size: 14),
                  label: const Text('Restock', style: TextStyle(fontSize: 12)),
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
                  onPressed: () {
                    ref
                        .read(medicineStockProvider.notifier)
                        .deleteItem(item.id);
                  },
                  icon: const Icon(Icons.delete_outline, size: 14),
                  label: const Text('Remove', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(
                        color: AppColors.error.withValues(alpha: 0.3)),
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
              style: const TextStyle(color: AppColors.textSecondaryDark),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Add quantity',
                suffixText: item.unit ?? 'units',
                prefixIcon: const Icon(Icons.add),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final qty = double.tryParse(ctrl.text) ?? 0;
                if (qty > 0) {
                  ref.read(medicineStockProvider.notifier).addStock(item.id, qty);
                }
                Navigator.pop(context);
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              child: const Text('Add to Stock'),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

// ── Add Health Record Sheet ────────────────────────────────────────────────
class _AddHealthRecordSheet extends ConsumerStatefulWidget {
  const _AddHealthRecordSheet();

  @override
  ConsumerState<_AddHealthRecordSheet> createState() =>
      _AddHealthRecordSheetState();
}

class _AddHealthRecordSheetState
    extends ConsumerState<_AddHealthRecordSheet> {
  final _formKey = GlobalKey<FormState>();
  HealthRecordType _type = HealthRecordType.vaccination;
  final _productCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _adminCtrl = TextEditingController();
  final _flockCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  DateTime? _nextDue;
  bool _isLoading = false;

  @override
  void dispose() {
    _productCtrl.dispose();
    _dosageCtrl.dispose();
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    _adminCtrl.dispose();
    _flockCtrl.dispose();
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
              const SizedBox(height: 16),
              const Text('Add Health Record',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark)),
              const SizedBox(height: 16),

              // Record type chips
              Wrap(
                spacing: 8,
                children: HealthRecordType.values.map((t) {
                  final selected = _type == t;
                  return FilterChip(
                    label: Text('${t.emoji} ${t.label}'),
                    selected: selected,
                    onSelected: (_) => setState(() => _type = t),
                    selectedColor: _typeColor(t).withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: selected ? _typeColor(t) : AppColors.textSecondaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    checkmarkColor: _typeColor(t),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              _Label(_type == HealthRecordType.vaccination
                  ? 'Vaccine Name'
                  : _type == HealthRecordType.medication
                      ? 'Medicine Name'
                      : 'Treatment / Description'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _productCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: _type == HealthRecordType.vaccination
                      ? 'e.g. Newcastle Disease Vaccine'
                      : _type == HealthRecordType.medication
                          ? 'e.g. Amoxicillin 500mg'
                          : 'e.g. Vitamin supplement',
                  prefixIcon: const Icon(Icons.medication_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Dosage (optional)'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _dosageCtrl,
                          decoration: const InputDecoration(
                            hintText: '0.5ml/bird',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Qty Used (optional)'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _qtyCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(hintText: '250'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const _Label('Flock / Batch (optional)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _flockCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Flock A, Batch Jan 2026, All Flocks',
                  prefixIcon: Icon(Icons.group_work_outlined),
                ),
              ),
              const SizedBox(height: 10),

              const _Label('Administered By (optional)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _adminCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Dr. Perera, Nimal',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 10),

              const _Label('Notes (optional)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                    hintText: 'Observations, side effects, batch info...'),
              ),
              const SizedBox(height: 10),

              // Next due date
              if (_type == HealthRecordType.vaccination ||
                  _type == HealthRecordType.medication) ...[
                _Label('Next Due Date (optional)'),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickNextDue,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark2,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event_outlined,
                            color: AppColors.textSecondaryDark, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          _nextDue == null
                              ? 'Set next due date'
                              : _fmtDate(_nextDue!),
                          style: TextStyle(
                            fontSize: 14,
                            color: _nextDue == null
                                ? AppColors.textHintDark
                                : AppColors.info,
                          ),
                        ),
                        const Spacer(),
                        if (_nextDue != null)
                          GestureDetector(
                            onTap: () => setState(() => _nextDue = null),
                            child: const Icon(Icons.close,
                                size: 16, color: AppColors.textHintDark),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.info),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Save Health Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickNextDue() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(data: AppTheme.darkTheme, child: child!),
    );
    if (picked != null) setState(() => _nextDue = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final record = HealthRecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      farmId: 'farm1',
      type: _type,
      flockName: _flockCtrl.text.trim().isEmpty
          ? null
          : _flockCtrl.text.trim(),
      productName: _productCtrl.text.trim(),
      dosage: _dosageCtrl.text.trim().isEmpty ? null : _dosageCtrl.text.trim(),
      quantityUsed: double.tryParse(_qtyCtrl.text),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      administeredBy: _adminCtrl.text.trim().isEmpty
          ? null
          : _adminCtrl.text.trim(),
      date: _date,
      nextDueDate: _nextDue,
      createdAt: DateTime.now(),
    );

    ref.read(healthRecordListProvider.notifier).addRecord(record);

    // If next due date set, add to vaccination schedule
    if (_nextDue != null &&
        (_type == HealthRecordType.vaccination ||
            _type == HealthRecordType.medication)) {
      final schedule = VaccinationScheduleModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        farmId: 'farm1',
        flockName: _flockCtrl.text.trim().isEmpty ? null : _flockCtrl.text.trim(),
        vaccineName: _productCtrl.text.trim(),
        dueDate: _nextDue!,
      );
      ref.read(vaccinationScheduleProvider.notifier).addSchedule(schedule);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '✅ ${record.type.label} record saved — ${record.productName}'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Color _typeColor(HealthRecordType t) {
    switch (t) {
      case HealthRecordType.vaccination: return AppColors.info;
      case HealthRecordType.medication: return AppColors.warning;
      case HealthRecordType.treatment: return AppColors.success;
      case HealthRecordType.observation: return AppColors.textSecondaryDark;
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

// ── Add Schedule Sheet ─────────────────────────────────────────────────────
class _AddScheduleSheet extends ConsumerStatefulWidget {
  const _AddScheduleSheet();

  @override
  ConsumerState<_AddScheduleSheet> createState() => _AddScheduleSheetState();
}

class _AddScheduleSheetState extends ConsumerState<_AddScheduleSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _flockCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _nameCtrl.dispose();
    _flockCtrl.dispose();
    _notesCtrl.dispose();
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Add Vaccination Schedule',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  labelText: 'Vaccine Name',
                  prefixIcon: Icon(Icons.vaccines_outlined)),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _flockCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  labelText: 'Flock / Batch (optional)',
                  prefixIcon: Icon(Icons.group_work_outlined)),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate:
                      DateTime.now().add(const Duration(days: 365)),
                  builder: (ctx, child) =>
                      Theme(data: AppTheme.darkTheme, child: child!),
                );
                if (picked != null) setState(() => _dueDate = picked);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardDark2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 18,
                        color: AppColors.textSecondaryDark),
                    const SizedBox(width: 10),
                    Text(
                        '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                        style: const TextStyle(
                            color: AppColors.textPrimaryDark)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                  labelText: 'Notes (optional)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                final s = VaccinationScheduleModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  farmId: 'farm1',
                  flockName: _flockCtrl.text.trim().isEmpty
                      ? null
                      : _flockCtrl.text.trim(),
                  vaccineName: _nameCtrl.text.trim(),
                  dueDate: _dueDate,
                  notes: _notesCtrl.text.trim().isEmpty
                      ? null
                      : _notesCtrl.text.trim(),
                );
                ref.read(vaccinationScheduleProvider.notifier).addSchedule(s);
                Navigator.pop(context);
              },
              child: const Text('Add to Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Add Medicine Sheet ─────────────────────────────────────────────────────
class _AddMedicineSheet extends ConsumerStatefulWidget {
  const _AddMedicineSheet();

  @override
  ConsumerState<_AddMedicineSheet> createState() => _AddMedicineSheetState();
}

class _AddMedicineSheetState extends ConsumerState<_AddMedicineSheet> {
  final _formKey = GlobalKey<FormState>();
  MedicineStockType _stockType = MedicineStockType.medicine;
  final _nameCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _threshCtrl = TextEditingController(text: '10');
  final _priceCtrl = TextEditingController();
  final _mfgCtrl = TextEditingController();
  DateTime? _expiryDate;

  @override
  void dispose() {
    _nameCtrl.dispose(); _unitCtrl.dispose(); _qtyCtrl.dispose();
    _threshCtrl.dispose(); _priceCtrl.dispose(); _mfgCtrl.dispose();
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
              const Text('Add Medicine / Vaccine',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryDark)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TypeToggle(
                      label: '💊 Medicine',
                      selected: _stockType == MedicineStockType.medicine,
                      onTap: () => setState(
                          () => _stockType = MedicineStockType.medicine),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TypeToggle(
                      label: '💉 Vaccine',
                      selected: _stockType == MedicineStockType.vaccine,
                      onTap: () => setState(
                          () => _stockType = MedicineStockType.vaccine),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'e.g. Amoxicillin 500mg'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _unitCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Unit', hintText: 'tablets, ml, doses'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Opening Qty'),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (double.tryParse(v) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _threshCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Low Stock Alert'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                          labelText: 'Price/unit (LKR)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mfgCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Manufacturer (optional)'),
              ),
              const SizedBox(height: 10),
              // Expiry date
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 180)),
                    firstDate: DateTime.now(),
                    lastDate:
                        DateTime.now().add(const Duration(days: 365 * 5)),
                    builder: (ctx, child) =>
                        Theme(data: AppTheme.darkTheme, child: child!),
                  );
                  if (picked != null) setState(() => _expiryDate = picked);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark2,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_outlined,
                          size: 18,
                          color: AppColors.textSecondaryDark),
                      const SizedBox(width: 10),
                      Text(
                        _expiryDate == null
                            ? 'Set expiry date (optional)'
                            : 'Expires: ${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _expiryDate == null
                              ? AppColors.textHintDark
                              : AppColors.textPrimaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final m = MedicineStockModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    farmId: 'farm1',
                    name: _nameCtrl.text.trim(),
                    stockType: _stockType,
                    unit: _unitCtrl.text.trim().isEmpty
                        ? null
                        : _unitCtrl.text.trim(),
                    currentQty: double.parse(_qtyCtrl.text),
                    lowStockThreshold:
                        double.tryParse(_threshCtrl.text) ?? 10,
                    expiryDate: _expiryDate,
                    pricePerUnit: double.tryParse(_priceCtrl.text),
                    manufacturer: _mfgCtrl.text.trim().isEmpty
                        ? null
                        : _mfgCtrl.text.trim(),
                    createdAt: DateTime.now(),
                  );
                  ref.read(medicineStockProvider.notifier).addItem(m);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✅ ${m.name} added to stock'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Add to Stock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TypeToggle(
      {required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.info.withValues(alpha: 0.15)
                : AppColors.cardDark2,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: selected ? AppColors.info : AppColors.borderDark),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.info : AppColors.textSecondaryDark),
            ),
          ),
        ),
      );
}

// ── Shared Widgets ─────────────────────────────────────────────────────────
class _TypeBadge extends StatelessWidget {
  final HealthRecordType type;
  const _TypeBadge({required this.type});

  Color get _color {
    switch (type) {
      case HealthRecordType.vaccination: return AppColors.info;
      case HealthRecordType.medication: return AppColors.warning;
      case HealthRecordType.treatment: return AppColors.success;
      case HealthRecordType.observation: return AppColors.textSecondaryDark;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(type.label,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, color: _color)),
      );
}

class _DateChip extends StatelessWidget {
  final String label;
  const _DateChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.info.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.info)),
      );
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel(this.label, this.color);
  @override
  Widget build(BuildContext context) => Text(label,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3));
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
                  style:
                      const TextStyle(color: AppColors.textSecondaryDark)),
            ],
          ),
        ),
      );
}

