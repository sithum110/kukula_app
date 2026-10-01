import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/enums/farm_type.dart';
import 'package:kukula_app/core/providers/auth_provider.dart';
import 'package:kukula_app/core/services/firestore_service.dart';
import 'package:kukula_app/core/services/local_storage_service.dart';
import 'package:kukula_app/features/flocks/flock_model.dart';

// ── Farm settings (SharedPreferences via main.dart overrides) ──────────────
final farmTypeProvider = StateProvider<FarmType>((ref) => FarmType.both);
final farmNameProvider = StateProvider<String>((ref) => 'My Poultry Farm');
final isPremiumProvider = StateProvider<bool>((ref) => false);

// ── Flock Provider (Firestore + local cache) ───────────────────────────────
final flockListProvider =
    StateNotifierProvider<FlockNotifier, List<FlockModel>>((ref) {
  return FlockNotifier(ref);
});

class FlockNotifier extends StateNotifier<List<FlockModel>> {
  final Ref _ref;
  FlockNotifier(this._ref) : super([]) {
    _load();
  }

  String get _uid => _ref.read(currentUidProvider);

  Future<void> _load() async {
    final uid = _uid;
    if (uid.isNotEmpty) {
      try {
        final docs = await FirestoreService.instance
            .getAll(uid, FirestoreService.flocks);
        state = docs.map(FlockModel.fromJson).toList();
        return;
      } catch (_) {
        // fall through to local cache
      }
    }
    final raw = await LocalStorageService.loadFlocks();
    state = raw.map(FlockModel.fromJson).toList();
  }

  void _persistLocal() {
    LocalStorageService.saveFlocks(state.map((f) => f.toJson()).toList());
  }

  Future<void> _syncToFirestore(FlockModel flock) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .set(uid, FirestoreService.flocks, flock.id, flock.toJson());
    } catch (_) {}
  }

  Future<void> _deleteFromFirestore(String id) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .delete(uid, FirestoreService.flocks, id);
    } catch (_) {}
  }

  void addFlock(FlockModel flock) {
    state = [...state, flock];
    _persistLocal();
    _syncToFirestore(flock);
  }

  void updateFlock(FlockModel updated) {
    state = state.map((f) => f.id == updated.id ? updated : f).toList();
    _persistLocal();
    _syncToFirestore(updated);
  }

  void deleteFlock(String id) {
    state = state.where((f) => f.id != id).toList();
    _persistLocal();
    _deleteFromFirestore(id);
  }

  void closeFlock(String id) {
    state = state.map((f) {
      if (f.id == id) {
        return FlockModel(
          id: f.id, farmId: f.farmId, name: f.name, breed: f.breed,
          purpose: f.purpose, currentCount: f.currentCount,
          initialCount: f.initialCount, pen: f.pen,
          arrivalDate: f.arrivalDate, status: FlockStatus.closed,
          createdAt: f.createdAt,
        );
      }
      return f;
    }).toList();
    _persistLocal();
    final closed = state.firstWhere((f) => f.id == id, orElse: () => state.first);
    _syncToFirestore(closed);
  }

  void logBirdEvent(String flockId, BirdEventType type, int count,
      {String? cause, String? notes}) {
    FlockModel? updated;
    state = state.map((f) {
      if (f.id != flockId) return f;
      final newCount = type.isReduction
          ? (f.currentCount - count).clamp(0, f.currentCount)
          : f.currentCount + count;
      updated = FlockModel(
        id: f.id, farmId: f.farmId, name: f.name, breed: f.breed,
        purpose: f.purpose, currentCount: newCount,
        initialCount: f.initialCount, pen: f.pen,
        arrivalDate: f.arrivalDate, status: f.status,
        createdAt: f.createdAt,
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

  /// Reload fresh data from Firestore (e.g. after sign-in)
  Future<void> reload() => _load();
}
