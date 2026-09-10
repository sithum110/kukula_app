import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/features/health/health_model.dart';

const _uuid = Uuid();

// ── Health Records Provider ────────────────────────────────────────────────
final healthRecordListProvider =
    StateNotifierProvider<HealthRecordNotifier, List<HealthRecordModel>>((ref) {
  return HealthRecordNotifier();
});

class HealthRecordNotifier extends StateNotifier<List<HealthRecordModel>> {
  HealthRecordNotifier() : super(_sampleRecords());

  void addRecord(HealthRecordModel record) => state = [record, ...state];
  void deleteRecord(String id) =>
      state = state.where((r) => r.id != id).toList();

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
}

// ── Vaccination Schedule Provider ─────────────────────────────────────────
final vaccinationScheduleProvider =
    StateNotifierProvider<VaccinationScheduleNotifier, List<VaccinationScheduleModel>>(
        (ref) => VaccinationScheduleNotifier());

class VaccinationScheduleNotifier
    extends StateNotifier<List<VaccinationScheduleModel>> {
  VaccinationScheduleNotifier() : super(_sampleSchedule());

  void addSchedule(VaccinationScheduleModel s) => state = [...state, s];

  void markComplete(String id) {
    state = state
        .map((s) => s.id == id ? s.copyWith(isCompleted: true) : s)
        .toList();
  }

  void deleteSchedule(String id) =>
      state = state.where((s) => s.id != id).toList();

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
}

// ── Medicine Stock Provider ────────────────────────────────────────────────
final medicineStockProvider =
    StateNotifierProvider<MedicineStockNotifier, List<MedicineStockModel>>(
        (ref) => MedicineStockNotifier());

class MedicineStockNotifier extends StateNotifier<List<MedicineStockModel>> {
  MedicineStockNotifier() : super(_sampleMedicineStock());

  void addItem(MedicineStockModel item) => state = [...state, item];

  void deductStock(String id, double qty) {
    state = state.map((m) {
      if (m.id != id) return m;
      return m.copyWith(
          currentQty: (m.currentQty - qty).clamp(0, double.infinity));
    }).toList();
  }

  void addStock(String id, double qty) {
    state = state.map((m) {
      if (m.id != id) return m;
      return m.copyWith(currentQty: m.currentQty + qty);
    }).toList();
  }

  void deleteItem(String id) =>
      state = state.where((m) => m.id != id).toList();

  List<MedicineStockModel> get lowStockItems =>
      state.where((m) => m.isLowStock).toList();

  List<MedicineStockModel> get expiringItems =>
      state.where((m) => m.isExpiringSoon && !m.isExpired).toList();

  List<MedicineStockModel> get expiredItems =>
      state.where((m) => m.isExpired).toList();

  int get alertCount =>
      lowStockItems.length + expiringItems.length + expiredItems.length;
}

// ── Sample Data ────────────────────────────────────────────────────────────
List<HealthRecordModel> _sampleRecords() {
  final now = DateTime.now();
  return [
    HealthRecordModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: HealthRecordType.vaccination,
      flockName: 'Flock A — Layers',
      productName: 'Newcastle Disease (ND) Vaccine',
      dosage: '0.5ml / bird', quantityUsed: 225.0,
      notes: 'Eye-drop method. All birds treated.',
      date: now.subtract(const Duration(days: 2)),
      nextDueDate: now.add(const Duration(days: 28)),
      administeredBy: 'Dr. Perera',
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    HealthRecordModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: HealthRecordType.medication,
      flockName: 'Batch Jan 2026',
      productName: 'Amoxicillin 500mg',
      dosage: '1g / litre of water',
      quantityUsed: 10.0,
      notes: 'Respiratory infection. 5-day course.',
      date: now.subtract(const Duration(days: 1)),
      nextDueDate: now.add(const Duration(days: 4)),
      administeredBy: 'Nimal',
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    HealthRecordModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: HealthRecordType.observation,
      flockName: 'Flock B — Layers',
      productName: 'Routine check',
      notes: 'Minor feather pecking observed in Pen 2. Reduced density.',
      date: now,
      administeredBy: 'Kamal',
      createdAt: now,
    ),
    HealthRecordModel(
      id: _uuid.v4(), farmId: 'farm1',
      type: HealthRecordType.treatment,
      flockName: 'Batch Feb 2026',
      productName: 'Vitamin E + Selenium',
      dosage: '1ml / litre', quantityUsed: 5.0,
      notes: 'Stress supplement after transport.',
      date: now.subtract(const Duration(days: 5)),
      administeredBy: 'Nimal',
      createdAt: now.subtract(const Duration(days: 5)),
    ),
  ];
}

