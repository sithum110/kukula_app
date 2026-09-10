import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/features/meat_batches/batch_model.dart';

const _uuid = Uuid();

final batchListProvider =
    StateNotifierProvider<BatchNotifier, List<BatchModel>>((ref) {
  return BatchNotifier();
});

final meatSalesProvider =
    StateNotifierProvider<MeatSalesNotifier, List<MeatSaleModel>>((ref) {
  return MeatSalesNotifier();
});

class BatchNotifier extends StateNotifier<List<BatchModel>> {
  BatchNotifier() : super(_sampleBatches());

  void addBatch(BatchModel batch) {
    state = [...state, batch];
  }

  void updateBatch(BatchModel updated) {
    state = state.map((b) => b.id == updated.id ? updated : b).toList();
  }

  void deleteBatch(String id) {
    state = state.where((b) => b.id != id).toList();
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
  }
}

class MeatSalesNotifier extends StateNotifier<List<MeatSaleModel>> {
  MeatSalesNotifier() : super([]);

  void addSale(MeatSaleModel sale) {
    state = [...state, sale];
  }

  List<MeatSaleModel> salesForBatch(String batchId) =>
      state.where((s) => s.batchId == batchId).toList();

  double totalRevenueForBatch(String batchId) => salesForBatch(batchId)
      .fold(0, (sum, s) => sum + s.totalAmount);
}

List<BatchModel> _sampleBatches() => [
  BatchModel(
    id: _uuid.v4(), farmId: 'farm1', name: 'Batch Jan 2026',
    breed: 'Cobb 500', arrivalDate: DateTime.now().subtract(const Duration(days: 42)),
    initialCount: 500, currentCount: 488, supplier: 'Siyane Hatchery',
    status: BatchStatus.growing, createdAt: DateTime.now().subtract(const Duration(days: 42)),
  ),
  BatchModel(
    id: _uuid.v4(), farmId: 'farm1', name: 'Batch Feb 2026',
    breed: 'Ross 308', arrivalDate: DateTime.now().subtract(const Duration(days: 18)),
    initialCount: 600, currentCount: 595, supplier: 'Lanka Hatchery',
    status: BatchStatus.growing, createdAt: DateTime.now().subtract(const Duration(days: 18)),
  ),
];
