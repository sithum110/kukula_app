import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/providers/farm_providers.dart';
import 'package:kukula_app/core/providers/user_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/core/enums/user_role.dart';
import 'package:kukula_app/shared/models/user_model.dart';

// ── User List Screen ───────────────────────────────────────────────────────
class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userListProvider);
    final currentUser = ref.watch(currentUserProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final isOwner = ref.watch(isOwnerProvider);

    final owners = users.where((u) => u.role == UserRole.owner).toList();
    final workers = users.where((u) => u.role == UserRole.worker).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team & Workers'),
        actions: [
          if (isOwner)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: isPremium
                    ? () => _showInviteSheet(context, ref)
                    : () => _showPremiumGate(context),
                icon: const Icon(Icons.person_add_outlined, size: 18),
                label: const Text('Invite'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // ── Role Banner ────────────────────────────────────────────
          _RoleBanner(currentUser: currentUser),
          const SizedBox(height: 20),

          // ── Premium Invite Banner ──────────────────────────────────
          if (!isPremium && isOwner) ...[
            _PremiumInviteBanner(
              onUpgrade: () => _showPremiumGate(context),
            ),
            const SizedBox(height: 20),
          ],

          // ── Owners ────────────────────────────────────────────────
          _SectionHeader(
            title: 'Owners',
            count: owners.length,
            color: AppColors.premiumGold,
          ),
          const SizedBox(height: 10),
          ...owners.map((u) => _UserCard(
                user: u,
                isCurrentUser: u.id == currentUser.id,
                isOwner: isOwner,
                onRemove: null, // Can't remove owners from here
                onToggleRole: null,
              )),

          const SizedBox(height: 20),

          // ── Workers ───────────────────────────────────────────────
          _SectionHeader(
            title: 'Workers',
            count: workers.length,
            color: AppColors.info,
          ),
          const SizedBox(height: 10),

          if (workers.isEmpty)
            _EmptyWorkers(
              isPremium: isPremium,
              onInvite: () => isPremium
                  ? _showInviteSheet(context, ref)
                  : _showPremiumGate(context),
            )
          else
            ...workers.map((u) => _UserCard(
                  user: u,
                  isCurrentUser: u.id == currentUser.id,
                  isOwner: isOwner,
                  onRemove: isOwner
                      ? () => _confirmRemove(context, ref, u)
                      : null,
                  onToggleRole: isOwner
                      ? () => _confirmPromote(context, ref, u)
                      : null,
                )),

          if (workers.isNotEmpty) ...[
            const SizedBox(height: 20),
            _WorkerPermissionsCard(),
          ],
        ],
      ),

      // ── FAB — Invite Worker ──────────────────────────────────────
      floatingActionButton: isOwner
          ? FloatingActionButton.extended(
              onPressed: isPremium
                  ? () => _showInviteSheet(context, ref)
                  : () => _showPremiumGate(context),
              backgroundColor:
                  isPremium ? AppColors.primary : AppColors.premiumGold,
              icon: Text(
                  isPremium ? '👤' : '👑',
                  style: const TextStyle(fontSize: 18)),
              label: Text(
                isPremium ? 'Invite Worker' : 'Upgrade to Invite',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            )
          : null,
    );
  }

  void _showInviteSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const InviteWorkerSheet(),
    );
  }

  void _showPremiumGate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PremiumGateSheet(),
    );
  }

  Future<void> _confirmRemove(
      BuildContext context, WidgetRef ref, UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Remove Worker',
            style: TextStyle(color: AppColors.textPrimaryDark)),
        content: Text(
          'Remove ${user.name} from your farm? They will lose access immediately.',
          style: const TextStyle(color: AppColors.textSecondaryDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(userListProvider.notifier).removeUser(user.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${user.name} has been removed'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  Future<void> _confirmPromote(
      BuildContext context, WidgetRef ref, UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Promote to Owner',
            style: TextStyle(color: AppColors.textPrimaryDark)),
        content: Text(
          'Give ${user.name} owner access? They will be able to view finances, edit records, and manage other workers.',
          style: const TextStyle(color: AppColors.textSecondaryDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Promote'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(userListProvider.notifier).updateRole(user.id, UserRole.owner);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${user.name} is now an Owner'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }
}

// ── Role Banner ────────────────────────────────────────────────────────────
class _RoleBanner extends StatelessWidget {
  final UserModel currentUser;
  const _RoleBanner({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final isOwner = currentUser.isOwner;
    final color = isOwner ? AppColors.premiumGold : AppColors.info;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.18),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                isOwner ? '👑' : '👷',
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You are signed in as',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondaryDark),
                ),
                const SizedBox(height: 2),
                Text(
                  currentUser.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isOwner ? '👑 Owner — Full Access' : '👷 Worker — Data Entry Only',
                    style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  const _SectionHeader(
      {required this.title, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondaryDark,
                letterSpacing: 0.8)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('$count',
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

// ── User Card ──────────────────────────────────────────────────────────────
class _UserCard extends StatelessWidget {
  final UserModel user;
  final bool isCurrentUser;
  final bool isOwner;
  final VoidCallback? onRemove;
  final VoidCallback? onToggleRole;

  const _UserCard({
    required this.user,
    required this.isCurrentUser,
    required this.isOwner,
    this.onRemove,
    this.onToggleRole,
  });

  @override
  Widget build(BuildContext context) {
    final isWorker = user.role == UserRole.worker;
    final roleColor = isWorker ? AppColors.info : AppColors.premiumGold;
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';
    final daysSince = DateTime.now().difference(user.joinedAt).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.borderDark,
          width: isCurrentUser ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: roleColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(initial,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: roleColor)),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user.name,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryDark)),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('You',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(user.email,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondaryDark)),
                const SizedBox(height: 4),
                Row(children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: roleColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isWorker ? '👷 Worker' : '👑 Owner',
                      style: TextStyle(
                          fontSize: 10,
                          color: roleColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    daysSince == 0
                        ? 'Joined today'
                        : 'Joined $daysSince days ago',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHintDark),
                  ),
                ]),
              ],
            ),
          ),

          // Actions (owner only, not for self)
          if (isOwner && !isCurrentUser && isWorker)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert,
                  color: AppColors.textSecondaryDark, size: 20),
              color: AppColors.cardDark2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.borderDark)),
              onSelected: (v) {
                if (v == 'promote') onToggleRole?.call();
                if (v == 'remove') onRemove?.call();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'promote',
                  child: Row(children: [
                    Icon(Icons.upgrade_rounded,
                        size: 16, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Promote to Owner',
                        style: TextStyle(color: AppColors.textPrimaryDark)),
                  ]),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(children: [
                    Icon(Icons.person_remove_outlined,
                        size: 16, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Remove',
                        style: TextStyle(color: AppColors.error)),
                  ]),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ── Worker Permissions Card ────────────────────────────────────────────────
class _WorkerPermissionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📋 Worker Permissions',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryDark),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _PermRow('Log egg collections', allowed: true),
          _PermRow('Log feed entries', allowed: true),
          _PermRow('Add health records', allowed: true),
          _PermRow('View flock info', allowed: true),
          _PermRow('View finances', allowed: false),
          _PermRow('Delete records', allowed: false),
          _PermRow('Edit past records', allowed: false),
          _PermRow('Manage workers', allowed: false),
          _PermRow('Export reports (PDF)', allowed: false),
          _PermRow('Change farm settings', allowed: false),
        ],
      ),
    );
  }
}