List<VaccinationScheduleModel> _sampleSchedule() {
  final now = DateTime.now();
  return [
    VaccinationScheduleModel(
      id: _uuid.v4(), farmId: 'farm1',
      flockName: 'Flock A — Layers',
      vaccineName: 'Newcastle Disease (Booster)',
      dueDate: now.add(const Duration(days: 26)),
      notes: 'Due at week 24',
    ),
    VaccinationScheduleModel(
      id: _uuid.v4(), farmId: 'farm1',
      flockName: 'Batch Jan 2026',
      vaccineName: 'Gumboro (IBD)',
      dueDate: now.add(const Duration(days: 3)),
      notes: 'Day 21 vaccination',
    ),
    VaccinationScheduleModel(
      id: _uuid.v4(), farmId: 'farm1',
      flockName: 'Flock B — Layers',
      vaccineName: 'Infectious Bronchitis (IB)',
      dueDate: now.subtract(const Duration(days: 2)),
      notes: 'OVERDUE — administer ASAP',
    ),
    VaccinationScheduleModel(
      id: _uuid.v4(), farmId: 'farm1',
      flockName: 'All Flocks',
      vaccineName: 'Marek\'s Disease',
      dueDate: now.add(const Duration(days: 45)),
      isCompleted: true,
    ),
  ];
}

List<MedicineStockModel> _sampleMedicineStock() {
  final now = DateTime.now();
  return [
    MedicineStockModel(
      id: 'ms1', farmId: 'farm1',
      name: 'Amoxicillin 500mg',
      stockType: MedicineStockType.medicine,
      unit: 'tablets', currentQty: 45,
      lowStockThreshold: 50,
      expiryDate: now.add(const Duration(days: 7)),
      pricePerUnit: 15.0,
      manufacturer: 'GSK Lanka',
      createdAt: now.subtract(const Duration(days: 30)),
    ),
    MedicineStockModel(
      id: 'ms2', farmId: 'farm1',
      name: 'Newcastle Disease Vaccine',
      stockType: MedicineStockType.vaccine,
      unit: 'doses', currentQty: 500,
      lowStockThreshold: 200,
      expiryDate: now.add(const Duration(days: 60)),
      pricePerUnit: 8.0,
      manufacturer: 'Intervet',
      createdAt: now.subtract(const Duration(days: 20)),
    ),
    MedicineStockModel(
      id: 'ms3', farmId: 'farm1',
      name: 'Vitamin E + Selenium',
      stockType: MedicineStockType.medicine,
      unit: 'ml', currentQty: 250,
      lowStockThreshold: 100,
      expiryDate: now.add(const Duration(days: 180)),
      pricePerUnit: 2.5,
      createdAt: now.subtract(const Duration(days: 60)),
    ),
    MedicineStockModel(
      id: 'ms4', farmId: 'farm1',
      name: 'Gumboro (IBD) Vaccine',
      stockType: MedicineStockType.vaccine,
      unit: 'doses', currentQty: 300,
      lowStockThreshold: 150,
      expiryDate: now.add(const Duration(days: 90)),
      pricePerUnit: 12.0,
      manufacturer: 'MSD Animal Health',
      createdAt: now.subtract(const Duration(days: 10)),
    ),
    MedicineStockModel(
      id: 'ms5', farmId: 'farm1',
      name: 'Oxytetracycline',
      stockType: MedicineStockType.medicine,
      unit: 'g', currentQty: 30,
      lowStockThreshold: 50,
      expiryDate: now.subtract(const Duration(days: 5)), // expired!
      pricePerUnit: 45.0,
      createdAt: now.subtract(const Duration(days: 120)),
    ),
  ];
}
