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

  Map<String, dynamic> toJson() => {
    'id': id,
    'farmId': farmId,
    'type': type.name,
    'flockId': flockId,
    'flockName': flockName,
    'productName': productName,
    'dosage': dosage,
    'quantityUsed': quantityUsed,
    'medicineStockId': medicineStockId,
    'notes': notes,
    'date': date.toIso8601String(),
    'nextDueDate': nextDueDate?.toIso8601String(),
    'administeredBy': administeredBy,
    'createdAt': createdAt.toIso8601String(),
  };

  factory HealthRecordModel.fromJson(Map<String, dynamic> j) => HealthRecordModel(
    id: j['id'] as String,
    farmId: j['farmId'] as String,
    type: HealthRecordType.values.firstWhere((e) => e.name == j['type'],
        orElse: () => HealthRecordType.observation),
    flockId: j['flockId'] as String?,
    flockName: j['flockName'] as String?,
    productName: j['productName'] as String,
    dosage: j['dosage'] as String?,
    quantityUsed: (j['quantityUsed'] as num?)?.toDouble(),
    medicineStockId: j['medicineStockId'] as String?,
    notes: j['notes'] as String?,
    date: DateTime.parse(j['date'] as String),
    nextDueDate: j['nextDueDate'] != null ? DateTime.parse(j['nextDueDate'] as String) : null,
    administeredBy: j['administeredBy'] as String?,
    createdAt: DateTime.parse(j['createdAt'] as String),
  );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'farmId': farmId,
    'flockId': flockId,
    'flockName': flockName,
    'vaccineName': vaccineName,
    'dueDate': dueDate.toIso8601String(),
    'isCompleted': isCompleted,
    'notes': notes,
  };

  factory VaccinationScheduleModel.fromJson(Map<String, dynamic> j) =>
      VaccinationScheduleModel(
        id: j['id'] as String,
        farmId: j['farmId'] as String,
        flockId: j['flockId'] as String?,
        flockName: j['flockName'] as String?,
        vaccineName: j['vaccineName'] as String,
        dueDate: DateTime.parse(j['dueDate'] as String),
        isCompleted: j['isCompleted'] as bool? ?? false,
        notes: j['notes'] as String?,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'farmId': farmId,
    'name': name,
    'stockType': stockType.name,
    'unit': unit,
    'currentQty': currentQty,
    'lowStockThreshold': lowStockThreshold,
    'expiryDate': expiryDate?.toIso8601String(),
    'pricePerUnit': pricePerUnit,
    'manufacturer': manufacturer,
    'createdAt': createdAt.toIso8601String(),
  };

  factory MedicineStockModel.fromJson(Map<String, dynamic> j) => MedicineStockModel(
    id: j['id'] as String,
    farmId: j['farmId'] as String,
    name: j['name'] as String,
    stockType: MedicineStockType.values.firstWhere((e) => e.name == j['stockType'],
        orElse: () => MedicineStockType.medicine),
    unit: j['unit'] as String?,
    currentQty: (j['currentQty'] as num).toDouble(),
    lowStockThreshold: (j['lowStockThreshold'] as num).toDouble(),
    expiryDate: j['expiryDate'] != null ? DateTime.parse(j['expiryDate'] as String) : null,
    pricePerUnit: (j['pricePerUnit'] as num?)?.toDouble(),
    manufacturer: j['manufacturer'] as String?,
    createdAt: DateTime.parse(j['createdAt'] as String),
  );
}
