import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/enums/user_role.dart';
import 'package:kukula_app/core/providers/user_providers.dart';

/// Wraps [child] and shows it only when the current user has permission.
/// If [fallback] is provided, shows that instead of hiding.
/// If [showLock] is true, shows a locked-out UI instead of nothing.
class RoleGuard extends ConsumerWidget {
  final Widget child;
  final Widget? fallback;
  final bool Function(UserRole) permission;
  final bool showLock;
  final String? lockMessage;

  const RoleGuard({
    super.key,
    required this.child,
    required this.permission,
    this.fallback,
    this.showLock = false,
    this.lockMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);
    if (permission(role)) return child;
    if (fallback != null) return fallback!;
    if (showLock) return _LockedWidget(message: lockMessage);
    return const SizedBox.shrink();
  }
}

/// A small locked-out placeholder widget
class _LockedWidget extends StatelessWidget {
  final String? message;
  const _LockedWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 16, color: Colors.redAccent),
          const SizedBox(width: 8),
          Text(
            message ?? 'Owner access required',
            style: const TextStyle(
                fontSize: 13, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

/// A button wrapper that disables the button when user lacks permission
class RoleGuardedButton extends ConsumerWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool Function(UserRole) permission;
  final String? disabledTooltip;

  const RoleGuardedButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.permission,
    this.disabledTooltip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);
    final allowed = permission(role);

    return Tooltip(
      message: allowed ? '' : (disabledTooltip ?? 'Owner access required'),
      child: AbsorbPointer(
        absorbing: !allowed,
        child: Opacity(
          opacity: allowed ? 1.0 : 0.4,
          child: GestureDetector(
            onTap: allowed ? onPressed : null,
            child: child,
          ),
        ),
      ),
    );
  }
}
