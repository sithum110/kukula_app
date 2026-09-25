import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight JSON persistence layer using SharedPreferences.
/// Stores each domain as a JSON-encoded list under a fixed key.
/// All reads/writes are synchronous after the initial async load.
class LocalStorageService {
  static const _flocks      = 'local_flocks';
  static const _batches     = 'local_batches';
  static const _eggRecords  = 'local_egg_records';
  static const _eggSales    = 'local_egg_sales';
  static const _feedTypes   = 'local_feed_types';
  static const _feedLogs    = 'local_feed_logs';
  static const _healthRecs  = 'local_health_records';
  static const _vaccineSched = 'local_vaccine_schedule';
  static const _medicineStock = 'local_medicine_stock';
  static const _finance     = 'local_finance';
  static const _meatSales   = 'local_meat_sales';

  // ── Read ──────────────────────────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> loadFlocks()       => _load(_flocks);
  static Future<List<Map<String, dynamic>>> loadBatches()      => _load(_batches);
  static Future<List<Map<String, dynamic>>> loadEggRecords()   => _load(_eggRecords);
  static Future<List<Map<String, dynamic>>> loadEggSales()     => _load(_eggSales);
  static Future<List<Map<String, dynamic>>> loadFeedTypes()    => _load(_feedTypes);
  static Future<List<Map<String, dynamic>>> loadFeedLogs()     => _load(_feedLogs);
  static Future<List<Map<String, dynamic>>> loadHealthRecs()   => _load(_healthRecs);
  static Future<List<Map<String, dynamic>>> loadVaccineSchedule() => _load(_vaccineSched);
  static Future<List<Map<String, dynamic>>> loadMedicineStock()=> _load(_medicineStock);
  static Future<List<Map<String, dynamic>>> loadFinance()      => _load(_finance);
  static Future<List<Map<String, dynamic>>> loadMeatSales()    => _load(_meatSales);

  // ── Write ─────────────────────────────────────────────────────────────────
  static Future<void> saveFlocks(List<Map<String, dynamic>> data)       => _save(_flocks, data);
  static Future<void> saveBatches(List<Map<String, dynamic>> data)      => _save(_batches, data);
  static Future<void> saveEggRecords(List<Map<String, dynamic>> data)   => _save(_eggRecords, data);
  static Future<void> saveEggSales(List<Map<String, dynamic>> data)     => _save(_eggSales, data);
  static Future<void> saveFeedTypes(List<Map<String, dynamic>> data)    => _save(_feedTypes, data);
  static Future<void> saveFeedLogs(List<Map<String, dynamic>> data)     => _save(_feedLogs, data);
  static Future<void> saveHealthRecs(List<Map<String, dynamic>> data)   => _save(_healthRecs, data);
  static Future<void> saveVaccineSchedule(List<Map<String, dynamic>> data) => _save(_vaccineSched, data);
  static Future<void> saveMedicineStock(List<Map<String, dynamic>> data)=> _save(_medicineStock, data);
  static Future<void> saveFinance(List<Map<String, dynamic>> data)      => _save(_finance, data);
  static Future<void> saveMeatSales(List<Map<String, dynamic>> data)    => _save(_meatSales, data);

  // ── Clear All (sign-out / reset) ──────────────────────────────────────────
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in [
      _flocks, _batches, _eggRecords, _eggSales,
      _feedTypes, _feedLogs, _healthRecs, _vaccineSched,
      _medicineStock, _finance, _meatSales,
    ]) {
      await prefs.remove(key);
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> _load(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null) return [];
      final decoded = json.decode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _save(String key, List<Map<String, dynamic>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, json.encode(data));
    } catch (_) {}
  }
}
