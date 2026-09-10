enum HealthRecordType {
  vaccination,
  medication,
  treatment,
  observation;

  String get label {
    switch (this) {
      case HealthRecordType.vaccination: return 'Vaccination';
      case HealthRecordType.medication: return 'Medication';
      case HealthRecordType.treatment: return 'Treatment';
      case HealthRecordType.observation: return 'Observation';
    }
  }

  String get emoji {
    switch (this) {
      case HealthRecordType.vaccination: return '💉';
      case HealthRecordType.medication: return '💊';
      case HealthRecordType.treatment: return '🩺';
      case HealthRecordType.observation: return '📋';
    }
  }
}

enum MedicineStockType { medicine, vaccine }

/// A single health event record
class HealthRecordModel {
  final String id;
  final String farmId;
  final HealthRecordType type;
  final String? flockId;
  final String? flockName;   // denormalized
  final String productName;  // vaccine name / medicine name / treatment label
  final String? dosage;
  final double? quantityUsed; // ml / tablets / doses
  final String? medicineStockId; // link to deduct stock
  final String? notes;
  final DateTime date;
  final DateTime? nextDueDate;
  final String? administeredBy;
  final DateTime createdAt;

  const HealthRecordModel({
    required this.id,
    required this.farmId,
    required this.type,
    this.flockId,
    this.flockName,
    required this.productName,
    this.dosage,
    this.quantityUsed,
    this.medicineStockId,
    this.notes,
    required this.date,
    this.nextDueDate,
    this.administeredBy,
    required this.createdAt,
  });
}

/// Upcoming vaccination schedule entry
class VaccinationScheduleModel {
  final String id;
  final String farmId;
  final String? flockId;
  final String? flockName;
  final String vaccineName;
  final DateTime dueDate;
  final bool isCompleted;
  final String? notes;

  bool get isOverdue =>
      !isCompleted && dueDate.isBefore(DateTime.now());

  int get daysUntilDue =>
      dueDate.difference(DateTime.now()).inDays;

  const VaccinationScheduleModel({
    required this.id,
    required this.farmId,
    this.flockId,
    this.flockName,
    required this.vaccineName,
    required this.dueDate,
    this.isCompleted = false,
    this.notes,
  });

  VaccinationScheduleModel copyWith({bool? isCompleted}) =>
      VaccinationScheduleModel(
        id: id, farmId: farmId,
        flockId: flockId, flockName: flockName,
        vaccineName: vaccineName, dueDate: dueDate,
        isCompleted: isCompleted ?? this.isCompleted,
        notes: notes,
      );
}

/// Medicine / vaccine stock item
class MedicineStockModel {
  final String id;
  final String farmId;
  final String name;
  final MedicineStockType stockType;
  final String? unit;          // ml, tablets, doses, vials
  final double currentQty;
  final double lowStockThreshold;
  final DateTime? expiryDate;
  final double? pricePerUnit;
  final String? manufacturer;
  final DateTime createdAt;

  bool get isLowStock => currentQty <= lowStockThreshold;

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    return expiryDate!.difference(DateTime.now()).inDays <= 30;
  }

  bool get isExpired {
    if (expiryDate == null) return false;
    return expiryDate!.isBefore(DateTime.now());
  }

  const MedicineStockModel({
    required this.id,
    required this.farmId,
    required this.name,
    required this.stockType,
    this.unit,
    required this.currentQty,
    required this.lowStockThreshold,
    this.expiryDate,
    this.pricePerUnit,
    this.manufacturer,
    required this.createdAt,
  });

  MedicineStockModel copyWith({double? currentQty}) => MedicineStockModel(
    id: id, farmId: farmId, name: name, stockType: stockType,
    unit: unit, currentQty: currentQty ?? this.currentQty,
    lowStockThreshold: lowStockThreshold, expiryDate: expiryDate,
    pricePerUnit: pricePerUnit, manufacturer: manufacturer,
    createdAt: createdAt,
  );
}
