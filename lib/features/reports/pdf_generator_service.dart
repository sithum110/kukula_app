import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// ── PDF Color Palette ──────────────────────────────────────────────────────
class _PdfColors {
  static const primary = PdfColor.fromInt(0xFF00C853);
  static const dark = PdfColor.fromInt(0xFF1A1A2E);
  static const hint = PdfColor.fromInt(0xFF9E9E9E);
  static const income = PdfColor.fromInt(0xFF4CAF50);
  static const expense = PdfColor.fromInt(0xFFF44336);
  static const warning = PdfColor.fromInt(0xFFFF9800);
  static const white = PdfColors.white;
  static const grey200 = PdfColor.fromInt(0xFFEEEEEE);
  static const grey800 = PdfColor.fromInt(0xFF424242);
}

// ── Report Filter Model ────────────────────────────────────────────────────
class ReportFilter {
  final DateTime startDate;
  final DateTime endDate;
  final String? flockOrBatchId;
  final String? flockOrBatchName;

  const ReportFilter({
    required this.startDate,
    required this.endDate,
    this.flockOrBatchId,
    this.flockOrBatchName,
  });

  String get dateRangeLabel {
    final fmt = (DateTime d) =>
        '${d.day.toString().padLeft(2, '0')} ${_month(d.month)} ${d.year}';
    return '${fmt(startDate)} – ${fmt(endDate)}';
  }

  static String _month(int m) => [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
}

// ── Report Data Models ─────────────────────────────────────────────────────
class EggReportData {
  final String farmName;
  final ReportFilter filter;
  final int totalEggs;
  final int brokenEggs;
  final int goodEggs;
  final double totalTrays;
  final int collectionCount;
  final List<Map<String, dynamic>> collections;

  const EggReportData({
    required this.farmName,
    required this.filter,
    required this.totalEggs,
    required this.brokenEggs,
    required this.goodEggs,
    required this.totalTrays,
    required this.collectionCount,
    required this.collections,
  });
}

class FeedReportData {
  final String farmName;
  final ReportFilter filter;
  final double totalKgConsumed;
  final double totalCost;
  final List<Map<String, dynamic>> byFeedType;
  final List<Map<String, dynamic>> logs;

  const FeedReportData({
    required this.farmName,
    required this.filter,
    required this.totalKgConsumed,
    required this.totalCost,
    required this.byFeedType,
    required this.logs,
  });
}

class HealthReportData {
  final String farmName;
  final ReportFilter filter;
  final int totalRecords;
  final int vaccinationCount;
  final int medicationCount;
  final int observationCount;
  final List<Map<String, dynamic>> records;
  final List<Map<String, dynamic>> schedule;

  const HealthReportData({
    required this.farmName,
    required this.filter,
    required this.totalRecords,
    required this.vaccinationCount,
    required this.medicationCount,
    required this.observationCount,
    required this.records,
    required this.schedule,
  });
}

class FinanceReportData {
  final String farmName;
  final ReportFilter filter;
  final double totalIncome;
  final double totalExpense;
  final double netProfit;
  final List<Map<String, dynamic>> transactions;
  final List<Map<String, dynamic>> incomeByCategory;
  final List<Map<String, dynamic>> expenseByCategory;

