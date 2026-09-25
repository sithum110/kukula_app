import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/features/egg_production/egg_model.dart';

const _uuid = Uuid();

// ── Egg Collection Provider ───────────────────────────────────────────────
final eggRecordListProvider =
    StateNotifierProvider<EggRecordNotifier, List<EggRecordModel>>((ref) {
  return EggRecordNotifier();
});

class EggRecordNotifier extends StateNotifier<List<EggRecordModel>> {
  EggRecordNotifier() : super([]) {}

  void addRecord(EggRecordModel record) {
    state = [record, ...state]; // newest first
    // Auto-update egg stock
  }

  void deleteRecord(String id) {
    state = state.where((r) => r.id != id).toList();
  }

  void clearAll() => state = [];

  // Today's total
  int get todayTotal {
    final today = DateTime.now();
    return state
        .where((r) =>
            r.date.year == today.year &&
            r.date.month == today.month &&
            r.date.day == today.day)
        .fold(0, (sum, r) => sum + r.goodEggs);
  }

  // Weekly totals for chart (last 7 days)
  List<int> get weeklyTotals {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return state
          .where((r) =>
              r.date.year == day.year &&
              r.date.month == day.month &&
              r.date.day == day.day)
          .fold(0, (sum, r) => sum + r.goodEggs);
    });
  }
}

// ── Egg Stock Provider ────────────────────────────────────────────────────
final eggStockProvider = StateNotifierProvider<EggStockNotifier, int>((ref) {
  // Start with some sample stock
  return EggStockNotifier(1240);
});

class EggStockNotifier extends StateNotifier<int> {
  EggStockNotifier(int initial) : super(initial);

  void addEggs(int count) => state = state + count;
  void removeEggs(int count) => state = (state - count).clamp(0, state + count);
  void clearAll() => state = 0;
  int get trays => state ~/ 30;
}

// ── Egg Sales Provider ────────────────────────────────────────────────────
final eggSaleListProvider =
    StateNotifierProvider<EggSaleNotifier, List<EggSaleModel>>((ref) {
  return EggSaleNotifier();
});

class EggSaleNotifier extends StateNotifier<List<EggSaleModel>> {
  EggSaleNotifier() : super([]) {}

  void addSale(EggSaleModel sale) {
    state = [sale, ...state];
  }

  void clearAll() => state = [];

  double get totalRevenue => state
      .where((s) => s.saleType == EggDispositionType.sale)
      .fold(0.0, (sum, s) => sum + (s.totalAmount ?? 0));
}

// ── Sample Data ───────────────────────────────────────────────────────────
List<EggRecordModel> _sampleRecords() {
  final now = DateTime.now();
  return [
    EggRecordModel(
      id: _uuid.v4(), farmId: 'farm1', flockId: null,
      date: now, totalEggs: 352, brokenEggs: 10,
      gradeA: 280, gradeB: 50, gradeC: 12,
      collectedBy: 'Nimal', createdAt: now,
    ),
    EggRecordModel(
      id: _uuid.v4(), farmId: 'farm1', flockId: null,
      date: now.subtract(const Duration(days: 1)),
      totalEggs: 340, brokenEggs: 8, gradeA: 270, gradeB: 55, gradeC: 7,
      collectedBy: 'Kamal', createdAt: now.subtract(const Duration(days: 1)),
    ),
    EggRecordModel(
      id: _uuid.v4(), farmId: 'farm1', flockId: null,
      date: now.subtract(const Duration(days: 2)),
      totalEggs: 365, brokenEggs: 12, gradeA: 295, gradeB: 48, gradeC: 10,
      collectedBy: 'Nimal', createdAt: now.subtract(const Duration(days: 2)),
    ),
    EggRecordModel(
      id: _uuid.v4(), farmId: 'farm1', flockId: null,
      date: now.subtract(const Duration(days: 3)),
      totalEggs: 328, brokenEggs: 6, gradeA: 265, gradeB: 50, gradeC: 7,
      collectedBy: 'Kamal', createdAt: now.subtract(const Duration(days: 3)),
    ),
    EggRecordModel(
      id: _uuid.v4(), farmId: 'farm1', flockId: null,
      date: now.subtract(const Duration(days: 4)),
      totalEggs: 348, brokenEggs: 9, collectedBy: 'Nimal',
      createdAt: now.subtract(const Duration(days: 4)),
    ),
    EggRecordModel(
      id: _uuid.v4(), farmId: 'farm1', flockId: null,
      date: now.subtract(const Duration(days: 5)),
      totalEggs: 355, brokenEggs: 11, collectedBy: 'Nimal',
      createdAt: now.subtract(const Duration(days: 5)),
    ),
    EggRecordModel(
      id: _uuid.v4(), farmId: 'farm1', flockId: null,
      date: now.subtract(const Duration(days: 6)),
      totalEggs: 360, brokenEggs: 7, collectedBy: 'Kamal',
      createdAt: now.subtract(const Duration(days: 6)),
    ),
  ];
}

List<EggSaleModel> _sampleSales() => [
  EggSaleModel(
    id: _uuid.v4(), farmId: 'farm1',
    saleType: EggDispositionType.sale,
    quantity: 300, pricePerUnit: 28.0, totalAmount: 8400.0,
    buyerName: 'Prasad Stores', date: DateTime.now(),
  ),
  EggSaleModel(
    id: _uuid.v4(), farmId: 'farm1',
    saleType: EggDispositionType.sale,
    quantity: 240, pricePerUnit: 27.0, totalAmount: 6480.0,
    buyerName: 'City Market', date: DateTime.now().subtract(const Duration(days: 2)),
  ),
  EggSaleModel(
    id: _uuid.v4(), farmId: 'farm1',
    saleType: EggDispositionType.personalUse,
    quantity: 30, date: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
