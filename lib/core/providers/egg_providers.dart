import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/providers/auth_provider.dart';
import 'package:kukula_app/core/services/firestore_service.dart';
import 'package:kukula_app/features/egg_production/egg_model.dart';

// ── Egg Collection Provider (Firestore) ───────────────────────────────────
final eggRecordListProvider =
    StateNotifierProvider<EggRecordNotifier, List<EggRecordModel>>((ref) {
  return EggRecordNotifier(ref);
});

class EggRecordNotifier extends StateNotifier<List<EggRecordModel>> {
  final Ref _ref;
  EggRecordNotifier(this._ref) : super([]) {
    _load();
  }

  String get _uid => _ref.read(currentUidProvider);

  Future<void> _load() async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      final docs = await FirestoreService.instance
          .getAll(uid, FirestoreService.eggRecords);
      state = docs.map(EggRecordModel.fromJson).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (_) {}
  }

  Future<void> _syncToFirestore(EggRecordModel record) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .set(uid, FirestoreService.eggRecords, record.id, record.toJson());
    } catch (_) {}
  }

  Future<void> _deleteFromFirestore(String id) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .delete(uid, FirestoreService.eggRecords, id);
    } catch (_) {}
  }

  void addRecord(EggRecordModel record) {
    state = [record, ...state]; // newest first
    _syncToFirestore(record);
  }

  void deleteRecord(String id) {
    state = state.where((r) => r.id != id).toList();
    _deleteFromFirestore(id);
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

  Future<void> reload() => _load();
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

// ── Egg Sales Provider (Firestore) ────────────────────────────────────────
final eggSaleListProvider =
    StateNotifierProvider<EggSaleNotifier, List<EggSaleModel>>((ref) {
  return EggSaleNotifier(ref);
});

class EggSaleNotifier extends StateNotifier<List<EggSaleModel>> {
  final Ref _ref;
  EggSaleNotifier(this._ref) : super([]) {
    _load();
  }

  String get _uid => _ref.read(currentUidProvider);

  Future<void> _load() async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      final docs = await FirestoreService.instance
          .getAll(uid, FirestoreService.eggSales);
      state = docs.map(EggSaleModel.fromJson).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (_) {}
  }

  Future<void> _syncToFirestore(EggSaleModel sale) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .set(uid, FirestoreService.eggSales, sale.id, sale.toJson());
    } catch (_) {}
  }

  void addSale(EggSaleModel sale) {
    state = [sale, ...state];
    _syncToFirestore(sale);
  }

  void clearAll() => state = [];

  double get totalRevenue => state
      .where((s) => s.saleType == EggDispositionType.sale)
      .fold(0.0, (sum, s) => sum + (s.totalAmount ?? 0));

  Future<void> reload() => _load();
}