  const FinanceReportData({
    required this.farmName,
    required this.filter,
    required this.totalIncome,
    required this.totalExpense,
    required this.netProfit,
    required this.transactions,
    required this.incomeByCategory,
    required this.expenseByCategory,
  });
}

// ── PDF Generator Service ──────────────────────────────────────────────────
class PdfGeneratorService {
  // ── Common Header ────────────────────────────────────────────────────────
  static pw.Widget _header(
      String title, String farmName, String dateRange) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: const pw.BoxDecoration(
        color: _PdfColors.dark,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                farmName,
                style: pw.TextStyle(
                    color: _PdfColors.hint,
                    fontSize: 10,
                    fontWeight: pw.FontWeight.normal),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                title,
                style: pw.TextStyle(
                    color: _PdfColors.white,
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('Report Period',
                  style: pw.TextStyle(
                      color: _PdfColors.hint, fontSize: 9)),
              pw.SizedBox(height: 4),
              pw.Text(dateRange,
                  style: pw.TextStyle(
                      color: _PdfColors.primary,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // ── KPI Box ──────────────────────────────────────────────────────────────
  static pw.Widget _kpiBox(
      String label, String value, {PdfColor? color}) {
    final c = color ?? _PdfColors.primary;
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: _PdfColors.grey200,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
          border: pw.Border(
            left: pw.BorderSide(color: c, width: 3),
          ),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label,
                style: pw.TextStyle(
                    color: _PdfColors.grey800, fontSize: 8)),
            pw.SizedBox(height: 4),
            pw.Text(value,
                style: pw.TextStyle(
                    color: c,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ── Section Header ───────────────────────────────────────────────────────
  static pw.Widget _sectionHeader(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 16, bottom: 8),
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: pw.BoxDecoration(
        color: _PdfColors.grey200,
        border: pw.Border(
          bottom: pw.BorderSide(color: _PdfColors.primary, width: 2),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
            color: _PdfColors.grey800,
            fontSize: 11,
            fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  // ── Table Rows ────────────────────────────────────────────────────────────
  static pw.Widget _tableHeaderRow(List<String> headers) {
    return pw.Container(
      color: _PdfColors.grey800,
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: pw.Row(
        children: headers
            .asMap()
            .entries
            .map(
              (e) => pw.Expanded(
                flex: e.key == 0 ? 2 : 1,
                child: pw.Text(
                  e.value,
                  style: pw.TextStyle(
                      color: _PdfColors.white,
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static pw.Widget _tableDataRow(List<String> cells, bool isAlternate) {
    return pw.Container(
      color: isAlternate ? _PdfColors.grey200 : _PdfColors.white,
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: pw.Row(
        children: cells
            .asMap()
            .entries
            .map(
              (e) => pw.Expanded(
                flex: e.key == 0 ? 2 : 1,
                child: pw.Text(
                  e.value,
                  style: pw.TextStyle(
                      color: _PdfColors.grey800, fontSize: 8),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ── Footer ───────────────────────────────────────────────────────────────
  static pw.Widget _footer(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Generated by Easy Poultry Manager',
          style: pw.TextStyle(color: _PdfColors.hint, fontSize: 8),
        ),
        pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: pw.TextStyle(color: _PdfColors.hint, fontSize: 8),
        ),
      ],
    );
  }

  // ── 🥚 EGG PRODUCTION REPORT ─────────────────────────────────────────────
  static Future<pw.Document> generateEggReport(EggReportData data) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _header(
            'Egg Production Report',
            data.farmName,
            data.filter.dateRangeLabel),
        footer: _footer,
        build: (context) => [
          pw.SizedBox(height: 16),
          pw.Row(
            children: [
              _kpiBox('Total Eggs', '${data.totalEggs}',
                  color: _PdfColors.primary),
              pw.SizedBox(width: 8),
              _kpiBox('Good Eggs', '${data.goodEggs}',
                  color: _PdfColors.income),
              pw.SizedBox(width: 8),
              _kpiBox('Broken', '${data.brokenEggs}',
                  color: _PdfColors.expense),
              pw.SizedBox(width: 8),
              _kpiBox('Trays',
                  data.totalTrays.toStringAsFixed(1)),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _kpiBox('Collections', '${data.collectionCount}'),
              pw.SizedBox(width: 8),
              _kpiBox(
                  'Avg / Day',
                  data.collectionCount > 0
                      ? '${(data.goodEggs / data.collectionCount).toStringAsFixed(0)} eggs'
                      : '—'),
              pw.SizedBox(width: 8),
              _kpiBox(
                  'Break Rate',
                  data.totalEggs > 0
                      ? '${(data.brokenEggs / data.totalEggs * 100).toStringAsFixed(1)}%'
                      : '0%',
                  color: data.brokenEggs > 0
                      ? _PdfColors.warning
                      : _PdfColors.income),
              pw.SizedBox(width: 8),
              _kpiBox('Crates',
                  (data.totalTrays / 10).toStringAsFixed(1)),
            ],
          ),
          _sectionHeader('Collection Log'),
          _tableHeaderRow(['Date', 'Flock', 'Total', 'Broken', 'Good', 'Trays']),
          ...data.collections.asMap().entries.map((e) {
            final c = e.value;
            final good = (c['eggs'] as int) - (c['broken'] as int);
            return _tableDataRow(
              [
                c['date'] as String,
                c['flock'] as String? ?? 'Farm-wide',
                '${c['eggs']}',
                '${c['broken']}',
                '$good',
                '${(good / 30).toStringAsFixed(1)}',
              ],
              e.key.isOdd,
            );
          }),
        ],
      ),
    );
    return doc;
  }

  // ── 🌾 FEEDING REPORT ────────────────────────────────────────────────────
  static Future<pw.Document> generateFeedReport(FeedReportData data) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _header(
            'Feeding Report',
            data.farmName,
            data.filter.dateRangeLabel),
        footer: _footer,
        build: (context) => [
          pw.SizedBox(height: 16),
          pw.Row(
            children: [
              _kpiBox(
                  'Total Consumed',
                  '${data.totalKgConsumed.toStringAsFixed(1)} kg',
                  color: _PdfColors.primary),
              pw.SizedBox(width: 8),
              _kpiBox(
                  'Total Feed Cost',
                  'LKR ${data.totalCost.toStringAsFixed(0)}',
                  color: _PdfColors.expense),
              pw.SizedBox(width: 8),
              _kpiBox(
                  'Avg Cost/kg',
                  data.totalKgConsumed > 0
                      ? 'LKR ${(data.totalCost / data.totalKgConsumed).toStringAsFixed(0)}'
                      : '—'),
            ],
          ),
          _sectionHeader('Feed Consumption by Type'),
          _tableHeaderRow(['Feed Type', 'Consumed (kg)', 'Cost (LKR)']),
          ...data.byFeedType.asMap().entries.map((e) {
            final f = e.value;
            return _tableDataRow(
              [
                f['name'] as String,
                '${(f['kg'] as double).toStringAsFixed(1)}',
                'LKR ${(f['cost'] as double).toStringAsFixed(0)}',
              ],
              e.key.isOdd,
            );
          }),
          _sectionHeader('Feed Log'),
          _tableHeaderRow(['Date', 'Flock/Batch', 'Feed Type', 'Qty (kg)', 'Cost']),
          ...data.logs.asMap().entries.map((e) {
            final l = e.value;
            return _tableDataRow(
              [
                l['date'] as String,
                l['flock'] as String? ?? 'Farm-wide',
                l['feed'] as String,
                '${(l['kg'] as double).toStringAsFixed(1)}',
                'LKR ${(l['cost'] as double).toStringAsFixed(0)}',
              ],
              e.key.isOdd,
            );
          }),
        ],
      ),
    );
    return doc;
  }

  // ── 💊 HEALTH REPORT ─────────────────────────────────────────────────────
  static Future<pw.Document> generateHealthReport(HealthReportData data) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _header(
            'Health & Vaccination Report',
            data.farmName,
            data.filter.dateRangeLabel),
        footer: _footer,
        build: (context) => [
          pw.SizedBox(height: 16),
          pw.Row(
            children: [
              _kpiBox('Total Records', '${data.totalRecords}',
                  color: _PdfColors.primary),
              pw.SizedBox(width: 8),
              _kpiBox('Vaccinations', '${data.vaccinationCount}'),
              pw.SizedBox(width: 8),
              _kpiBox('Medications', '${data.medicationCount}',
                  color: _PdfColors.warning),
              pw.SizedBox(width: 8),
              _kpiBox('Observations', '${data.observationCount}'),
            ],
          ),
          _sectionHeader('Health Records'),
          _tableHeaderRow(['Date', 'Flock', 'Type', 'Product', 'Dosage']),
          ...data.records.asMap().entries.map((e) {
            final r = e.value;
            return _tableDataRow(
              [
                r['date'] as String,
                r['flock'] as String? ?? '—',
                r['type'] as String,
                r['name'] as String,
                r['dosage'] as String? ?? '—',
              ],
              e.key.isOdd,
            );
          }),
          if (data.schedule.isNotEmpty) ...[
            _sectionHeader('Vaccination Schedule'),
            _tableHeaderRow(['Vaccine', 'Flock', 'Due Date', 'Status']),
            ...data.schedule.asMap().entries.map((e) {
              final s = e.value;
              return _tableDataRow(
                [
                  s['vaccine'] as String,
                  s['flock'] as String? ?? '—',
                  s['dueDate'] as String,
                  s['status'] as String,
                ],
                e.key.isOdd,
              );
            }),
          ],
        ],
      ),
    );
    return doc;
  }

  // ── 💰 FINANCE P&L REPORT ─────────────────────────────────────────────────
  static Future<pw.Document> generateFinanceReport(FinanceReportData data) async {
    final doc = pw.Document();
    final isProfit = data.netProfit >= 0;
    final netColor = isProfit ? _PdfColors.income : _PdfColors.expense;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _header(
            'Finance P&L Report',
            data.farmName,
            data.filter.dateRangeLabel),
        footer: _footer,
        build: (context) => [
          pw.SizedBox(height: 16),
          // P&L Summary hero
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: _PdfColors.grey200,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              border: pw.Border.all(color: netColor, width: 1.5),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  isProfit ? 'Net Profit' : 'Net Loss',
                  style: pw.TextStyle(
                      color: netColor,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'LKR ${data.netProfit.abs().toStringAsFixed(0)}',
                  style: pw.TextStyle(
                      color: netColor,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            children: [
              _kpiBox(
                  'Total Income',
                  'LKR ${data.totalIncome.toStringAsFixed(0)}',
                  color: _PdfColors.income),
              pw.SizedBox(width: 8),
              _kpiBox(
                  'Total Expenses',
                  'LKR ${data.totalExpense.toStringAsFixed(0)}',
                  color: _PdfColors.expense),
              pw.SizedBox(width: 8),
              _kpiBox(
                  'Profit Margin',
                  data.totalIncome > 0
                      ? '${(data.netProfit / data.totalIncome * 100).toStringAsFixed(1)}%'
                      : '—',
                  color: netColor),
            ],
          ),
          _sectionHeader('Income Breakdown'),
          _tableHeaderRow(['Category', 'Amount (LKR)', '% of Total']),
          ...data.incomeByCategory.asMap().entries.map((e) {
            final c = e.value;
            final pct = data.totalIncome > 0
                ? (c['amount'] as double) / data.totalIncome * 100
                : 0.0;
            return _tableDataRow(
              [
                c['category'] as String,
                'LKR ${(c['amount'] as double).toStringAsFixed(0)}',
                '${pct.toStringAsFixed(1)}%',
              ],
              e.key.isOdd,
            );
          }),
          _sectionHeader('Expense Breakdown'),
          _tableHeaderRow(['Category', 'Amount (LKR)', '% of Total']),
          ...data.expenseByCategory.asMap().entries.map((e) {
            final c = e.value;
            final pct = data.totalExpense > 0
                ? (c['amount'] as double) / data.totalExpense * 100
                : 0.0;
            return _tableDataRow(
              [
                c['category'] as String,
                'LKR ${(c['amount'] as double).toStringAsFixed(0)}',
                '${pct.toStringAsFixed(1)}%',
              ],
              e.key.isOdd,
            );
          }),
          _sectionHeader('Transaction History'),
          _tableHeaderRow(['Date', 'Type', 'Category', 'Description', 'Amount']),
          ...data.transactions.asMap().entries.map((e) {
            final t = e.value;
            final isInc = t['type'] == 'Income';
            return _tableDataRow(
              [
                t['date'] as String,
                t['type'] as String,
                t['category'] as String,
                t['desc'] as String? ?? '—',
                '${isInc ? '+' : '-'} LKR ${(t['amount'] as double).toStringAsFixed(0)}',
              ],
              e.key.isOdd,
            );
          }),
        ],
      ),
    );
    return doc;
  }
}
