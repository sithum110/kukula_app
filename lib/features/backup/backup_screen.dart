import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/providers/batch_providers.dart';
import 'package:kukula_app/core/providers/egg_providers.dart';
import 'package:kukula_app/core/providers/farm_providers.dart';
import 'package:kukula_app/core/providers/feed_providers.dart';
import 'package:kukula_app/core/providers/finance_providers.dart';
import 'package:kukula_app/core/providers/health_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:share_plus/share_plus.dart';

// ── Backup Screen ──────────────────────────────────────────────────────────
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _isExporting = false;
  bool _isImporting = false;
  DateTime? _lastBackup;
  String? _lastBackupSize;

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Status Card ────────────────────────────────────────────
          _BackupStatusCard(
            lastBackup: _lastBackup,
            lastBackupSize: _lastBackupSize,
          ),
          const SizedBox(height: 20),

          // ── Local Backup ───────────────────────────────────────────
          _SectionHeader('📱 Local Backup'),
          const SizedBox(height: 10),
          _BackupCard(
            icon: '📤',
            title: 'Export Farm Data',
            subtitle:
                'Save all your data as a JSON file. Share via WhatsApp, email, or save to Files.',
            buttonLabel: 'Export & Share',
            buttonColor: AppColors.primary,
            isLoading: _isExporting,
            onTap: _exportData,
          ),
          const SizedBox(height: 10),
          _BackupCard(
            icon: '📥',
            title: 'Import / Restore',
            subtitle:
                'Restore data from a previously exported backup file. This will merge with existing data.',
            buttonLabel: 'Choose File',
            buttonColor: AppColors.info,
            isLoading: _isImporting,
            onTap: () => _showImportComingSoon(context),
          ),

          const SizedBox(height: 20),

          // ── Cloud Backup (Premium) ─────────────────────────────────
          _SectionHeader('☁️ Cloud Backup'),
          const SizedBox(height: 10),
          _CloudBackupCard(
            isPremium: isPremium,
            onUpgrade: () => _showPremiumGate(context),
          ),

          const SizedBox(height: 20),

          // ── What's Included ────────────────────────────────────────
          _SectionHeader('📋 What\'s Included in Backup'),
          const SizedBox(height: 10),
          _WhatIsIncludedCard(),

          const SizedBox(height: 20),

          // ── Danger Zone ────────────────────────────────────────────
          _SectionHeader('⚠️ Danger Zone'),
          const SizedBox(height: 10),
          _DangerZoneCard(onClearData: () => _showClearConfirm(context)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _exportData() async {
    setState(() => _isExporting = true);

    try {
      // Gather data from all providers
      final flocks = ref.read(flockListProvider);
      final batches = ref.read(batchListProvider);
      final eggCollections = ref.read(eggRecordListProvider);
      final eggSales = ref.read(eggSaleListProvider);
      final feedLogs = ref.read(feedLogListProvider);
      final feedTypes = ref.read(feedTypeListProvider);
      final healthRecords = ref.read(healthRecordListProvider);
      final vaccSchedule = ref.read(vaccinationScheduleProvider);
      final medicineStock = ref.read(medicineStockProvider);
      // FinanceNotifier extends StateNotifier<List<...>> so use .state
      final transactions = ref.read(financeProvider);

      final backup = {
        'version': '1.0',
        'exportedAt': DateTime.now().toIso8601String(),
        'appName': 'Easy Poultry Manager',
        'data': {
          'flocks': flocks.map((e) => e.toJson()).toList(),
          'batches': batches.map((e) => e.toJson()).toList(),
          'eggCollections': eggCollections.map((e) => e.toJson()).toList(),
          'eggSales': eggSales.map((e) => e.toJson()).toList(),
          // Feed: encode key fields
          'feedLogs': feedLogs.map((e) => {
            'id': e.id, 'date': e.date.toIso8601String(),
            'feedTypeName': e.feedTypeName, 'quantityKg': e.quantityKg,
            'costLKR': e.costLKR, 'flockName': e.flockName,
          }).toList(),
          'feedTypes': feedTypes.map((e) => {
            'id': e.id, 'name': e.name, 'brand': e.brand,
            'pricePerKg': e.pricePerKg, 'currentStockKg': e.currentStockKg,
          }).toList(),
          // Health: encode key fields
          'healthRecords': healthRecords.map((e) => {
            'id': e.id, 'date': e.date.toIso8601String(),
            'type': e.type.name, 'productName': e.productName,
            'dosage': e.dosage, 'notes': e.notes,
          }).toList(),
          'vaccSchedule': vaccSchedule.map((e) => {
            'id': e.id, 'vaccineName': e.vaccineName,
            'dueDate': e.dueDate.toIso8601String(),
            'isCompleted': e.isCompleted,
          }).toList(),
          'medicineStock': medicineStock.map((e) => {
            'id': e.id, 'name': e.name, 'unit': e.unit,
            'currentQty': e.currentQty,
            'expiryDate': e.expiryDate?.toIso8601String(),
          }).toList(),
          'transactions': transactions.map((e) => {
            'id': e.id, 'type': e.type.name,
            'category': e.category.name, 'amount': e.amount,
            'description': e.description, 'date': e.date.toIso8601String(),
          }).toList(),
        },
      };

      final jsonStr =
          const JsonEncoder.withIndent('  ').convert(backup);
      final bytes = utf8.encode(jsonStr);
      final sizeKb = (bytes.length / 1024).toStringAsFixed(1);

      // Share as text via share_plus
      await Share.share(
        jsonStr,
        subject:
            'Easy Poultry Manager — Farm Backup ${DateTime.now().toLocal().toString().substring(0, 10)}',
      );

      if (mounted) {
        setState(() {
          _lastBackup = DateTime.now();
          _lastBackupSize = '$sizeKb KB';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _showImportComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content:
          Text('File import will be available after Firebase integration (Phase 11)'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _showPremiumGate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PremiumGateSheet(),
    );
  }

  Future<void> _showClearConfirm(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Clear All Data',
            style: TextStyle(color: AppColors.error)),
        content: const Text(
          'This will permanently delete ALL farm data — flocks, egg records, feeding, health, finance, and sales. This cannot be undone.\n\nMake sure to export a backup first!',
          style: TextStyle(color: AppColors.textSecondaryDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Data clear will be available after offline DB integration (Phase 11)'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}

// ── Backup Status Card ─────────────────────────────────────────────────────
class _BackupStatusCard extends StatelessWidget {
  final DateTime? lastBackup;
  final String? lastBackupSize;
  const _BackupStatusCard({this.lastBackup, this.lastBackupSize});

  @override
  Widget build(BuildContext context) {
    final hasBackup = lastBackup != null;
    final color = hasBackup ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
                hasBackup ? '✅' : '⚠️',
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
                  hasBackup ? 'Backup Up to Date' : 'No Backup Yet',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: color),
                ),
                const SizedBox(height: 3),
                Text(
                  hasBackup
                      ? 'Last backup: ${_formatDate(lastBackup!)}  •  $lastBackupSize'
                      : 'Export your data to keep it safe',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondaryDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d).inMinutes;
    if (diff < 1) return 'Just now';
    if (diff < 60) return '$diff min ago';
    return '${d.day}/${d.month}/${d.year}';
  }
}

// ── Backup Card ────────────────────────────────────────────────────────────
class _BackupCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final Color buttonColor;
  final bool isLoading;
  final VoidCallback onTap;

  const _BackupCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.buttonColor,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryDark)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondaryDark)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: isLoading ? null : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Text(buttonLabel,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── Cloud Backup Card ──────────────────────────────────────────────────────
class _CloudBackupCard extends StatelessWidget {
  final bool isPremium;
  final VoidCallback onUpgrade;
  const _CloudBackupCard({required this.isPremium, required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isPremium ? null : onUpgrade,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPremium
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.premiumGold.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text('☁️', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text('Google Drive Backup',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimaryDark)),
                        const SizedBox(width: 6),
                        if (!isPremium)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.premiumGold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('PREMIUM',
                                style: TextStyle(
                                    fontSize: 9,
                                    color: AppColors.premiumGold,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5)),
                          ),
                      ]),
                      const SizedBox(height: 4),
                      const Text(
                          'Auto-sync your farm data to Google Drive. Never lose data even if your phone is lost.',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryDark)),
                    ],
                  ),
                ),
              ],
            ),
            if (isPremium) ...[
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.sync_rounded, size: 16),
                      label: const Text('Sync Now'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.settings_outlined, size: 16),
                      label: const Text('Auto-Sync'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondaryDark,
                        side: const BorderSide(color: AppColors.borderDark),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onUpgrade,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.premiumGold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('👑 Upgrade to Enable',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── What's Included ────────────────────────────────────────────────────────
class _WhatIsIncludedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      ('🐔', 'Flocks & Batches'),
      ('🥚', 'Egg Collections & Sales'),
      ('🌾', 'Feed Logs & Stock'),
      ('💊', 'Health Records & Vaccines'),
      ('💰', 'Finance Transactions'),
      ('📋', 'Vaccination Schedule'),
      ('📦', 'Medicine Stock'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items
            .map((item) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Text('${item.$1} ${item.$2}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimaryDark)),
                ))
            .toList(),
      ),
    );
  }
}

// ── Danger Zone Card ───────────────────────────────────────────────────────
class _DangerZoneCard extends StatelessWidget {
  final VoidCallback onClearData;
  const _DangerZoneCard({required this.onClearData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Text('🗑️', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Clear All Data',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.error)),
                SizedBox(height: 4),
                Text('Permanently delete all farm records. Export first!',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondaryDark)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: onClearData,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Clear',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Text(title,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondaryDark,
          letterSpacing: 0.5));
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
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 24),
          const Text('👑', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text('Cloud Backup',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.premiumGold)),
          const SizedBox(height: 8),
          const Text(
            'Keep your farm data safe with automatic Google Drive backups.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 20),
          for (final f in const [
            '✅ Auto-backup every 24 hours',
            '✅ Restore from any device',
            '✅ 30-day backup history',
            '✅ Never lose your farm data',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(children: [
                Text(f,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondaryDark))
              ]),
            ),
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
                      borderRadius: BorderRadius.circular(14))),
              child: const Text('Upgrade to Premium',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Maybe later')),
        ],
      ),
    );
  }
}
