import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/services/local_storage_service.dart';
import 'package:kukula_app/features/meat_batches/batch_model.dart';

final batchListProvider =
    StateNotifierProvider<BatchNotifier, List<BatchModel>>((ref) {
  return BatchNotifier();
});

final meatSalesProvider =
    StateNotifierProvider<MeatSalesNotifier, List<MeatSaleModel>>((ref) {
  return MeatSalesNotifier();
});

class BatchNotifier extends StateNotifier<List<BatchModel>> {
  BatchNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final raw = await LocalStorageService.loadBatches();
    state = raw.map(BatchModel.fromJson).toList();
  }

  void _persist() {
    LocalStorageService.saveBatches(state.map((b) => b.toJson()).toList());
  }

  void addBatch(BatchModel batch) {
    state = [...state, batch];
    _persist();
  }

  void updateBatch(BatchModel updated) {
    state = state.map((b) => b.id == updated.id ? updated : b).toList();
    _persist();
  }

  void deleteBatch(String id) {
    state = state.where((b) => b.id != id).toList();
    _persist();
  }

  void closeBatch(String id) {
    state = state.map((b) {
      if (b.id != id) return b;
      return BatchModel(
        id: b.id, farmId: b.farmId, name: b.name, breed: b.breed,
        arrivalDate: b.arrivalDate, initialCount: b.initialCount,
        currentCount: b.currentCount, supplier: b.supplier,
        status: BatchStatus.closed, createdAt: b.createdAt,
      );
    }).toList();
    _persist();
  }

  void reduceBirds(String batchId, int count, {String reason = 'mortality'}) {
    state = state.map((b) {
      if (b.id != batchId) return b;
      final newCount = (b.currentCount - count).clamp(0, b.currentCount);
      final newStatus = newCount == 0 ? BatchStatus.sold : b.status;
      return BatchModel(
        id: b.id, farmId: b.farmId, name: b.name, breed: b.breed,
        arrivalDate: b.arrivalDate, initialCount: b.initialCount,
        currentCount: newCount, supplier: b.supplier,
        status: newStatus, createdAt: b.createdAt,
      );
    }).toList();
    _persist();
  }

  void clearAll() {
    state = [];
    _persist();
  }
}

class MeatSalesNotifier extends StateNotifier<List<MeatSaleModel>> {
  MeatSalesNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final raw = await LocalStorageService.loadMeatSales();
    state = raw.map(MeatSaleModel.fromJson).toList();
  }

  void _persist() {
    LocalStorageService.saveMeatSales(state.map((s) => s.toJson()).toList());
  }

  void addSale(MeatSaleModel sale) {
    state = [...state, sale];
    _persist();
  }

  List<MeatSaleModel> salesForBatch(String batchId) =>
      state.where((s) => s.batchId == batchId).toList();

  double totalRevenueForBatch(String batchId) => salesForBatch(batchId)
      .fold(0, (sum, s) => sum + s.totalAmount);

  void clearAll() {
    state = [];
    _persist();
  }
}
