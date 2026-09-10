import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:kukula_app/core/providers/farm_providers.dart';
import 'package:kukula_app/core/providers/egg_providers.dart';
import 'package:kukula_app/core/providers/feed_providers.dart';
import 'package:kukula_app/core/providers/health_providers.dart';
import 'package:kukula_app/core/providers/finance_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/core/enums/farm_type.dart';
import 'package:kukula_app/features/flocks/flock_model.dart';
import 'package:kukula_app/features/health/health_model.dart';
import 'package:kukula_app/features/finance/finance_model.dart';
import 'pdf_generator_service.dart';
import 'report_filters_widget.dart';

// ── Report Type Enum ───────────────────────────────────────────────────────
enum _ReportType {
  eggProduction,
  feeding,
  health,
  finance;

  String get label {
    switch (this) {
      case eggProduction: return 'Egg Production';
      case feeding: return 'Feeding & Cost';
      case health: return 'Health & Vaccines';
      case finance: return 'Finance P&L';
    }
  }

  String get emoji {
    switch (this) {
      case eggProduction: return '🥚';
      case feeding: return '🌾';
      case health: return '💊';
      case finance: return '💰';
    }
  }

  String get description {
    switch (this) {
      case eggProduction:
        return 'Collection logs, grading, tray counts, break rate';
      case feeding:
        return 'Feed consumption by type, daily logs, cost summary';
      case health:
        return 'Health events, vaccination schedule, treatment log';
      case finance:
        return 'Income vs expenses, P&L, category breakdown';
    }
  }

  Color get color {
    switch (this) {
      case eggProduction: return AppColors.eggAccent;
      case feeding: return AppColors.primary;
      case health: return AppColors.info;
      case finance: return AppColors.success;
    }
  }
}

// ── Reports Hub Screen ─────────────────────────────────────────────────────
class ReportsHubScreen extends ConsumerStatefulWidget {
  const ReportsHubScreen({super.key});

  @override
  ConsumerState<ReportsHubScreen> createState() => _ReportsHubScreenState();
}

