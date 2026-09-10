enum FlockPurpose {
  layer,   // Egg production
  broiler; // Meat production

  String toJson() => name;
  static FlockPurpose fromJson(String v) =>
      FlockPurpose.values.firstWhere((e) => e.name == v, orElse: () => FlockPurpose.layer);
}

enum FlockStatus {
  active,
  closed;

  String toJson() => name;
  static FlockStatus fromJson(String v) =>
      FlockStatus.values.firstWhere((e) => e.name == v, orElse: () => FlockStatus.active);
}

enum BirdEventType {
  purchase,
  hatching,
  transferIn,
  mortality,
  culling,
  sale,
  transferOut;

  bool get isReduction => [mortality, culling, sale, transferOut].contains(this);
  bool get isAddition => [purchase, hatching, transferIn].contains(this);

  String toJson() => name;
  static BirdEventType fromJson(String v) =>
      BirdEventType.values.firstWhere((e) => e.name == v, orElse: () => BirdEventType.purchase);
}

class FlockModel {
  final String id;
  final String farmId;
  final String name;
  final String? breed;
  final FlockPurpose purpose;
  final int currentCount;
  final int initialCount;
  final String? pen;
  final DateTime arrivalDate;
  final FlockStatus status;
  final DateTime createdAt;

  const FlockModel({
    required this.id,
    required this.farmId,
    required this.name,
    this.breed,
    required this.purpose,
    required this.currentCount,
    required this.initialCount,
    this.pen,
    required this.arrivalDate,
    required this.status,
    required this.createdAt,
  });

  bool get isLayer => purpose == FlockPurpose.layer;
  bool get isBroiler => purpose == FlockPurpose.broiler;

  Map<String, dynamic> toJson() => {
        'id': id,
        'farmId': farmId,
        'name': name,
        'breed': breed,
        'purpose': purpose.toJson(),
        'currentCount': currentCount,
        'initialCount': initialCount,
        'pen': pen,
        'arrivalDate': arrivalDate.toIso8601String(),
        'status': status.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory FlockModel.fromJson(Map<String, dynamic> json) => FlockModel(
        id: json['id'] as String,
        farmId: json['farmId'] as String,
        name: json['name'] as String,
        breed: json['breed'] as String?,
        purpose: FlockPurpose.fromJson(json['purpose'] as String),
        currentCount: json['currentCount'] as int,
        initialCount: json['initialCount'] as int,
        pen: json['pen'] as String?,
        arrivalDate: DateTime.parse(json['arrivalDate'] as String),
        status: FlockStatus.fromJson(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class BirdEventModel {
  final String id;
  final String flockId;
  final BirdEventType type;
  final int count;
  final String? cause;
  final String? notes;
  final DateTime date;
  final String recordedBy;

  const BirdEventModel({
    required this.id,
    required this.flockId,
    required this.type,
    required this.count,
    this.cause,
    this.notes,
    required this.date,
    required this.recordedBy,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'flockId': flockId,
        'type': type.toJson(),
        'count': count,
        'cause': cause,
        'notes': notes,
        'date': date.toIso8601String(),
        'recordedBy': recordedBy,
      };

  factory BirdEventModel.fromJson(Map<String, dynamic> json) => BirdEventModel(
        id: json['id'] as String,
        flockId: json['flockId'] as String,
        type: BirdEventType.fromJson(json['type'] as String),
        count: json['count'] as int,
        cause: json['cause'] as String?,
        notes: json['notes'] as String?,
        date: DateTime.parse(json['date'] as String),
        recordedBy: json['recordedBy'] as String,
      );
}
