import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kukula_app/core/enums/farm_type.dart';
import 'package:kukula_app/core/providers/farm_providers.dart';
import 'package:kukula_app/core/providers/locale_provider.dart';
import 'package:kukula_app/core/providers/theme_provider.dart';
import 'package:kukula_app/core/providers/user_providers.dart';
import 'package:kukula_app/core/routing/app_router.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/shared/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Settings Screen ────────────────────────────────────────────────────────
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmName = ref.watch(farmNameProvider);
    final farmType = ref.watch(farmTypeProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final isDark = ref.watch(themeProvider).isDark;
    final locale = ref.watch(localeProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Profile Card ──────────────────────────────────────────
          _ProfileCard(
            farmName: farmName,
            farmType: farmType,
            isPremium: isPremium,
            ownerName: currentUser.name,
            ownerEmail: currentUser.email,
          ),
          const SizedBox(height: 20),

          // ── Farm Settings ─────────────────────────────────────────
          _SettingsGroup(
            title: '🏡 Farm Settings',
            children: [
              _SettingsTile(
                icon: Icons.agriculture_outlined,
                label: 'Farm Name',
                value: farmName,
                onTap: () => _showEditFarmName(context, ref, farmName),
              ),
              _SettingsTile(
                icon: Icons.egg_outlined,
                label: 'Farm Type',
                value: _farmTypeLabel(farmType),
                onTap: () => _showChangeFarmType(context, ref, farmType),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Appearance ────────────────────────────────────────────
          _SettingsGroup(
            title: '🎨 Appearance',
            children: [
              _SettingsSwitchTile(
                icon: isDark ? Icons.nights_stay_rounded : Icons.wb_sunny_rounded,
                label: 'Dark Mode',
                value: isDark,
                onChanged: (_) =>
                    ref.read(themeProvider.notifier).toggle(),
              ),
              _SettingsTile(
                icon: Icons.language_outlined,
                label: 'Language',
                value: locale.languageCode == 'si' ? '🇱🇰 සිංහල' : '🇬🇧 English',
                onTap: () => _showLanguagePicker(context, ref, locale),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Account ───────────────────────────────────────────────
          _SettingsGroup(
            title: '👤 Account',
            children: [
              _SettingsTile(
                icon: Icons.person_outline,
                label: 'Name',
                value: currentUser.name,
                onTap: () => _showEditName(context, ref, currentUser.name),
              ),
              _SettingsTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: currentUser.email,
                onTap: null, // read-only (Firebase auth)
              ),
              _SettingsTile(
                icon: Icons.people_outline,
                label: 'Manage Workers',
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.users);
                },
              ),
              _SettingsTile(
                icon: Icons.backup_outlined,
                label: 'Backup & Restore',
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.backup);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Subscription ──────────────────────────────────────────
          _SettingsGroup(
            title: '💎 Subscription',
            children: [
              if (!isPremium)
                _PremiumUpgradeTile()
              else
                _SettingsTile(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Plan',
                  value: '👑 Premium — Active',
                  valueColor: AppColors.premiumGold,
                  onTap: null,
                ),
              // Dev toggle to test premium/free
              _SettingsSwitchTile(
                icon: Icons.science_outlined,
                label: 'Premium Mode (Dev Toggle)',
                value: isPremium,
                onChanged: (v) =>
                    ref.read(isPremiumProvider.notifier).state = v,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Notifications ─────────────────────────────────────────
          _SettingsGroup(
            title: '🔔 Notifications',
            children: [
              _SettingsSwitchTile(
                icon: Icons.vaccines_outlined,
                label: 'Vaccination Reminders',
                value: true,
                onChanged: (_) {},
              ),
              _SettingsSwitchTile(
                icon: Icons.inventory_outlined,
                label: 'Low Stock Alerts',
                value: true,
                onChanged: (_) {},
              ),
              _SettingsSwitchTile(
                icon: Icons.medication_outlined,
                label: 'Medicine Expiry Alerts',
                value: true,
                onChanged: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── About ─────────────────────────────────────────────────
          _SettingsGroup(
            title: 'ℹ️ About',
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                label: 'App Version',
                value: '1.0.0 (Build 1)',
                onTap: null,
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                label: 'Terms of Service',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.star_outline_rounded,
                label: 'Rate the App',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Sign Out ──────────────────────────────────────────────
          _SignOutTile(onSignOut: () => _signOut(context, ref)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  String _farmTypeLabel(FarmType t) => switch (t) {
        FarmType.egg => '🥚 Egg Farm',
        FarmType.meat => '🐔 Meat / Broiler Farm',
        FarmType.both => '🐔🥚 Egg + Meat Farm',
      };

  void _showEditFarmName(
      BuildContext context, WidgetRef ref, String current) {
    final ctrl = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Edit Farm Name',
            style: TextStyle(color: AppColors.textPrimaryDark)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
              hintText: 'e.g. Silva Poultry Farm'),
          style: const TextStyle(color: AppColors.textPrimaryDark),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;
              ref.read(farmNameProvider.notifier).state = name;
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('farmName', name);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangeFarmType(
      BuildContext context, WidgetRef ref, FarmType current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _FarmTypePickerSheet(current: current, ref: ref),
    );
  }

  void _showLanguagePicker(
      BuildContext context, WidgetRef ref, Locale locale) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _LanguagePickerSheet(ref: ref, current: locale),
    );
  }

  void _showEditName(
      BuildContext context, WidgetRef ref, String current) {
    final ctrl = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Edit Name',
            style: TextStyle(color: AppColors.textPrimaryDark)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration:
              const InputDecoration(hintText: 'Your name'),
          style: const TextStyle(color: AppColors.textPrimaryDark),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;
              final user = ref.read(currentUserProvider);
              // Construct updated UserModel manually (no copyWith)
              ref.read(currentUserProvider.notifier).state = UserModel(
                id: user.id,
                farmId: user.farmId,
                name: name,
                email: user.email,
                role: user.role,
                joinedAt: user.joinedAt,
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Sign Out',
            style: TextStyle(color: AppColors.textPrimaryDark)),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppColors.textSecondaryDark),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.go(AppRoutes.welcome);
    }
  }
}

// ── Profile Card ───────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final String farmName;
  final FarmType farmType;
  final bool isPremium;
  final String ownerName;
  final String ownerEmail;

  const _ProfileCard({
    required this.farmName,
    required this.farmType,
    required this.isPremium,
    required this.ownerName,
    required this.ownerEmail,
  });

  @override
  Widget build(BuildContext context) {
    final farmTypeLabel = switch (farmType) {
      FarmType.egg => '🥚 Egg Farm',
      FarmType.meat => '🐔 Meat Farm',
      FarmType.both => '🐔🥚 Egg + Meat Farm',
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.18),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Farm icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Text('🐔', style: TextStyle(fontSize: 34)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(farmName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryDark)),
                const SizedBox(height: 2),
                Text(ownerName,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondaryDark)),
                const SizedBox(height: 6),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(farmTypeLabel,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isPremium
                          ? AppColors.premiumGold.withValues(alpha: 0.15)
                          : AppColors.borderDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isPremium ? '👑 Premium' : '🆓 Free',
                      style: TextStyle(
                          fontSize: 11,
                          color: isPremium
                              ? AppColors.premiumGold
                              : AppColors.textSecondaryDark,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Settings Group ─────────────────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondaryDark,
                  letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            children: children
                .asMap()
                .entries
                .map((e) => Column(children: [
                      e.value,
                      if (e.key < children.length - 1)
                        const Divider(
                            height: 1,
                            indent: 56,
                            color: AppColors.borderDark),
                    ]))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ── Settings Tile ──────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color? valueColor;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.value,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, size: 22, color: AppColors.textSecondaryDark),
      title: Text(label,
          style: const TextStyle(
              fontSize: 14, color: AppColors.textPrimaryDark)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(value!,
                style: TextStyle(
                    fontSize: 13,
                    color: valueColor ?? AppColors.textSecondaryDark)),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.textHintDark),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}

// ── Settings Switch Tile ───────────────────────────────────────────────────
class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      secondary: Icon(icon, size: 22, color: AppColors.textSecondaryDark),
      title: Text(label,
          style: const TextStyle(
              fontSize: 14, color: AppColors.textPrimaryDark)),
      value: value,
      activeColor: AppColors.primary,
      onChanged: onChanged,
    );
  }
}

// ── Premium Upgrade Tile ───────────────────────────────────────────────────
class _PremiumUpgradeTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: const Text('👑', style: TextStyle(fontSize: 22)),
      title: const Text('Upgrade to Premium',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.premiumGold)),
      subtitle: const Text('Unlock PDF reports, cloud backup & worker invites',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.premiumGold,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Upgrade',
            style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w700)),
      ),
      onTap: () {},
    );
  }
}

