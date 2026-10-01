// ── Livestock Purchase Model ──────────────────────────────────────────────────

enum LivestockBirdType {
  broilerChicken,
  layerChicken,
  turkey,
  duck,
  quail,
  other;

  String get label {
    switch (this) {
      case LivestockBirdType.broilerChicken: return 'Broiler Chicken';
      case LivestockBirdType.layerChicken:   return 'Layer Chicken';
      case LivestockBirdType.turkey:         return 'Turkey';
      case LivestockBirdType.duck:           return 'Duck';
      case LivestockBirdType.quail:          return 'Quail';
      case LivestockBirdType.other:          return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case LivestockBirdType.broilerChicken: return '🐔';
      case LivestockBirdType.layerChicken:   return '🐓';
      case LivestockBirdType.turkey:         return '🦃';
      case LivestockBirdType.duck:           return '🦆';
      case LivestockBirdType.quail:          return '🐦';
      case LivestockBirdType.other:          return '🐾';
    }
  }

  String toJson() => name;
  static LivestockBirdType fromJson(String v) =>
      LivestockBirdType.values.firstWhere((e) => e.name == v,
          orElse: () => LivestockBirdType.broilerChicken);
}

class LivestockPurchaseModel {
  final String id;
  final String farmId;
  final String supplierName;
  final String? supplierPhone;
  final LivestockBirdType birdType;
  final String? breed;
  final int quantity;
  final double totalLiveWeightKg;
  final double pricePerKg;
  final double totalCostLKR;
  final String? notes;
  final DateTime purchaseDate;
  final DateTime createdAt;

  double get avgWeightPerBirdKg =>
      quantity > 0 ? totalLiveWeightKg / quantity : 0;

  const LivestockPurchaseModel({
    required this.id,
    required this.farmId,
    required this.supplierName,
    this.supplierPhone,
    required this.birdType,
    this.breed,
    required this.quantity,
    required this.totalLiveWeightKg,
    required this.pricePerKg,
    required this.totalCostLKR,
    this.notes,
    required this.purchaseDate,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'farmId': farmId,
    'supplierName': supplierName,
    'supplierPhone': supplierPhone,
    'birdType': birdType.toJson(),
    'breed': breed,
    'quantity': quantity,
    'totalLiveWeightKg': totalLiveWeightKg,
    'pricePerKg': pricePerKg,
    'totalCostLKR': totalCostLKR,
    'notes': notes,
    'purchaseDate': purchaseDate.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory LivestockPurchaseModel.fromJson(Map<String, dynamic> j) =>
      LivestockPurchaseModel(
        id: j['id'] as String,
        farmId: j['farmId'] as String,
        supplierName: j['supplierName'] as String,
        supplierPhone: j['supplierPhone'] as String?,
        birdType: LivestockBirdType.fromJson(
            j['birdType'] as String? ?? 'broilerChicken'),
        breed: j['breed'] as String?,
        quantity: j['quantity'] as int,
        totalLiveWeightKg: (j['totalLiveWeightKg'] as num).toDouble(),
        pricePerKg: (j['pricePerKg'] as num).toDouble(),
        totalCostLKR: (j['totalCostLKR'] as num).toDouble(),
        notes: j['notes'] as String?,
        purchaseDate: DateTime.parse(j['purchaseDate'] as String),
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}
