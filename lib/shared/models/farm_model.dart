import 'package:kukula_app/core/enums/farm_type.dart';

class FarmModel {
  final String id;
  final String name;
  final String ownerId;
  final FarmType farmType;
  final String? location;
  final String language; // 'en' | 'si'
  final bool isPremium;
  final DateTime createdAt;

  const FarmModel({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.farmType,
    this.location,
    required this.language,
    required this.isPremium,
    required this.createdAt,
  });

  FarmModel copyWith({
    String? id,
    String? name,
    String? ownerId,
    FarmType? farmType,
    String? location,
    String? language,
    bool? isPremium,
    DateTime? createdAt,
  }) {
    return FarmModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      farmType: farmType ?? this.farmType,
      location: location ?? this.location,
      language: language ?? this.language,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'ownerId': ownerId,
        'farmType': farmType.toJson(),
        'location': location,
        'language': language,
        'isPremium': isPremium,
        'createdAt': createdAt.toIso8601String(),
      };

  factory FarmModel.fromJson(Map<String, dynamic> json) => FarmModel(
        id: json['id'] as String,
        name: json['name'] as String,
        ownerId: json['ownerId'] as String,
        farmType: FarmType.fromJson(json['farmType'] as String),
        location: json['location'] as String?,
        language: json['language'] as String? ?? 'en',
        isPremium: json['isPremium'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
