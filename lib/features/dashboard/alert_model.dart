enum AlertType {
  lowFeedStock,
  lowMedicineStock,
  lowVaccineStock,
  lowEggStock,
  vaccinationDue,
  medicineExpiringSoon;

  String get icon {
    switch (this) {
      case lowFeedStock: return '🌾';
      case lowMedicineStock: return '💊';
      case lowVaccineStock: return '💉';
      case lowEggStock: return '🥚';
      case vaccinationDue: return '📅';
      case medicineExpiringSoon: return '⚠️';
    }
  }

  String toJson() => name;
  static AlertType fromJson(String v) =>
      AlertType.values.firstWhere((e) => e.name == v, orElse: () => AlertType.lowFeedStock);
}

class AlertModel {
  final String id;
  final String farmId;
  final AlertType type;
  final String message;
  final bool isRead;
  final String? linkedId;   // stockId, flockId, etc.
  final DateTime createdAt;

  const AlertModel({
    required this.id,
    required this.farmId,
    required this.type,
    required this.message,
    required this.isRead,
    this.linkedId,
    required this.createdAt,
  });

  AlertModel copyWith({bool? isRead}) => AlertModel(
        id: id,
        farmId: farmId,
        type: type,
        message: message,
        isRead: isRead ?? this.isRead,
        linkedId: linkedId,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'farmId': farmId,
        'type': type.toJson(),
        'message': message,
        'isRead': isRead,
        'linkedId': linkedId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
        id: json['id'] as String,
        farmId: json['farmId'] as String,
        type: AlertType.fromJson(json['type'] as String),
        message: json['message'] as String,
        isRead: json['isRead'] as bool? ?? false,
        linkedId: json['linkedId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
