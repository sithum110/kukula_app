import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/enums/farm_type.dart';
import 'package:kukula_app/core/services/local_storage_service.dart';
import 'package:kukula_app/features/flocks/flock_model.dart';

// ── Farm settings (SharedPreferences via main.dart overrides) ──────────────
final farmTypeProvider = StateProvider<FarmType>((ref) => FarmType.both);
final farmNameProvider = StateProvider<String>((ref) => 'My Poultry Farm');
final isPremiumProvider = StateProvider<bool>((ref) => false);

// ── Flock Provider (persisted) ─────────────────────────────────────────────
final flockListProvider =
    StateNotifierProvider<FlockNotifier, List<FlockModel>>((ref) {
  return FlockNotifier();
});

class FlockNotifier extends StateNotifier<List<FlockModel>> {
  FlockNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final raw = await LocalStorageService.loadFlocks();
    state = raw.map(FlockModel.fromJson).toList();
  }

  void _persist() {
    LocalStorageService.saveFlocks(state.map((f) => f.toJson()).toList());
  }

  void addFlock(FlockModel flock) {
    state = [...state, flock];
    _persist();
  }

  void updateFlock(FlockModel updated) {
    state = state.map((f) => f.id == updated.id ? updated : f).toList();
    _persist();
  }

  void deleteFlock(String id) {
    state = state.where((f) => f.id != id).toList();
    _persist();
  }

  void closeFlock(String id) {
    state = state.map((f) {
      if (f.id == id) return FlockModel(
        id: f.id, farmId: f.farmId, name: f.name, breed: f.breed,
        purpose: f.purpose, currentCount: f.currentCount,
        initialCount: f.initialCount, pen: f.pen,
        arrivalDate: f.arrivalDate, status: FlockStatus.closed,
        createdAt: f.createdAt,
      );
      return f;
    }).toList();
    _persist();
  }

  void clearAll() {
    state = [];
    _persist();
  }

  void logBirdEvent(String flockId, BirdEventType type, int count,
      {String? cause, String? notes}) {
    state = state.map((f) {
      if (f.id != flockId) return f;
      final newCount = type.isReduction
          ? (f.currentCount - count).clamp(0, f.currentCount)
          : f.currentCount + count;
      return FlockModel(
        id: f.id, farmId: f.farmId, name: f.name, breed: f.breed,
        purpose: f.purpose, currentCount: newCount,
        initialCount: f.initialCount, pen: f.pen,
        arrivalDate: f.arrivalDate, status: f.status,
        createdAt: f.createdAt,
      );
    }).toList();
    _persist();
  }
}
