import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kukula_app/core/providers/batch_providers.dart';
import 'package:kukula_app/core/providers/egg_providers.dart';
import 'package:kukula_app/core/providers/farm_providers.dart';
import 'package:kukula_app/core/providers/feed_providers.dart';
import 'package:kukula_app/core/providers/finance_providers.dart';
import 'package:kukula_app/core/providers/health_providers.dart';
import 'package:kukula_app/features/egg_production/egg_model.dart';
import 'package:kukula_app/features/feeding/feed_model.dart';
import 'package:kukula_app/features/finance/finance_model.dart';
import 'package:kukula_app/features/flocks/flock_model.dart';
import 'package:kukula_app/features/health/health_model.dart';
import 'package:kukula_app/features/meat_batches/batch_model.dart';


// ── Backup Result ──────────────────────────────────────────────────────────
class BackupResult {
  final bool success;
  final String? message;
  final String? filePath;
  final String? sizeKb;

  const BackupResult({
    required this.success,
    this.message,
    this.filePath,
    this.sizeKb,
  });
}

// ── Local Backup Service ───────────────────────────────────────────────────
class LocalBackupService {
  static const _backupVersion = '1.2';
  static const _appName = 'Easy Poultry Manager';

  // ── Export (Create Backup) ───────────────────────────────────────────────
  static Future<BackupResult> exportBackup(WidgetRef ref) async {
    try {
      final jsonStr = _buildBackupJson(ref);
      final bytes = utf8.encode(jsonStr);
      final sizeKb = (bytes.length / 1024).toStringAsFixed(1);

      // Save to app documents directory
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .substring(0, 19);
      final fileName = 'poultry_backup_$timestamp.json';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(jsonStr);

      // Share the file so user can save it anywhere
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '$_appName — Farm Backup $timestamp',
        text: 'Easy Poultry Manager farm data backup. Keep this file safe.',
      );

      return BackupResult(
        success: true,
        filePath: file.path,
        sizeKb: '$sizeKb KB',
        message: 'Backup exported successfully ($sizeKb KB)',
      );
    } catch (e) {
      return BackupResult(
        success: false,
        message: 'Export failed: ${e.toString()}',
      );
    }
  }

  // ── Import (Restore from backup) ─────────────────────────────────────────
  static Future<BackupResult> importBackup(WidgetRef ref) async {
    try {
      // Let user pick a JSON file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: 'Select Backup File',
      );

      if (result == null || result.files.isEmpty) {
        return const BackupResult(
          success: false,
          message: 'No file selected',
        );
      }

      final pickedFile = result.files.first;
      final filePath = pickedFile.path;

      if (filePath == null) {
        return const BackupResult(
          success: false,
          message: 'Cannot read selected file',
        );
      }

      final file = File(filePath);
      final jsonStr = await file.readAsString();
      final Map<String, dynamic> backup = jsonDecode(jsonStr);

      // Validate the backup format
      final version = backup['version'] as String?;
      final appName = backup['appName'] as String?;
      if (appName == null || !appName.contains('Poultry')) {
        return const BackupResult(
          success: false,
          message: 'Invalid backup file. Please select a valid Easy Poultry Manager backup.',
        );
      }

      // Restore data back into providers
      final data = backup['data'] as Map<String, dynamic>?;
      if (data == null) {
        return const BackupResult(
          success: false,
          message: 'Backup file contains no data',
        );
      }

      await _restoreFromData(ref, data);

      return BackupResult(
        success: true,
        message: 'Backup restored from $filePath (v$version)',
      );
    } catch (e) {
      return BackupResult(
        success: false,
        message: 'Import failed: ${e.toString()}',
      );
    }
  }

  // ── Get last saved backup info ────────────────────────────────────────────
  static Future<({DateTime? date, String? size, String? path})>
      getLastBackupInfo() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.contains('poultry_backup_'))
          .toList()
        ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      if (files.isEmpty) return (date: null, size: null, path: null);

      final latest = files.first;
      final stat = await latest.stat();
      final sizeKb = (stat.size / 1024).toStringAsFixed(1);

      return (
        date: latest.lastModifiedSync(),
        size: '$sizeKb KB',
        path: latest.path,
      );
    } catch (_) {
      return (date: null, size: null, path: null);
    }
  }

  // ── List all backup files on device ──────────────────────────────────────
  static Future<List<({String path, DateTime date, String size})>>
      listBackups() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.contains('poultry_backup_'))
          .toList()
        ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      return files.map((f) {
        final stat = f.statSync();
        final sizeKb = (stat.size / 1024).toStringAsFixed(1);
        return (
          path: f.path,
          date: f.lastModifiedSync(),
          size: '$sizeKb KB',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Delete a specific backup file ─────────────────────────────────────────
  static Future<bool> deleteBackup(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Clear all app data (reset to factory) ────────────────────────────────
  static Future<void> clearAllData(WidgetRef ref) async {
    // Reset all Riverpod state notifiers to empty
    ref.read(flockListProvider.notifier).clearAll();
    ref.read(batchListProvider.notifier).clearAll();
    ref.read(eggRecordListProvider.notifier).clearAll();
    ref.read(eggSaleListProvider.notifier).clearAll();
    ref.read(feedTypeListProvider.notifier).clearAll();
    ref.read(feedLogListProvider.notifier).clearAll();
    ref.read(healthRecordListProvider.notifier).clearAll();
    ref.read(vaccinationScheduleProvider.notifier).clearAll();
    ref.read(medicineStockProvider.notifier).clearAll();
    ref.read(financeProvider.notifier).clearAll();
  }

  // ── Reload all providers from Firestore (call after sign-in) ──────────────
  static Future<void> reloadAllFromFirestore(WidgetRef ref) async {
    await Future.wait([
      ref.read(flockListProvider.notifier).reload(),
      ref.read(batchListProvider.notifier).reload(),
      ref.read(eggRecordListProvider.notifier).reload(),
      ref.read(eggSaleListProvider.notifier).reload(),
      ref.read(feedTypeListProvider.notifier).reload(),
      ref.read(feedLogListProvider.notifier).reload(),
      ref.read(healthRecordListProvider.notifier).reload(),
      ref.read(vaccinationScheduleProvider.notifier).reload(),
      ref.read(medicineStockProvider.notifier).reload(),
      ref.read(financeProvider.notifier).reload(),
    ]);
  }

  // ── Private: Build JSON backup string ─────────────────────────────────────
  static String _buildBackupJson(WidgetRef ref) {
    final flocks = ref.read(flockListProvider);
    final batches = ref.read(batchListProvider);
    final eggCollections = ref.read(eggRecordListProvider);
    final eggSales = ref.read(eggSaleListProvider);
    final feedLogs = ref.read(feedLogListProvider);
    final feedTypes = ref.read(feedTypeListProvider);
    final healthRecords = ref.read(healthRecordListProvider);
    final vaccSchedule = ref.read(vaccinationScheduleProvider);
    final medicineStock = ref.read(medicineStockProvider);
    final transactions = ref.read(financeProvider);
    final farmName = ref.read(farmNameProvider);
    final farmType = ref.read(farmTypeProvider);

    final backup = {
      'version': _backupVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'appName': _appName,
      'farm': {
        'name': farmName,
        'type': farmType.name,
      },
      'data': {
        'flocks': flocks.map((e) => e.toJson()).toList(),
        'batches': batches.map((e) => e.toJson()).toList(),
        'eggCollections': eggCollections.map((e) => e.toJson()).toList(),
        'eggSales': eggSales.map((e) => e.toJson()).toList(),
        'feedLogs': feedLogs.map((e) => e.toJson()).toList(),
        'feedTypes': feedTypes.map((e) => e.toJson()).toList(),
        'healthRecords': healthRecords.map((e) => e.toJson()).toList(),
        'vaccSchedule': vaccSchedule.map((e) => e.toJson()).toList(),
        'medicineStock': medicineStock.map((e) => e.toJson()).toList(),
        'transactions': transactions.map((e) => e.toJson()).toList(),
      },
    };

    return const JsonEncoder.withIndent('  ').convert(backup);
  }

  // ── Private: Restore data into providers ──────────────────────────────────
  static Future<void> _restoreFromData(WidgetRef ref, Map<String, dynamic> data) async {
    debugPrint('[LocalBackupService] Restoring ${data.keys.length} data collections...');

    // Clear all first
    await clearAllData(ref);

    // ── Flocks
    final flocksRaw = data['flocks'] as List<dynamic>? ?? [];
    for (final raw in flocksRaw) {
      try {
        ref.read(flockListProvider.notifier).addFlock(
            FlockModel.fromJson(raw as Map<String, dynamic>));
      } catch (_) {}
    }

    // ── Batches
    final batchesRaw = data['batches'] as List<dynamic>? ?? [];
    for (final raw in batchesRaw) {
      try {
        ref.read(batchListProvider.notifier).addBatch(
            BatchModel.fromJson(raw as Map<String, dynamic>));
      } catch (_) {}
    }

    // ── Egg Collections
    final eggColRaw = data['eggCollections'] as List<dynamic>? ?? [];
    for (final raw in eggColRaw) {
      try {
        ref.read(eggRecordListProvider.notifier).addRecord(
            EggRecordModel.fromJson(raw as Map<String, dynamic>));
      } catch (_) {}
    }

    // ── Egg Sales
    final eggSalesRaw = data['eggSales'] as List<dynamic>? ?? [];
    for (final raw in eggSalesRaw) {
      try {
        ref.read(eggSaleListProvider.notifier).addSale(
            EggSaleModel.fromJson(raw as Map<String, dynamic>));
      } catch (_) {}
    }

    // ── Feed Types
    final feedTypesRaw = data['feedTypes'] as List<dynamic>? ?? [];
    for (final raw in feedTypesRaw) {
      try {
        ref.read(feedTypeListProvider.notifier).addFeedType(
            FeedTypeModel.fromJson(raw as Map<String, dynamic>));
      } catch (_) {}
    }

    // ── Feed Logs
    final feedLogsRaw = data['feedLogs'] as List<dynamic>? ?? [];
    for (final raw in feedLogsRaw) {
      try {
        ref.read(feedLogListProvider.notifier).addLog(
            FeedLogModel.fromJson(raw as Map<String, dynamic>));
      } catch (_) {}
    }

    // ── Health Records
    final healthRaw = data['healthRecords'] as List<dynamic>? ?? [];
    for (final raw in healthRaw) {
      try {
        ref.read(healthRecordListProvider.notifier).addRecord(
            HealthRecordModel.fromJson(raw as Map<String, dynamic>));
      } catch (_) {}
    }

    // ── Vaccination Schedule
    final vaccRaw = data['vaccSchedule'] as List<dynamic>? ?? [];
    for (final raw in vaccRaw) {
      try {
        ref.read(vaccinationScheduleProvider.notifier).addSchedule(
            VaccinationScheduleModel.fromJson(raw as Map<String, dynamic>));
      } catch (_) {}
    }

    // ── Medicine Stock
    final medRaw = data['medicineStock'] as List<dynamic>? ?? [];
    for (final raw in medRaw) {
      try {
        ref.read(medicineStockProvider.notifier).addItem(
            MedicineStockModel.fromJson(raw as Map<String, dynamic>));
      } catch (_) {}
    }

    // ── Finance Transactions
    final financeRaw = data['transactions'] as List<dynamic>? ?? [];
    for (final raw in financeRaw) {
      try {
        ref.read(financeProvider.notifier).addTransaction(
            FinanceTransactionModel.fromJson(raw as Map<String, dynamic>));
      } catch (_) {}
    }

    debugPrint('[LocalBackupService] Restore complete. All data synced to Firestore.');
  }
}
