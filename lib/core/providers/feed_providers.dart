import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/features/feeding/feed_model.dart';

const _uuid = Uuid();

// ── Feed Types (stock registry) ───────────────────────────────────────────
final feedTypeListProvider =
    StateNotifierProvider<FeedTypeNotifier, List<FeedTypeModel>>((ref) {
  return FeedTypeNotifier();
});

class FeedTypeNotifier extends StateNotifier<List<FeedTypeModel>> {
  FeedTypeNotifier() : super(_sampleFeedTypes());

  void addFeedType(FeedTypeModel ft) => state = [...state, ft];

  void updateFeedType(FeedTypeModel updated) =>
      state = state.map((f) => f.id == updated.id ? updated : f).toList();

  void deleteFeedType(String id) =>
      state = state.where((f) => f.id != id).toList();

  /// Deduct from stock when a feed log is added
  void deductStock(String feedTypeId, double kg) {
    state = state.map((f) {
      if (f.id != feedTypeId) return f;
      final newStock = (f.currentStockKg - kg).clamp(0.0, double.infinity);
      return f.copyWith(currentStockKg: newStock);
    }).toList();
  }

  /// Add to stock when restocked
  void addStock(String feedTypeId, double kg) {
    state = state.map((f) {
      if (f.id != feedTypeId) return f;
      return f.copyWith(currentStockKg: f.currentStockKg + kg);
    }).toList();
  }

  List<FeedTypeModel> get lowStockItems =>
      state.where((f) => f.isLowStock).toList();

  int get lowStockCount => lowStockItems.length;

  void clearAll() => state = [];
}

// ── Feed Log Provider ─────────────────────────────────────────────────────
final feedLogListProvider =
    StateNotifierProvider<FeedLogNotifier, List<FeedLogModel>>((ref) {
  return FeedLogNotifier();
});

class FeedLogNotifier extends StateNotifier<List<FeedLogModel>> {
  FeedLogNotifier() : super(_sampleLogs());

  void addLog(FeedLogModel log) => state = [log, ...state];

  void deleteLog(String id) => state = state.where((l) => l.id != id).toList();

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

// ── Sample Data ───────────────────────────────────────────────────────────
List<FeedTypeModel> _sampleFeedTypes() => [
  FeedTypeModel(
    id: 'ft1', farmId: 'farm1',
    name: 'Layer Pellets', brand: 'CIC Feeds',
    forPurpose: 'layer', currentStockKg: 42.0,
    lowStockThresholdKg: 50.0, pricePerKg: 95.0,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
  ),
  FeedTypeModel(
    id: 'ft2', farmId: 'farm1',
    name: 'Broiler Starter', brand: 'Prima Feeds',
    forPurpose: 'broiler', currentStockKg: 180.0,
    lowStockThresholdKg: 100.0, pricePerKg: 105.0,
    createdAt: DateTime.now().subtract(const Duration(days: 50)),
  ),
  FeedTypeModel(
    id: 'ft3', farmId: 'farm1',
    name: 'Broiler Finisher', brand: 'Prima Feeds',
    forPurpose: 'broiler', currentStockKg: 25.0,
    lowStockThresholdKg: 80.0, pricePerKg: 112.0,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  ),
  FeedTypeModel(
    id: 'ft4', farmId: 'farm1',
    name: 'Crushed Maize', brand: null,
    forPurpose: 'all', currentStockKg: 320.0,
    lowStockThresholdKg: 100.0, pricePerKg: 75.0,
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
  ),
];

List<FeedLogModel> _sampleLogs() {
  final now = DateTime.now();
  return [
    FeedLogModel(
      id: _uuid.v4(), farmId: 'farm1',
      feedTypeId: 'ft1', feedTypeName: 'Layer Pellets',
      flockId: null, flockName: 'All Layer Flocks',
      quantityKg: 25.0, costLKR: 2375.0,
      date: now, createdAt: now,
    ),
    FeedLogModel(
      id: _uuid.v4(), farmId: 'farm1',
      feedTypeId: 'ft2', feedTypeName: 'Broiler Starter',
      flockId: null, flockName: 'Batch Jan 2026',
      quantityKg: 40.0, costLKR: 4200.0,
      date: now, createdAt: now,
    ),
    FeedLogModel(
      id: _uuid.v4(), farmId: 'farm1',
      feedTypeId: 'ft1', feedTypeName: 'Layer Pellets',
      flockId: null, flockName: 'All Layer Flocks',
      quantityKg: 25.0, costLKR: 2375.0,
      date: now.subtract(const Duration(days: 1)), createdAt: now,
    ),
    FeedLogModel(
      id: _uuid.v4(), farmId: 'farm1',
      feedTypeId: 'ft3', feedTypeName: 'Broiler Finisher',
      flockId: null, flockName: 'Batch Feb 2026',
      quantityKg: 30.0, costLKR: 3360.0,
      date: now.subtract(const Duration(days: 1)), createdAt: now,
    ),
    FeedLogModel(
      id: _uuid.v4(), farmId: 'farm1',
      feedTypeId: 'ft4', feedTypeName: 'Crushed Maize',
      flockId: null, flockName: 'All Flocks',
      quantityKg: 50.0, costLKR: 3750.0,
      date: now.subtract(const Duration(days: 2)), createdAt: now,
    ),
  ];
}