class _ReportsHubScreenState extends ConsumerState<ReportsHubScreen>
    with SingleTickerProviderStateMixin {
  _ReportType? _selectedType;
  bool _isGenerating = false;
  late ReportFilter _filter;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _filter = ReportFilter(
      startDate: DateTime(now.year, now.month, 1),
      endDate: now,
    );
  }

  List<_ReportType> _availableReports(FarmType farmType) {
    return [
      if (farmType.hasEggs) _ReportType.eggProduction,
      _ReportType.feeding,
      _ReportType.health,
      _ReportType.finance,
    ];
  }

  // ── Build Egg Report Data ────────────────────────────────────────────────
  EggReportData _buildEggData(WidgetRef ref, String farmName) {
    final collections = ref.read(eggRecordListProvider);
    final filtered = collections.where((c) =>
        !c.date.isBefore(_filter.startDate) &&
        !c.date.isAfter(_filter.endDate)).toList();
    final flocks = ref.read(flockListProvider);

    int totalEggs = 0, brokenEggs = 0, goodEggs = 0;
    for (final c in filtered) {
      totalEggs += c.totalEggs;
      brokenEggs += c.brokenEggs;
      goodEggs += c.goodEggs;
    }

    return EggReportData(
      farmName: farmName,
      filter: _filter,
      totalEggs: totalEggs,
      brokenEggs: brokenEggs,
      goodEggs: goodEggs,
      totalTrays: goodEggs / 30,
      collectionCount: filtered.length,
      collections: filtered.map((c) {
        final flockName = c.flockId != null
            ? flocks.firstWhere((f) => f.id == c.flockId,
                    orElse: () => flocks.first)
                .name
            : null;
        return {
          'date': _fmtDate(c.date),
          'flock': flockName,
          'eggs': c.totalEggs,
          'broken': c.brokenEggs,
        };
      }).toList(),
    );
  }

  // ── Build Feed Report Data ───────────────────────────────────────────────
  FeedReportData _buildFeedData(WidgetRef ref, String farmName) {
    final logs = ref.read(feedLogListProvider);
    final filtered = logs.where((l) =>
        !l.date.isBefore(_filter.startDate) &&
        !l.date.isAfter(_filter.endDate)).toList();

    double totalKg = 0, totalCost = 0;
    final byType = <String, Map<String, double>>{};

    for (final l in filtered) {
      totalKg += l.quantityKg;
      final cost = l.costLKR ?? 0.0;
      totalCost += cost;
      final feedName = l.feedTypeName;
      byType.putIfAbsent(feedName, () => {'kg': 0.0, 'cost': 0.0});
      byType[feedName]!['kg'] = byType[feedName]!['kg']! + l.quantityKg;
      byType[feedName]!['cost'] = byType[feedName]!['cost']! + cost;
    }

    return FeedReportData(
      farmName: farmName,
      filter: _filter,
      totalKgConsumed: totalKg,
      totalCost: totalCost,
      byFeedType: byType.entries
          .map((e) => {'name': e.key, 'kg': e.value['kg']!, 'cost': e.value['cost']!})
          .toList(),
      logs: filtered.map((l) => {
          'date': _fmtDate(l.date),
          'flock': l.flockName ?? l.flockId,
          'feed': l.feedTypeName,
          'kg': l.quantityKg,
          'cost': l.costLKR ?? 0.0,
        }).toList(),
    );
  }

  // ── Build Health Report Data ─────────────────────────────────────────────
  HealthReportData _buildHealthData(WidgetRef ref, String farmName) {
    final records = ref.read(healthRecordListProvider);
    final schedule = ref.read(vaccinationScheduleProvider);
    final filtered = records.where((r) =>
        !r.date.isBefore(_filter.startDate) &&
        !r.date.isAfter(_filter.endDate)).toList();

    int vax = 0, med = 0, obs = 0;
    for (final r in filtered) {
      switch (r.type) {
        case HealthRecordType.vaccination: vax++; break;
        case HealthRecordType.medication: med++; break;
        case HealthRecordType.observation: obs++; break;
        case HealthRecordType.treatment: med++; break;
      }
    }

    return HealthReportData(
      farmName: farmName,
      filter: _filter,
      totalRecords: filtered.length,
      vaccinationCount: vax,
      medicationCount: med,
      observationCount: obs,
      records: filtered.map((r) => <String, dynamic>{
        'date': _fmtDate(r.date),
        'flock': r.flockName,
        'type': r.type.label,
        'name': r.productName,
        'dosage': r.dosage,
        'notes': r.notes,
      }).toList(),
      schedule: schedule.map((s) => <String, dynamic>{
        'vaccine': s.vaccineName,
        'flock': s.flockName,
        'dueDate': _fmtDate(s.dueDate),
        'status': s.isCompleted
            ? 'Completed'
            : s.isOverdue
                ? 'OVERDUE'
                : 'Pending',
      }).toList(),
    );
  }

  // ── Build Finance Report Data ────────────────────────────────────────────
  FinanceReportData _buildFinanceData(WidgetRef ref, String farmName) {
    final transactions = ref.read(financeProvider);
    final filtered = transactions.where((t) =>
        !t.date.isBefore(_filter.startDate) &&
        !t.date.isAfter(_filter.endDate)).toList();

    double income = 0, expense = 0;
    final incomeByCategory = <String, double>{};
    final expenseByCategory = <String, double>{};

    for (final t in filtered) {
      if (t.type == TransactionType.income) {
        income += t.amount;
        final cat = t.category.label;
        incomeByCategory[cat] = (incomeByCategory[cat] ?? 0) + t.amount;
      } else {
        expense += t.amount;
        final cat = t.category.label;
        expenseByCategory[cat] = (expenseByCategory[cat] ?? 0) + t.amount;
      }
    }

    return FinanceReportData(
      farmName: farmName,
      filter: _filter,
      totalIncome: income,
      totalExpense: expense,
      netProfit: income - expense,
      transactions: filtered.map((t) => <String, dynamic>{
        'date': _fmtDate(t.date),
        'type': t.type == TransactionType.income ? 'Income' : 'Expense',
        'category': t.category.label,
        'desc': t.description,
        'amount': t.amount,
      }).toList(),
      incomeByCategory: incomeByCategory.entries
          .map((e) => {'category': e.key, 'amount': e.value})
          .toList()
          ..sort((a, b) =>
              (b['amount'] as double).compareTo(a['amount'] as double)),
      expenseByCategory: expenseByCategory.entries
          .map((e) => {'category': e.key, 'amount': e.value})
          .toList()
          ..sort((a, b) =>
              (b['amount'] as double).compareTo(a['amount'] as double)),
    );
  }

  // ── Generate & Preview PDF ───────────────────────────────────────────────
  Future<void> _generateAndPreview() async {
    if (_selectedType == null) return;
    setState(() => _isGenerating = true);

    try {
      final farmName = ref.read(farmNameProvider);

      final pdfDoc = switch (_selectedType!) {
        _ReportType.eggProduction =>
          await PdfGeneratorService.generateEggReport(
              _buildEggData(ref, farmName)),
        _ReportType.feeding =>
          await PdfGeneratorService.generateFeedReport(
              _buildFeedData(ref, farmName)),
        _ReportType.health =>
          await PdfGeneratorService.generateHealthReport(
              _buildHealthData(ref, farmName)),
        _ReportType.finance =>
          await PdfGeneratorService.generateFinanceReport(
              _buildFinanceData(ref, farmName)),
      };

      if (!mounted) return;
      await Printing.layoutPdf(
        onLayout: (format) async => pdfDoc.save(),
        name:
            '${farmName}_${_selectedType!.label.replaceAll(' ', '_')}_${_filter.startDate.year}-${_filter.startDate.month.toString().padLeft(2, '0')}.pdf',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error generating report: $e'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ));
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final farmType = ref.watch(farmTypeProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final available = _availableReports(farmType);
    final flocks = ref.watch(flockListProvider)
        .where((f) => f.status == FlockStatus.active)
        .map((f) => f.name)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          if (!isPremium)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.premiumGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.premiumGold.withValues(alpha: 0.4)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('👑', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 4),
                  Text('Premium',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.premiumGold,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // ── Header Banner ────────────────────────────────────────────
          _HeaderBanner(isPremium: isPremium),
          const SizedBox(height: 20),

          // ── Report Type Selection ─────────────────────────────────────
          const Text(
            'SELECT REPORT TYPE',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondaryDark,
                letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          ...available.map((type) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ReportTypeCard(
                  type: type,
                  isSelected: _selectedType == type,
                  onTap: () => setState(
                      () => _selectedType = _selectedType == type ? null : type),
                ),
              )),

          const SizedBox(height: 20),

          // ── Filters ───────────────────────────────────────────────────
          if (_selectedType != null) ...[
            ReportFiltersWidget(
              initialFilter: _filter,
              flockOrBatchNames: flocks,
              onChanged: (f) => setState(() => _filter = f),
            ),
            const SizedBox(height: 20),

            // ── Preview Section ──────────────────────────────────────
            _ReportPreviewCard(
              type: _selectedType!,
              filter: _filter,
            ),
            const SizedBox(height: 20),

            // ── Generate / Export Button ─────────────────────────────
            if (isPremium)
              _GenerateButton(
                isGenerating: _isGenerating,
                reportName: _selectedType!.label,
                onGenerate: _generateAndPreview,
              )
            else
              _PremiumUpgradePrompt(reportName: _selectedType!.label),
          ],
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_month(d.month)} ${d.year}';
  static String _month(int m) => [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
}

// ── Header Banner ──────────────────────────────────────────────────────────
class _HeaderBanner extends StatelessWidget {
  final bool isPremium;
  const _HeaderBanner({required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPremium
              ? [
                  AppColors.premiumGold.withValues(alpha: 0.25),
                  AppColors.premiumGold.withValues(alpha: 0.08),
                ]
              : [
                  AppColors.primary.withValues(alpha: 0.18),
                  AppColors.primary.withValues(alpha: 0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPremium
              ? AppColors.premiumGold.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: (isPremium ? AppColors.premiumGold : AppColors.primary)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(isPremium ? '📊' : '📄',
                  style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPremium
                      ? 'Farm Reports & PDF Export'
                      : 'Farm Reports',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark),
                ),
                const SizedBox(height: 4),
                Text(
                  isPremium
                      ? 'Generate and export professional PDF reports for any date range.'
                      : 'View on-screen summaries. Upgrade to Premium to export PDFs.',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondaryDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Report Type Card ───────────────────────────────────────────────────────
class _ReportTypeCard extends StatelessWidget {
  final _ReportType type;
  final bool isSelected;
  final VoidCallback onTap;
  const _ReportTypeCard(
      {required this.type, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? type.color.withValues(alpha: 0.12)
              : AppColors.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? type.color.withValues(alpha: 0.6)
                : AppColors.borderDark,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: type.color.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: type.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child: Text(type.emoji,
                      style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type.label,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? type.color
                              : AppColors.textPrimaryDark)),
                  const SizedBox(height: 3),
                  Text(type.description,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryDark)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              color: isSelected ? type.color : AppColors.textHintDark,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Report Preview Card ────────────────────────────────────────────────────
class _ReportPreviewCard extends ConsumerWidget {
  final _ReportType type;
  final ReportFilter filter;
  const _ReportPreviewCard({required this.type, required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(type.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              '${type.label} Preview',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark),
            ),
          ]),
          const SizedBox(height: 4),
          Text(
            'Period: ${filter.dateRangeLabel}',
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 14),
          _buildPreviewContent(context, ref),
        ],
      ),
    );
  }

  Widget _buildPreviewContent(BuildContext context, WidgetRef ref) {
    switch (type) {
      case _ReportType.eggProduction:
        return _EggPreview(filter: filter);
      case _ReportType.feeding:
        return _FeedPreview(filter: filter);
      case _ReportType.health:
        return _HealthPreview(filter: filter);
      case _ReportType.finance:
        return _FinancePreview(filter: filter);
    }
  }
}

// ── Egg Production Preview ─────────────────────────────────────────────────
class _EggPreview extends ConsumerWidget {
  final ReportFilter filter;
  const _EggPreview({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(eggRecordListProvider);
    final filtered = collections.where((c) =>
        !c.date.isBefore(filter.startDate) &&
        !c.date.isAfter(filter.endDate)).toList();

    int total = 0, broken = 0, good = 0;
    for (final c in filtered) {
      total += c.totalEggs;
      broken += c.brokenEggs;
      good += c.goodEggs;
    }

    return _PreviewGrid(items: [
      _PreviewStat('Collections', '${filtered.length}', AppColors.primary),
      _PreviewStat('Total Eggs', '$total', AppColors.eggAccent),
      _PreviewStat('Good Eggs', '$good', AppColors.success),
      _PreviewStat('Trays', '${(good / 30).toStringAsFixed(1)}', AppColors.info),
      _PreviewStat('Broken', '$broken', AppColors.error),
      _PreviewStat(
          'Break Rate',
          total > 0 ? '${(broken / total * 100).toStringAsFixed(1)}%' : '0%',
          broken > 0 ? AppColors.warning : AppColors.success),
    ]);
  }
}

// ── Feeding Preview ────────────────────────────────────────────────────────
class _FeedPreview extends ConsumerWidget {
  final ReportFilter filter;
  const _FeedPreview({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(feedLogListProvider);
    final filtered = logs.where((l) =>
        !l.date.isBefore(filter.startDate) &&
        !l.date.isAfter(filter.endDate)).toList();

    double kg = 0, cost = 0;
    for (final l in filtered) {
      kg += l.quantityKg;
      cost += l.costLKR ?? 0.0;
    }

    return _PreviewGrid(items: [
      _PreviewStat('Log Entries', '${filtered.length}', AppColors.primary),
      _PreviewStat('Total Consumed', '${kg.toStringAsFixed(1)} kg', AppColors.primary),
      _PreviewStat('Total Cost', 'LKR ${cost.toStringAsFixed(0)}', AppColors.error),
      _PreviewStat(
          'Avg Cost/kg',
          kg > 0 ? 'LKR ${(cost / kg).toStringAsFixed(0)}' : '—',
          AppColors.info),
    ]);
  }
}

// ── Health Preview ─────────────────────────────────────────────────────────
class _HealthPreview extends ConsumerWidget {
  final ReportFilter filter;
  const _HealthPreview({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(healthRecordListProvider);
    final schedule = ref.watch(vaccinationScheduleProvider);
    final filtered = records.where((r) =>
        !r.date.isBefore(filter.startDate) &&
        !r.date.isAfter(filter.endDate)).toList();

    final vax = filtered.where((r) => r.type == HealthRecordType.vaccination).length;
    final med = filtered.where((r) => r.type == HealthRecordType.medication || r.type == HealthRecordType.treatment).length;
    final obs = filtered.where((r) => r.type == HealthRecordType.observation).length;
    final overdue = schedule.where((s) => s.isOverdue).length;

    return _PreviewGrid(items: [
      _PreviewStat('Total Records', '${filtered.length}', AppColors.primary),
      _PreviewStat('Vaccinations', '$vax', AppColors.info),
      _PreviewStat('Medications', '$med', AppColors.warning),
      _PreviewStat('Observations', '$obs', AppColors.textSecondaryDark),
      _PreviewStat('Scheduled', '${schedule.length}', AppColors.info),
      _PreviewStat(
          'Overdue',
          '$overdue',
          overdue > 0 ? AppColors.error : AppColors.success),
    ]);
  }
}

// ── Finance Preview ────────────────────────────────────────────────────────
class _FinancePreview extends ConsumerWidget {
  final ReportFilter filter;
  const _FinancePreview({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(financeProvider);
    final filtered = transactions.where((t) =>
        !t.date.isBefore(filter.startDate) &&
        !t.date.isAfter(filter.endDate)).toList();

    double income = 0, expense = 0;
    for (final t in filtered) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    final net = income - expense;
    final isProfit = net >= 0;

    return _PreviewGrid(items: [
      _PreviewStat('Transactions', '${filtered.length}', AppColors.primary),
      _PreviewStat('Total Income', 'LKR ${income.toStringAsFixed(0)}', AppColors.success),
      _PreviewStat('Total Expense', 'LKR ${expense.toStringAsFixed(0)}', AppColors.error),
      _PreviewStat(
          isProfit ? 'Net Profit' : 'Net Loss',
          'LKR ${net.abs().toStringAsFixed(0)}',
          isProfit ? AppColors.success : AppColors.error),
      _PreviewStat(
          'Margin',
          income > 0
              ? '${(net / income * 100).toStringAsFixed(1)}%'
              : '—',
          isProfit ? AppColors.success : AppColors.error),
    ]);
  }
}

// ── Preview Grid ───────────────────────────────────────────────────────────
class _PreviewGrid extends StatelessWidget {
  final List<_PreviewStat> items;
  const _PreviewGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((stat) => _PreviewStatTile(stat: stat)).toList(),
    );
  }
}

class _PreviewStat {
  final String label;
  final String value;
  final Color color;
  const _PreviewStat(this.label, this.value, this.color);
}

class _PreviewStatTile extends StatelessWidget {
  final _PreviewStat stat;
  const _PreviewStatTile({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 32 - 16 * 2 - 8) / 3,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: stat.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: stat.color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stat.label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondaryDark),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(stat.value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: stat.color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ── Generate Button ────────────────────────────────────────────────────────
class _GenerateButton extends StatelessWidget {
  final bool isGenerating;
  final String reportName;
  final VoidCallback onGenerate;
  const _GenerateButton({
    required this.isGenerating,
    required this.reportName,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isGenerating ? null : onGenerate,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: isGenerating
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white)),
                  SizedBox(width: 12),
                  Text('Generating PDF…',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📄', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Text(
                    'Preview & Export $reportName PDF',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Premium Upgrade Prompt ─────────────────────────────────────────────────
class _PremiumUpgradePrompt extends StatelessWidget {
  final String reportName;
  const _PremiumUpgradePrompt({required this.reportName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.premiumGold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.premiumGold.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          const Text('👑', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          const Text(
            'PDF Export is a Premium Feature',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.premiumGold),
          ),
          const SizedBox(height: 8),
          Text(
            'Upgrade to Premium to export your $reportName as a professional PDF — shareable via email, WhatsApp, or saved to device.',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.premiumGold),
                    foregroundColor: AppColors.premiumGold,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Learn More'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.premiumGold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Upgrade Now',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Included features list
          ...const [
            '✅ All report types (Egg, Feed, Health, Finance)',
            '✅ Any date range — this week to all-time',
            '✅ Share via email, WhatsApp, or save to device',
            '✅ Multi-language PDF (English & Sinhala)',
          ].map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      f,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryDark),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