// ── Sign Out Tile ──────────────────────────────────────────────────────────
class _SignOutTile extends StatelessWidget {
  final VoidCallback onSignOut;
  const _SignOutTile({required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: const Icon(Icons.logout_rounded,
            color: AppColors.error, size: 22),
        title: const Text('Sign Out',
            style: TextStyle(
                fontSize: 14,
                color: AppColors.error,
                fontWeight: FontWeight.w600)),
        onTap: onSignOut,
      ),
    );
  }
}

// ── Farm Type Picker Sheet ─────────────────────────────────────────────────
class _FarmTypePickerSheet extends StatelessWidget {
  final FarmType current;
  final WidgetRef ref;
  const _FarmTypePickerSheet({required this.current, required this.ref});

  @override
  Widget build(BuildContext context) {
    final options = [
      (FarmType.egg, '🥚', 'Egg Farm', 'Layer hens producing eggs'),
      (FarmType.meat, '🐔', 'Meat / Broiler Farm', 'Broilers for meat production'),
      (FarmType.both, '🐔🥚', 'Egg + Meat Farm', 'Both egg layers and meat broilers'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Change Farm Type',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark)),
          const SizedBox(height: 16),
          ...options.map((opt) {
            final (type, icon, title, desc) = opt;
            final isSelected = current == type;
            return GestureDetector(
              onTap: () async {
                ref.read(farmTypeProvider.notifier).state = type;
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('farmType', type.name);
                if (context.mounted) Navigator.pop(context);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.cardDark2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.borderDark,
                      width: isSelected ? 2 : 1),
                ),
                child: Row(children: [
                  Text(icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimaryDark)),
                        Text(desc,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondaryDark)),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.primary, size: 22),
                ]),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Language Picker Sheet ──────────────────────────────────────────────────
class _LanguagePickerSheet extends StatelessWidget {
  final WidgetRef ref;
  final Locale current;
  const _LanguagePickerSheet({required this.ref, required this.current});

  @override
  Widget build(BuildContext context) {
    final langs = [
      ('en', '🇬🇧', 'English', 'English'),
      ('si', '🇱🇰', 'සිංහල', 'Sinhala'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Select Language',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark)),
          const SizedBox(height: 16),
          ...langs.map((l) {
            final (code, flag, name, sub) = l;
            final isSelected = current.languageCode == code;
            return GestureDetector(
              onTap: () async {
                await ref
                    .read(localeProvider.notifier)
                    .setLocale(Locale(code));
                if (context.mounted) Navigator.pop(context);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.cardDark2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.borderDark,
                      width: isSelected ? 2 : 1),
                ),
                child: Row(children: [
                  Text(flag, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimaryDark)),
                        Text(sub,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondaryDark)),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.primary, size: 22),
                ]),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
