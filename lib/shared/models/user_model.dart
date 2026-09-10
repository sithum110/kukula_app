import 'package:kukula_app/core/enums/user_role.dart';

class UserModel {
  final String id;
  final String farmId;
  final String name;
  final String email;
  final UserRole role;
  final DateTime joinedAt;

  const UserModel({
    required this.id,
    required this.farmId,
    required this.name,
    required this.email,
    required this.role,
    required this.joinedAt,
  });

  bool get isOwner => role == UserRole.owner;
  bool get isWorker => role == UserRole.worker;

  Map<String, dynamic> toJson() => {
        'id': id,
        'farmId': farmId,
        'name': name,
        'email': email,
        'role': role.toJson(),
        'joinedAt': joinedAt.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        farmId: json['farmId'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        role: UserRole.fromJson(json['role'] as String),
        joinedAt: DateTime.parse(json['joinedAt'] as String),
      );
}
