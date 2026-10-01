import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/providers/auth_provider.dart';
import 'package:kukula_app/core/services/firestore_service.dart';
import 'package:kukula_app/features/feeding/feed_model.dart';

// ── Feed Types (Firestore) ────────────────────────────────────────────────
final feedTypeListProvider =
    StateNotifierProvider<FeedTypeNotifier, List<FeedTypeModel>>((ref) {
  return FeedTypeNotifier(ref);
});

class FeedTypeNotifier extends StateNotifier<List<FeedTypeModel>> {
  final Ref _ref;
  FeedTypeNotifier(this._ref) : super([]) {
    _load();
  }

  String get _uid => _ref.read(currentUidProvider);

  Future<void> _load() async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      final docs = await FirestoreService.instance
          .getAll(uid, FirestoreService.feedTypes);
      state = docs.map(FeedTypeModel.fromJson).toList();
    } catch (_) {}
  }

  Future<void> _sync(FeedTypeModel ft) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .set(uid, FirestoreService.feedTypes, ft.id, ft.toJson());
    } catch (_) {}
  }

  Future<void> _delete(String id) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .delete(uid, FirestoreService.feedTypes, id);
    } catch (_) {}
  }

  void addFeedType(FeedTypeModel ft) {
    state = [...state, ft];
    _sync(ft);
  }

  void updateFeedType(FeedTypeModel updated) {
    state = state.map((f) => f.id == updated.id ? updated : f).toList();
    _sync(updated);
  }

  void deleteFeedType(String id) {
    state = state.where((f) => f.id != id).toList();
    _delete(id);
  }

  /// Deduct from stock when a feed log is added
  void deductStock(String feedTypeId, double kg) {
    FeedTypeModel? updated;
    state = state.map((f) {
      if (f.id != feedTypeId) return f;
      final newStock = (f.currentStockKg - kg).clamp(0.0, double.infinity);
      updated = f.copyWith(currentStockKg: newStock);
      return updated!;
    }).toList();
    if (updated != null) _sync(updated!);
  }

  /// Add to stock when restocked
  void addStock(String feedTypeId, double kg) {
    FeedTypeModel? updated;
    state = state.map((f) {
      if (f.id != feedTypeId) return f;
      updated = f.copyWith(currentStockKg: f.currentStockKg + kg);
      return updated!;
    }).toList();
    if (updated != null) _sync(updated!);
  }

  List<FeedTypeModel> get lowStockItems =>
      state.where((f) => f.isLowStock).toList();

  int get lowStockCount => lowStockItems.length;

  void clearAll() => state = [];

  Future<void> reload() => _load();
}

// ── Feed Log Provider (Firestore) ─────────────────────────────────────────
final feedLogListProvider =
    StateNotifierProvider<FeedLogNotifier, List<FeedLogModel>>((ref) {
  return FeedLogNotifier(ref);
});

class FeedLogNotifier extends StateNotifier<List<FeedLogModel>> {
  final Ref _ref;
  FeedLogNotifier(this._ref) : super([]) {
    _load();
  }

  String get _uid => _ref.read(currentUidProvider);

  Future<void> _load() async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      final docs = await FirestoreService.instance
          .getAll(uid, FirestoreService.feedLogs);
      state = docs.map(FeedLogModel.fromJson).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (_) {}
  }

  Future<void> _sync(FeedLogModel log) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .set(uid, FirestoreService.feedLogs, log.id, log.toJson());
    } catch (_) {}
  }

  Future<void> _delete(String id) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .delete(uid, FirestoreService.feedLogs, id);
    } catch (_) {}
  }

  void addLog(FeedLogModel log) {
    state = [log, ...state];
    _sync(log);
  }

  void deleteLog(String id) {
    state = state.where((l) => l.id != id).toList();
    _delete(id);
  }

  void clearAll() => state = [];

  double get totalKgThisWeek {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return state
        .where((l) => l.date.isAfter(weekAgo))
        .fold(0.0, (sum, l) => sum + l.quantityKg);
  }

  double get totalCostThisMonth {
    final now = DateTime.now();
    return state
        .where((l) => l.date.month == now.month && l.date.year == now.year)
        .fold(0.0, (sum, l) => sum + (l.costLKR ?? 0));
  }

  // Group logs by date (newest first)
  Map<String, List<FeedLogModel>> get groupedByDate {
    final grouped = <String, List<FeedLogModel>>{};
    for (final log in state) {
      final key = _dateKey(log.date);
      grouped.putIfAbsent(key, () => []).add(log);
    }
    return grouped;
  }

  String _dateKey(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (d.year == yesterday.year && d.month == yesterday.month && d.day == yesterday.day) {
      return 'Yesterday';
    }
    return '${d.day.toString().padLeft(2, '0')} ${_month(d.month)} ${d.year}';
  }

  String _month(int m) => ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m];

  Future<void> reload() => _load();
}

// ── Stock Purchases Provider ──────────────────────────────────────────────
final feedPurchaseListProvider =
    StateNotifierProvider<FeedPurchaseNotifier, List<FeedStockPurchaseModel>>((ref) {
  return FeedPurchaseNotifier();
});

class FeedPurchaseNotifier extends StateNotifier<List<FeedStockPurchaseModel>> {
  FeedPurchaseNotifier() : super([]);

  void addPurchase(FeedStockPurchaseModel p) => state = [p, ...state];

  void clearAll() => state = [];
}
