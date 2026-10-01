import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/providers/auth_provider.dart';
import 'package:kukula_app/core/services/firestore_service.dart';
import 'package:kukula_app/features/livestock_trading/livestock_trading_model.dart';

const _colPurchases = 'livestockPurchases';

// ── Provider ──────────────────────────────────────────────────────────────────
final livestockPurchaseProvider =
    StateNotifierProvider<LivestockPurchaseNotifier, List<LivestockPurchaseModel>>(
        (ref) => LivestockPurchaseNotifier(ref));

class LivestockPurchaseNotifier
    extends StateNotifier<List<LivestockPurchaseModel>> {
  final Ref _ref;

  LivestockPurchaseNotifier(this._ref) : super([]) {
    _load();
  }

  String get _uid => _ref.read(currentUidProvider);

  Future<void> _load() async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      final docs = await FirestoreService.instance.getAll(uid, _colPurchases);
      state = docs.map(LivestockPurchaseModel.fromJson).toList()
        ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
    } catch (_) {}
  }

  Future<void> _sync(LivestockPurchaseModel p) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .set(uid, _colPurchases, p.id, p.toJson());
    } catch (_) {}
  }

  Future<void> _delete(String id) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance.delete(uid, _colPurchases, id);
    } catch (_) {}
  }

  void addPurchase(LivestockPurchaseModel p) {
    state = [p, ...state];
    _sync(p);
  }

  void deletePurchase(String id) {
    state = state.where((p) => p.id != id).toList();
    _delete(id);
  }

  void clearAll() => state = [];

  Future<void> reload() => _load();

  // ── Helpers for meat sales screen ──────────────────────────────────────────
  /// Unique supplier names (for the livestock sale dropdown in meat sales)
  List<String> get supplierNames =>
      state.map((p) => p.supplierName).toSet().toList();

  /// All purchases for a given supplier
  List<LivestockPurchaseModel> forSupplier(String name) =>
      state.where((p) => p.supplierName == name).toList();
}