class _PermRow extends StatelessWidget {
  final String label;
  final bool allowed;
  const _PermRow(this.label, {required this.allowed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            allowed ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 18,
            color: allowed ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
                fontSize: 13,
                color: allowed
                    ? AppColors.textPrimaryDark
                    : AppColors.textSecondaryDark),
          ),
        ],
      ),
    );
  }
}

// ── Empty Workers State ────────────────────────────────────────────────────
class _EmptyWorkers extends StatelessWidget {
  final bool isPremium;
  final VoidCallback onInvite;
  const _EmptyWorkers({required this.isPremium, required this.onInvite});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.borderDark, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Text('👷', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          const Text(
            'No workers yet',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryDark),
          ),
          const SizedBox(height: 6),
          const Text(
            'Invite workers to help log data.\nThey can add records but cannot access finances.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onInvite,
            icon: Text(
              isPremium ? '👤' : '👑',
              style: const TextStyle(fontSize: 14),
            ),
            label: Text(isPremium ? 'Invite First Worker' : 'Upgrade to Invite'),
            style: OutlinedButton.styleFrom(
              foregroundColor: isPremium ? AppColors.primary : AppColors.premiumGold,
              side: BorderSide(
                  color: isPremium ? AppColors.primary : AppColors.premiumGold),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Premium Invite Banner ──────────────────────────────────────────────────
class _PremiumInviteBanner extends StatelessWidget {
  final VoidCallback onUpgrade;
  const _PremiumInviteBanner({required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpgrade,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColors.premiumGold.withValues(alpha: 0.18),
            AppColors.premiumGold.withValues(alpha: 0.06),
          ]),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppColors.premiumGold.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Text('👑', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Worker Invites — Premium Feature',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.premiumGold)),
                  SizedBox(height: 2),
                  Text(
                      'Upgrade to invite workers and manage your team.',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryDark)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.premiumGold, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Invite Worker Bottom Sheet ─────────────────────────────────────────────
class InviteWorkerSheet extends ConsumerStatefulWidget {
  const InviteWorkerSheet({super.key});

  @override
  ConsumerState<InviteWorkerSheet> createState() => _InviteWorkerSheetState();
}

class _InviteWorkerSheetState extends ConsumerState<InviteWorkerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _isSending = false;
  bool _sent = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendInvite() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSending = true);

    await Future.delayed(const Duration(milliseconds: 800)); // simulate API

    // Add worker to list with pending state
    ref.read(userListProvider.notifier).addUser(UserModel(
          id: 'worker-${DateTime.now().millisecondsSinceEpoch}',
          farmId: 'farm1',
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          role: UserRole.worker,
          joinedAt: DateTime.now(),
        ));

    if (mounted) {
      setState(() {
        _isSending = false;
        _sent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: _sent ? _SuccessState(workerName: _nameCtrl.text.trim()) : _FormState(
        formKey: _formKey,
        nameCtrl: _nameCtrl,
        emailCtrl: _emailCtrl,
        isSending: _isSending,
        onSend: _sendInvite,
      ),
    );
  }
}

class _FormState extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final bool isSending;
  final VoidCallback onSend;

  const _FormState({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text('👤 Invite a Worker',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark)),
          const SizedBox(height: 4),
          const Text(
            'Workers can log egg collections, feed entries and health records. They cannot view finances or delete records.',
            style: TextStyle(
                fontSize: 13, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 24),

          // Name field
          const Text('Worker Name',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryDark)),
          const SizedBox(height: 8),
          TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              hintText: 'e.g. Kamal Perera',
              prefixIcon: Icon(Icons.person_outline),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter worker name' : null,
          ),
          const SizedBox(height: 16),

          // Email field
          const Text('Email Address',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryDark)),
          const SizedBox(height: 8),
          TextFormField(
            controller: emailCtrl,
            decoration: const InputDecoration(
              hintText: 'e.g. kamal@gmail.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter email address';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Info box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.info),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'An invitation link will be sent to their email. (Firebase Auth — Phase 11)',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondaryDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Send button
          SizedBox(
            height: 54,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSending ? null : onSend,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: isSending
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Send Invite',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  final String workerName;
  const _SuccessState({required this.workerName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Text('✅', style: TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        Text(
          'Invite Sent!',
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryDark),
        ),
        const SizedBox(height: 8),
        Text(
          '$workerName has been added to your team.\nThey will receive an email invite to join.',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 14, color: AppColors.textSecondaryDark),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ── Premium Gate Sheet ─────────────────────────────────────────────────────
class _PremiumGateSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('👑', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text(
            'Worker Invites',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.premiumGold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Invite workers to help run your farm. They can log data but cannot access finances or sensitive settings.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 20),
          ...const [
            '✅ Invite unlimited workers',
            '✅ Role-based access control',
            '✅ Workers log data on their own devices',
            '✅ Owner reviews all records',
          ].map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Text(f,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondaryDark))
                ]),
              )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.premiumGold,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Upgrade to Premium',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe later'),
          ),
        ],
      ),
    );
  }
}
