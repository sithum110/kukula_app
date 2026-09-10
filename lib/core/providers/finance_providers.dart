import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/features/finance/finance_model.dart';

const _uuid = Uuid();

final financeProvider =
    StateNotifierProvider<FinanceNotifier, List<FinanceTransactionModel>>(
        (ref) => FinanceNotifier());

class FinanceNotifier
    extends StateNotifier<List<FinanceTransactionModel>> {
  FinanceNotifier() : super(_sampleTransactions());

  void addTransaction(FinanceTransactionModel t) =>
      state = [t, ...state];

  void deleteTransaction(String id) =>
      state = state.where((t) => t.id != id).toList();

  // ── Aggregates ────────────────────────────────────────────────────────
  double get totalIncome => state
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (s, t) => s + t.amount);

  double get totalExpense => state
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (s, t) => s + t.amount);

  double get netProfit => totalIncome - totalExpense;

  // This month
  double get monthIncome {
    final now = DateTime.now();
    return state
        .where((t) =>
            t.type == TransactionType.income &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (s, t) => s + t.amount);
  }

  double get monthExpense {
    final now = DateTime.now();
    return state
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (s, t) => s + t.amount);
  }

  double get monthProfit => monthIncome - monthExpense;

  // Per-category breakdown
  Map<FinanceCategory, double> get categoryTotals {
    final map = <FinanceCategory, double>{};
    for (final t in state) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  // Top 5 income categories
  List<MapEntry<FinanceCategory, double>> get topIncomeCategories {
    final map = <FinanceCategory, double>{};
    for (final t in state.where((t) => t.type == TransactionType.income)) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).toList();
  }

  // Top 5 expense categories
  List<MapEntry<FinanceCategory, double>> get topExpenseCategories {
    final map = <FinanceCategory, double>{};
    for (final t in state.where((t) => t.type == TransactionType.expense)) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).toList();
  }

  // Recent 7-day daily net
  List<double> get last7DaysNet {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      final dayTx = state.where((t) =>
          t.date.year == day.year &&
          t.date.month == day.month &&
          t.date.day == day.day);
      final inc = dayTx
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (s, t) => s + t.amount);
      final exp = dayTx
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (s, t) => s + t.amount);
      return inc - exp;
    });
  }

  // Group transactions by date label
  Map<String, List<FinanceTransactionModel>> get groupedByDate {
    final grouped = <String, List<FinanceTransactionModel>>{};
    for (final t in state) {
      final key = _dateKey(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    return grouped;
  }

  String _dateKey(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
    }
    final yest = now.subtract(const Duration(days: 1));
    if (d.year == yest.year && d.month == yest.month && d.day == yest.day) {
      return 'Yesterday';
    }
    return '${d.day.toString().padLeft(2, '0')} ${_mon(d.month)} ${d.year}';
  }

  String _mon(int m) => ['','Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'][m];
}

// ── Sample Data ────────────────────────────────────────────────────────────
List<FinanceTransactionModel> _sampleTransactions() {
  final now = DateTime.now();
  return [
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.income,
      category: FinanceCategory.eggSales,
      amount: 18500, description: '370 trays @ LKR 50/egg',
      date: now, createdAt: now,
    ),
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.expense,
      category: FinanceCategory.feedCost,
      amount: 9500, description: 'Layer pellets — 100kg',
      date: now, createdAt: now,
    ),
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.income,
      category: FinanceCategory.meatSales,
      amount: 32000, description: '40 broilers @ LKR 800',
      date: now.subtract(const Duration(days: 1)), createdAt: now,
    ),
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.expense,
      category: FinanceCategory.labourCost,
      amount: 25000, description: 'Monthly wages — 2 workers',
      date: now.subtract(const Duration(days: 1)), createdAt: now,
    ),
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.expense,
      category: FinanceCategory.medicineCost,
      amount: 3200, description: 'Vaccines + Amoxicillin',
      date: now.subtract(const Duration(days: 2)), createdAt: now,
    ),
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.income,
      category: FinanceCategory.eggSales,
      amount: 15000, description: '300 trays @ LKR 50/egg',
      date: now.subtract(const Duration(days: 2)), createdAt: now,
    ),
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.expense,
      category: FinanceCategory.utilities,
      amount: 4500, description: 'Electricity bill',
      date: now.subtract(const Duration(days: 3)), createdAt: now,
    ),
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.expense,
      category: FinanceCategory.feedCost,
      amount: 11200, description: 'Broiler starter — 120kg',
      date: now.subtract(const Duration(days: 3)), createdAt: now,
    ),
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.income,
      category: FinanceCategory.meatSales,
      amount: 24000, description: '30 broilers',
      date: now.subtract(const Duration(days: 4)), createdAt: now,
    ),
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.expense,
      category: FinanceCategory.transport,
      amount: 1800, description: 'Delivery to market',
      date: now.subtract(const Duration(days: 4)), createdAt: now,
    ),
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.income,
      category: FinanceCategory.eggSales,
      amount: 12000, description: 'Weekly egg sales',
      date: now.subtract(const Duration(days: 5)), createdAt: now,
    ),
    FinanceTransactionModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: TransactionType.expense,
      category: FinanceCategory.equipment,
      amount: 8500, description: 'Water nipple system repair',
      date: now.subtract(const Duration(days: 6)), createdAt: now,
    ),
  ];
}
