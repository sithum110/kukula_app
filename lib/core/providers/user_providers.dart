import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/shared/models/user_model.dart';
import 'package:kukula_app/core/enums/user_role.dart';

const _uuid = Uuid();

// ── Current logged-in user & role ─────────────────────────────────────────
// In Phase 11 this will be replaced with Firebase Auth user
final currentUserProvider = StateProvider<UserModel>((ref) => UserModel(
      id: 'owner-1',
      farmId: 'farm1',
      name: 'Farm Owner',
      email: 'owner@kukula.app',
      role: UserRole.owner,
      joinedAt: DateTime.now().subtract(const Duration(days: 365)),
    ));

// Convenience: current role
final currentRoleProvider = Provider<UserRole>((ref) {
  return ref.watch(currentUserProvider).role;
});

// Convenience: is owner?
final isOwnerProvider = Provider<bool>((ref) {
  return ref.watch(currentRoleProvider) == UserRole.owner;
});

// ── Farm Users List ───────────────────────────────────────────────────────
final userListProvider =
    StateNotifierProvider<UserListNotifier, List<UserModel>>(
        (ref) => UserListNotifier());

class UserListNotifier extends StateNotifier<List<UserModel>> {
  UserListNotifier() : super(_sampleUsers());

  void addUser(UserModel user) => state = [...state, user];

  void removeUser(String id) =>
      state = state.where((u) => u.id != id).toList();

  void updateRole(String id, UserRole role) {
    state = state.map((u) => u.id == id ? _copyWithRole(u, role) : u).toList();
  }

  List<UserModel> get owners =>
      state.where((u) => u.role == UserRole.owner).toList();

  List<UserModel> get workers =>
      state.where((u) => u.role == UserRole.worker).toList();

  static UserModel _copyWithRole(UserModel u, UserRole role) => UserModel(
        id: u.id,
        farmId: u.farmId,
        name: u.name,
        email: u.email,
        role: role,
        joinedAt: u.joinedAt,
      );
}

// ── Sample Data ───────────────────────────────────────────────────────────
List<UserModel> _sampleUsers() => [
      UserModel(
        id: 'owner-1',
        farmId: 'farm1',
        name: 'Farm Owner',
        email: 'owner@kukula.app',
        role: UserRole.owner,
        joinedAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      UserModel(
        id: _uuid.v4(),
        farmId: 'farm1',
        name: 'Kamal Perera',
        email: 'kamal@kukula.app',
        role: UserRole.worker,
        joinedAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      UserModel(
        id: _uuid.v4(),
        farmId: 'farm1',
        name: 'Nimal Silva',
        email: 'nimal@kukula.app',
        role: UserRole.worker,
        joinedAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
    ];
