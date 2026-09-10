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
