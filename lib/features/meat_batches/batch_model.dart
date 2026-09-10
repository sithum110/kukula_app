enum BatchStatus {
  growing,
  sold,
  closed;

  String toJson() => name;
  static BatchStatus fromJson(String v) =>
      BatchStatus.values.firstWhere((e) => e.name == v, orElse: () => BatchStatus.growing);
}

class BatchModel {
  final String id;
  final String farmId;
  final String name;
  final String? breed;
  final DateTime arrivalDate;
  final int initialCount;
  final int currentCount;
  final String? supplier;
  final BatchStatus status;
  final DateTime createdAt;

  int get totalSold => initialCount - currentCount;

  const BatchModel({
    required this.id,
    required this.farmId,
    required this.name,
    this.breed,
    required this.arrivalDate,
    required this.initialCount,
    required this.currentCount,
    this.supplier,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'farmId': farmId,
        'name': name,
        'breed': breed,
        'arrivalDate': arrivalDate.toIso8601String(),
        'initialCount': initialCount,
        'currentCount': currentCount,
        'supplier': supplier,
        'status': status.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory BatchModel.fromJson(Map<String, dynamic> json) => BatchModel(
        id: json['id'] as String,
        farmId: json['farmId'] as String,
        name: json['name'] as String,
        breed: json['breed'] as String?,
        arrivalDate: DateTime.parse(json['arrivalDate'] as String),
        initialCount: json['initialCount'] as int,
        currentCount: json['currentCount'] as int,
        supplier: json['supplier'] as String?,
        status: BatchStatus.fromJson(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

// ── Broiler Sale Type ──────────────────────────────────────────────────────
enum BroilerSaleType {
  liveBird,    // sell alive birds by live weight (kg)
  dressedMeat; // sell dressed/processed birds by count

  String get label {
    switch (this) {
      case BroilerSaleType.liveBird: return 'Live Bird Sale';
      case BroilerSaleType.dressedMeat: return 'Dressed Meat Sale';
    }
  }

  String get emoji {
    switch (this) {
      case BroilerSaleType.liveBird: return '🐔';
      case BroilerSaleType.dressedMeat: return '🥩';
    }
  }

  String get description {
    switch (this) {
      case BroilerSaleType.liveBird: return 'Sell birds alive by live weight (kg × price/kg)';
      case BroilerSaleType.dressedMeat: return 'Sell slaughtered/dressed birds by count';
    }
  }

  String toJson() => name;
  static BroilerSaleType fromJson(String v) =>
      BroilerSaleType.values.firstWhere((e) => e.name == v,
          orElse: () => BroilerSaleType.dressedMeat);
}

class MeatSaleModel {
  final String id;
  final String batchId;
  final String farmId;
  final BroilerSaleType saleType;  // NEW: live bird or dressed meat

  // For both types
  final int quantityBirds;         // number of birds sold
  final String? buyerName;
  final String? notes;
  final DateTime date;
  final double totalAmount;        // LKR

  // Live Bird Sale fields
  final double? liveWeightKg;      // total live weight sold (kg)
  final double? pricePerKg;        // LKR per kg live weight

  // Dressed Meat Sale fields
  final double? pricePerBird;      // LKR per dressed bird

  // Convenience getters
  double get effectivePricePerBird =>
      pricePerBird ?? (liveWeightKg != null && quantityBirds > 0
          ? totalAmount / quantityBirds
          : 0);

  double get avgWeightPerBird =>
      (liveWeightKg != null && quantityBirds > 0)
          ? liveWeightKg! / quantityBirds
          : 0;

  const MeatSaleModel({
    required this.id,
    required this.batchId,
    required this.farmId,
    this.saleType = BroilerSaleType.dressedMeat,
    required this.quantityBirds,
    this.pricePerBird,
    required this.totalAmount,
    this.liveWeightKg,
    this.pricePerKg,
    this.buyerName,
    this.notes,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'batchId': batchId,
        'farmId': farmId,
        'saleType': saleType.toJson(),
        'quantityBirds': quantityBirds,
        'pricePerBird': pricePerBird,
        'totalAmount': totalAmount,
        'liveWeightKg': liveWeightKg,
        'pricePerKg': pricePerKg,
        'buyerName': buyerName,
        'notes': notes,
        'date': date.toIso8601String(),
      };

  factory MeatSaleModel.fromJson(Map<String, dynamic> json) => MeatSaleModel(
        id: json['id'] as String,
        batchId: json['batchId'] as String,
        farmId: json['farmId'] as String,
        saleType: BroilerSaleType.fromJson(
            json['saleType'] as String? ?? 'dressedMeat'),
        quantityBirds: json['quantityBirds'] as int,
        pricePerBird: (json['pricePerBird'] as num?)?.toDouble(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        liveWeightKg: (json['liveWeightKg'] as num?)?.toDouble(),
        pricePerKg: (json['pricePerKg'] as num?)?.toDouble(),
        buyerName: json['buyerName'] as String?,
        notes: json['notes'] as String?,
        date: DateTime.parse(json['date'] as String),
      );
}
