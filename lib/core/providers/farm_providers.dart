import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/features/flocks/flock_model.dart';
import 'package:kukula_app/core/enums/farm_type.dart';

const _uuid = Uuid();

// ── Farm Type Provider (from onboarding selection) ─────────────────────────
final farmTypeProvider = StateProvider<FarmType>((ref) => FarmType.both);
final farmNameProvider = StateProvider<String>((ref) => 'My Poultry Farm');
final isPremiumProvider = StateProvider<bool>((ref) => false);

// ── Flock Provider ─────────────────────────────────────────────────────────
final flockListProvider =
    StateNotifierProvider<FlockNotifier, List<FlockModel>>((ref) {
  return FlockNotifier();
});

class FlockNotifier extends StateNotifier<List<FlockModel>> {
  FlockNotifier() : super(_sampleFlocks());

  void addFlock(FlockModel flock) {
    state = [...state, flock];
  }

  void updateFlock(FlockModel updated) {
    state = state.map((f) => f.id == updated.id ? updated : f).toList();
  }

  void deleteFlock(String id) {
    state = state.where((f) => f.id != id).toList();
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
  }

  void logBirdEvent(String flockId, BirdEventType type, int count, {String? cause, String? notes}) {
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
  }
}

// Sample data so Phase 2 looks populated
List<FlockModel> _sampleFlocks() => [
  FlockModel(
    id: _uuid.v4(), farmId: 'farm1', name: 'Flock A — Layers',
    breed: 'ISA Brown', purpose: FlockPurpose.layer, currentCount: 450,
    initialCount: 500, pen: 'House 1',
    arrivalDate: DateTime.now().subtract(const Duration(days: 120)),
    status: FlockStatus.active, createdAt: DateTime.now().subtract(const Duration(days: 120)),
  ),
  FlockModel(
    id: _uuid.v4(), farmId: 'farm1', name: 'Flock B — Layers',
    breed: 'Lohmann Brown', purpose: FlockPurpose.layer, currentCount: 380,
    initialCount: 400, pen: 'House 2',
    arrivalDate: DateTime.now().subtract(const Duration(days: 60)),
    status: FlockStatus.active, createdAt: DateTime.now().subtract(const Duration(days: 60)),
  ),
];
