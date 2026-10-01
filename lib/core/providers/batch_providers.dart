import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/providers/auth_provider.dart';
import 'package:kukula_app/core/services/firestore_service.dart';
import 'package:kukula_app/core/services/local_storage_service.dart';
import 'package:kukula_app/features/meat_batches/batch_model.dart';

// ── Batch Provider (Firestore + local cache) ───────────────────────────────
final batchListProvider =
    StateNotifierProvider<BatchNotifier, List<BatchModel>>((ref) {
  return BatchNotifier(ref);
});

final meatSalesProvider =
    StateNotifierProvider<MeatSalesNotifier, List<MeatSaleModel>>((ref) {
  return MeatSalesNotifier(ref);
});

class BatchNotifier extends StateNotifier<List<BatchModel>> {
  final Ref _ref;
  BatchNotifier(this._ref) : super([]) {
    _load();
  }

  String get _uid => _ref.read(currentUidProvider);

  Future<void> _load() async {
    final uid = _uid;
    if (uid.isNotEmpty) {
      try {
        final docs = await FirestoreService.instance
            .getAll(uid, FirestoreService.batches);
        state = docs.map(BatchModel.fromJson).toList();
        return;
      } catch (_) {}
    }
    final raw = await LocalStorageService.loadBatches();
    state = raw.map(BatchModel.fromJson).toList();
  }

  void _persistLocal() {
    LocalStorageService.saveBatches(state.map((b) => b.toJson()).toList());
  }

  Future<void> _syncToFirestore(BatchModel batch) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .set(uid, FirestoreService.batches, batch.id, batch.toJson());
    } catch (_) {}
  }

  Future<void> _deleteFromFirestore(String id) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .delete(uid, FirestoreService.batches, id);
    } catch (_) {}
  }

  void addBatch(BatchModel batch) {
    state = [...state, batch];
    _persistLocal();
    _syncToFirestore(batch);
  }

  void updateBatch(BatchModel updated) {
    state = state.map((b) => b.id == updated.id ? updated : b).toList();
    _persistLocal();
    _syncToFirestore(updated);
  }

  void deleteBatch(String id) {
    state = state.where((b) => b.id != id).toList();
    _persistLocal();
    _deleteFromFirestore(id);
  }

  void closeBatch(String id) {
    BatchModel? updated;
    state = state.map((b) {
      if (b.id != id) return b;
      updated = BatchModel(
        id: b.id, farmId: b.farmId, name: b.name, breed: b.breed,
        arrivalDate: b.arrivalDate, initialCount: b.initialCount,
        currentCount: b.currentCount, supplier: b.supplier,
        status: BatchStatus.closed, createdAt: b.createdAt,
      );
      return updated!;
    }).toList();
    _persistLocal();
    if (updated != null) _syncToFirestore(updated!);
  }

  void reduceBirds(String batchId, int count, {String reason = 'mortality'}) {
    BatchModel? updated;
    state = state.map((b) {
      if (b.id != batchId) return b;
      final newCount = (b.currentCount - count).clamp(0, b.currentCount);
      final newStatus = newCount == 0 ? BatchStatus.sold : b.status;
      updated = BatchModel(
        id: b.id, farmId: b.farmId, name: b.name, breed: b.breed,
        arrivalDate: b.arrivalDate, initialCount: b.initialCount,
        currentCount: newCount, supplier: b.supplier,
        status: newStatus, createdAt: b.createdAt,
      );
      return updated!;
    }).toList();
    _persistLocal();
    if (updated != null) _syncToFirestore(updated!);
  }

  void clearAll() {
    state = [];
    _persistLocal();
  }

  Future<void> reload() => _load();
}

class MeatSalesNotifier extends StateNotifier<List<MeatSaleModel>> {
  final Ref _ref;
  MeatSalesNotifier(this._ref) : super([]) {
    _load();
  }

  String get _uid => _ref.read(currentUidProvider);

  Future<void> _load() async {
    final uid = _uid;
    if (uid.isNotEmpty) {
      try {
        final docs = await FirestoreService.instance
            .getAll(uid, 'meatSales');
        state = docs.map(MeatSaleModel.fromJson).toList();
        return;
      } catch (_) {}
    }
    final raw = await LocalStorageService.loadMeatSales();
    state = raw.map(MeatSaleModel.fromJson).toList();
  }

  void _persistLocal() {
    LocalStorageService.saveMeatSales(state.map((s) => s.toJson()).toList());
  }

  Future<void> _syncToFirestore(MeatSaleModel sale) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .set(uid, 'meatSales', sale.id, sale.toJson());
    } catch (_) {}
  }

  void addSale(MeatSaleModel sale) {
    state = [...state, sale];
    _persistLocal();
    _syncToFirestore(sale);
  }

  List<MeatSaleModel> salesForBatch(String batchId) =>
      state.where((s) => s.batchId == batchId).toList();

  double totalRevenueForBatch(String batchId) => salesForBatch(batchId)
      .fold(0, (sum, s) => sum + s.totalAmount);

  void clearAll() {
    state = [];
    _persistLocal();
  }

  Future<void> reload() => _load();
}
