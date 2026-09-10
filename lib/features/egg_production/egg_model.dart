enum EggDispositionType {
  sale,
  personalUse,
  hatching,
  wastage;

  String toJson() => name;
  static EggDispositionType fromJson(String v) =>
      EggDispositionType.values.firstWhere((e) => e.name == v, orElse: () => EggDispositionType.sale);
}

class EggRecordModel {
  final String id;
  final String farmId;
  final String? flockId; // null = farm-wide entry
  final DateTime date;
  final int totalEggs;
  final int brokenEggs;
  final int? gradeA;
  final int? gradeB;
  final int? gradeC;
  final String collectedBy;
  final DateTime createdAt;

  int get goodEggs => totalEggs - brokenEggs;
  int get traysCount => goodEggs ~/ 30;

  const EggRecordModel({
    required this.id,
    required this.farmId,
    this.flockId,
    required this.date,
    required this.totalEggs,
    required this.brokenEggs,
    this.gradeA,
    this.gradeB,
    this.gradeC,
    required this.collectedBy,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'farmId': farmId,
        'flockId': flockId,
        'date': date.toIso8601String(),
        'totalEggs': totalEggs,
        'brokenEggs': brokenEggs,
        'gradeA': gradeA,
        'gradeB': gradeB,
        'gradeC': gradeC,
        'collectedBy': collectedBy,
        'createdAt': createdAt.toIso8601String(),
      };

  factory EggRecordModel.fromJson(Map<String, dynamic> json) => EggRecordModel(
        id: json['id'] as String,
        farmId: json['farmId'] as String,
        flockId: json['flockId'] as String?,
        date: DateTime.parse(json['date'] as String),
        totalEggs: json['totalEggs'] as int,
        brokenEggs: json['brokenEggs'] as int,
        gradeA: json['gradeA'] as int?,
        gradeB: json['gradeB'] as int?,
        gradeC: json['gradeC'] as int?,
        collectedBy: json['collectedBy'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class EggSaleModel {
  final String id;
  final String farmId;
  final EggDispositionType saleType;
  final int quantity; // individual eggs
  final double? pricePerUnit; // LKR, null for non-sale types
  final double? totalAmount;  // LKR
  final String? buyerName;
  final String? notes;
  final DateTime date;

  int get traysCount => quantity ~/ 30;

  const EggSaleModel({
    required this.id,
    required this.farmId,
    required this.saleType,
    required this.quantity,
    this.pricePerUnit,
    this.totalAmount,
    this.buyerName,
    this.notes,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'farmId': farmId,
        'saleType': saleType.toJson(),
        'quantity': quantity,
        'pricePerUnit': pricePerUnit,
        'totalAmount': totalAmount,
        'buyerName': buyerName,
        'notes': notes,
        'date': date.toIso8601String(),
      };

  factory EggSaleModel.fromJson(Map<String, dynamic> json) => EggSaleModel(
        id: json['id'] as String,
        farmId: json['farmId'] as String,
        saleType: EggDispositionType.fromJson(json['saleType'] as String),
        quantity: json['quantity'] as int,
        pricePerUnit: (json['pricePerUnit'] as num?)?.toDouble(),
        totalAmount: (json['totalAmount'] as num?)?.toDouble(),
        buyerName: json['buyerName'] as String?,
        notes: json['notes'] as String?,
        date: DateTime.parse(json['date'] as String),
      );
}

class EggStockModel {
  final String id;
  final String farmId;
  int quantity; // eggs on hand
  DateTime lastUpdated;

  EggStockModel({
    required this.id,
    required this.farmId,
    required this.quantity,
    required this.lastUpdated,
  });

  int get traysCount => quantity ~/ 30;
}
