import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/providers/auth_provider.dart';
import 'package:kukula_app/core/services/firestore_service.dart';
import 'package:kukula_app/features/health/health_model.dart';

// ── Health Records Provider (Firestore) ────────────────────────────────────
final healthRecordListProvider =
    StateNotifierProvider<HealthRecordNotifier, List<HealthRecordModel>>((ref) {
  return HealthRecordNotifier(ref);
});

class HealthRecordNotifier extends StateNotifier<List<HealthRecordModel>> {
  final Ref _ref;
  HealthRecordNotifier(this._ref) : super([]) {
    _load();
  }

  String get _uid => _ref.read(currentUidProvider);

  Future<void> _load() async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      final docs = await FirestoreService.instance
          .getAll(uid, FirestoreService.healthRecords);
      state = docs.map(HealthRecordModel.fromJson).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (_) {}
  }

  Future<void> _sync(HealthRecordModel record) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance.set(
          uid, FirestoreService.healthRecords, record.id, record.toJson());
    } catch (_) {}
  }

  Future<void> _delete(String id) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .delete(uid, FirestoreService.healthRecords, id);
    } catch (_) {}
  }

  void addRecord(HealthRecordModel record) {
    state = [record, ...state];
    _sync(record);
  }

  void deleteRecord(String id) {
    state = state.where((r) => r.id != id).toList();
    _delete(id);
  }

  void clearAll() => state = [];

  Map<String, List<HealthRecordModel>> get groupedByDate {
    final grouped = <String, List<HealthRecordModel>>{};
    for (final r in state) {
      final key = _dateKey(r.date);
      grouped.putIfAbsent(key, () => []).add(r);
    }
    return grouped;
  }

  List<HealthRecordModel> get upcomingTreatments => state
      .where((r) =>
          r.nextDueDate != null &&
          r.nextDueDate!.isAfter(DateTime.now()) &&
          r.nextDueDate!.difference(DateTime.now()).inDays <= 7)
      .toList();

  String _dateKey(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
    }
    final y = now.subtract(const Duration(days: 1));
    if (d.year == y.year && d.month == y.month && d.day == y.day) {
      return 'Yesterday';
    }
    return '${d.day.toString().padLeft(2, '0')} ${_month(d.month)} ${d.year}';
  }

  String _month(int m) => ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m];

  Future<void> reload() => _load();
}

// ── Vaccination Schedule Provider (Firestore) ─────────────────────────────
final vaccinationScheduleProvider =
    StateNotifierProvider<VaccinationScheduleNotifier, List<VaccinationScheduleModel>>(
        (ref) => VaccinationScheduleNotifier(ref));

class VaccinationScheduleNotifier
    extends StateNotifier<List<VaccinationScheduleModel>> {
  final Ref _ref;
  VaccinationScheduleNotifier(this._ref) : super([]) {
    _load();
  }

  String get _uid => _ref.read(currentUidProvider);

  Future<void> _load() async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      final docs = await FirestoreService.instance
          .getAll(uid, FirestoreService.vaccinationSchedules);
      state = docs.map(VaccinationScheduleModel.fromJson).toList();
    } catch (_) {}
  }

  Future<void> _sync(VaccinationScheduleModel s) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance.set(
          uid, FirestoreService.vaccinationSchedules, s.id, s.toJson());
    } catch (_) {}
  }

  Future<void> _delete(String id) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .delete(uid, FirestoreService.vaccinationSchedules, id);
    } catch (_) {}
  }

  void addSchedule(VaccinationScheduleModel s) {
    state = [...state, s];
    _sync(s);
  }

  void markComplete(String id) {
    final updated = state
        .map((s) => s.id == id ? s.copyWith(isCompleted: true) : s)
        .toList();
    state = updated;
    final item = state.firstWhere((s) => s.id == id,
        orElse: () => state.first);
    _sync(item);
  }

  void deleteSchedule(String id) {
    state = state.where((s) => s.id != id).toList();
    _delete(id);
  }

  void clearAll() => state = [];

  List<VaccinationScheduleModel> get overdue =>
      state.where((s) => s.isOverdue).toList();

  List<VaccinationScheduleModel> get dueSoon => state
      .where((s) =>
          !s.isCompleted &&
          !s.isOverdue &&
          s.daysUntilDue >= 0 &&
          s.daysUntilDue <= 7)
      .toList();

  List<VaccinationScheduleModel> get upcoming => state
      .where((s) => !s.isCompleted && s.daysUntilDue > 7)
      .toList();

  int get alertCount => overdue.length + dueSoon.length;

  Future<void> reload() => _load();
}

// ── Medicine Stock Provider (Firestore) ────────────────────────────────────
final medicineStockProvider =
    StateNotifierProvider<MedicineStockNotifier, List<MedicineStockModel>>(
        (ref) => MedicineStockNotifier(ref));

class MedicineStockNotifier extends StateNotifier<List<MedicineStockModel>> {
  final Ref _ref;
  MedicineStockNotifier(this._ref) : super([]) {
    _load();
  }

  String get _uid => _ref.read(currentUidProvider);

  Future<void> _load() async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      final docs = await FirestoreService.instance
          .getAll(uid, FirestoreService.medicineStock);
      state = docs.map(MedicineStockModel.fromJson).toList();
    } catch (_) {}
  }

  Future<void> _sync(MedicineStockModel item) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .set(uid, FirestoreService.medicineStock, item.id, item.toJson());
    } catch (_) {}
  }

  Future<void> _delete(String id) async {
    final uid = _uid;
    if (uid.isEmpty) return;
    try {
      await FirestoreService.instance
          .delete(uid, FirestoreService.medicineStock, id);
    } catch (_) {}
  }

  void addItem(MedicineStockModel item) {
    state = [...state, item];
    _sync(item);
  }

  void deductStock(String id, double qty) {
    MedicineStockModel? updated;
    state = state.map((m) {
      if (m.id != id) return m;
      updated = m.copyWith(
          currentQty: (m.currentQty - qty).clamp(0, double.infinity));
      return updated!;
    }).toList();
    if (updated != null) _sync(updated!);
  }

  void addStock(String id, double qty) {
    MedicineStockModel? updated;
    state = state.map((m) {
      if (m.id != id) return m;
      updated = m.copyWith(currentQty: m.currentQty + qty);
      return updated!;
    }).toList();
    if (updated != null) _sync(updated!);
  }

  void deleteItem(String id) {
    state = state.where((m) => m.id != id).toList();
    _delete(id);
  }

  void clearAll() => state = [];

  List<MedicineStockModel> get lowStockItems =>
      state.where((m) => m.isLowStock).toList();

  List<MedicineStockModel> get expiringItems =>
      state.where((m) => m.isExpiringSoon && !m.isExpired).toList();

  List<MedicineStockModel> get expiredItems =>
      state.where((m) => m.isExpired).toList();

  int get alertCount =>
      lowStockItems.length + expiringItems.length + expiredItems.length;

  Future<void> reload() => _load();
}
