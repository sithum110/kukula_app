enum FeedUnit { kg, g, bag }

extension FeedUnitExt on FeedUnit {
  String get label {
    switch (this) {
      case FeedUnit.kg: return 'kg';
      case FeedUnit.g: return 'g';
      case FeedUnit.bag: return 'bag';
    }
  }

  String toJson() => name;
  static FeedUnit fromJson(String v) =>
      FeedUnit.values.firstWhere((e) => e.name == v, orElse: () => FeedUnit.kg);
}

/// Feed type / brand managed by the farmer
class FeedTypeModel {
  final String id;
  final String farmId;
  final String name;         // e.g. "Layer Pellets"
  final String? brand;       // e.g. "CIC Feeds"
  final String? forPurpose;  // 'layer' | 'broiler' | 'all'
  final double currentStockKg;
  final double lowStockThresholdKg;
  final double? pricePerKg;
  final DateTime createdAt;

  bool get isLowStock => currentStockKg <= lowStockThresholdKg;

  const FeedTypeModel({
    required this.id,
    required this.farmId,
    required this.name,
    this.brand,
    this.forPurpose,
    required this.currentStockKg,
    required this.lowStockThresholdKg,
    this.pricePerKg,
    required this.createdAt,
  });

  FeedTypeModel copyWith({
    double? currentStockKg,
    double? lowStockThresholdKg,
    double? pricePerKg,
    String? name,
    String? brand,
  }) =>
      FeedTypeModel(
        id: id,
        farmId: farmId,
        name: name ?? this.name,
        brand: brand ?? this.brand,
        forPurpose: forPurpose,
        currentStockKg: currentStockKg ?? this.currentStockKg,
        lowStockThresholdKg: lowStockThresholdKg ?? this.lowStockThresholdKg,
        pricePerKg: pricePerKg ?? this.pricePerKg,
        createdAt: createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedTypeModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => {
    'id': id,
    'farmId': farmId,
    'name': name,
    'brand': brand,
    'forPurpose': forPurpose,
    'currentStockKg': currentStockKg,
    'lowStockThresholdKg': lowStockThresholdKg,
    'pricePerKg': pricePerKg,
    'createdAt': createdAt.toIso8601String(),
  };

  factory FeedTypeModel.fromJson(Map<String, dynamic> j) => FeedTypeModel(
    id: j['id'] as String,
    farmId: j['farmId'] as String,
    name: j['name'] as String,
    brand: j['brand'] as String?,
    forPurpose: j['forPurpose'] as String?,
    currentStockKg: (j['currentStockKg'] as num).toDouble(),
    lowStockThresholdKg: (j['lowStockThresholdKg'] as num).toDouble(),
    pricePerKg: (j['pricePerKg'] as num?)?.toDouble(),
    createdAt: DateTime.parse(j['createdAt'] as String),
  );
}


/// One feeding log entry
class FeedLogModel {
  final String id;
  final String farmId;
  final String feedTypeId;
  final String feedTypeName; // denormalized for display
  final String? flockId;
  final String? flockName;
  final double quantityKg;
  final double? costLKR;     // auto-calculated if pricePerKg known
  final String? notes;
  final DateTime date;
  final DateTime createdAt;

  const FeedLogModel({
    required this.id,
    required this.farmId,
    required this.feedTypeId,
    required this.feedTypeName,
    this.flockId,
    this.flockName,
    required this.quantityKg,
    this.costLKR,
    this.notes,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'farmId': farmId,
    'feedTypeId': feedTypeId,
    'feedTypeName': feedTypeName,
    'flockId': flockId,
    'flockName': flockName,
    'quantityKg': quantityKg,
    'costLKR': costLKR,
    'notes': notes,
    'date': date.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory FeedLogModel.fromJson(Map<String, dynamic> j) => FeedLogModel(
    id: j['id'] as String,
    farmId: j['farmId'] as String,
    feedTypeId: j['feedTypeId'] as String,
    feedTypeName: j['feedTypeName'] as String,
    flockId: j['flockId'] as String?,
    flockName: j['flockName'] as String?,
    quantityKg: (j['quantityKg'] as num).toDouble(),
    costLKR: (j['costLKR'] as num?)?.toDouble(),
    notes: j['notes'] as String?,
    date: DateTime.parse(j['date'] as String),
    createdAt: DateTime.parse(j['createdAt'] as String),
  );
}

/// Stock purchase / restock entry
class FeedStockPurchaseModel {
  final String id;
  final String feedTypeId;
  final double quantityKg;
  final double? pricePerKg;
  final double? totalCostLKR;
  final String? supplier;
  final DateTime date;

  const FeedStockPurchaseModel({
    required this.id,
    required this.feedTypeId,
    required this.quantityKg,
    this.pricePerKg,
    this.totalCostLKR,
    this.supplier,
    required this.date,
  });
}
