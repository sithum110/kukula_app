import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ── Table definitions ────────────────────────────────────────────────────────

class FlockTable extends Table {
  TextColumn get id => text()();
  TextColumn get farmId => text()();
  TextColumn get name => text()();
  TextColumn get breed => text().nullable()();
  TextColumn get purpose => text()(); // 'layer' | 'broiler'
  IntColumn get currentCount => integer()();
  IntColumn get initialCount => integer()();
  TextColumn get pen => text().nullable()();
  DateTimeColumn get arrivalDate => dateTime()();
  TextColumn get status => text()(); // 'active' | 'closed'
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class BatchTable extends Table {
  TextColumn get id => text()();
  TextColumn get farmId => text()();
  TextColumn get name => text()();
  TextColumn get breed => text().nullable()();
  DateTimeColumn get arrivalDate => dateTime()();
  IntColumn get initialCount => integer()();
  IntColumn get currentCount => integer()();
  TextColumn get supplier => text().nullable()();
  TextColumn get status => text()(); // 'growing' | 'sold' | 'closed'
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class EggRecordTable extends Table {
  TextColumn get id => text()();
  TextColumn get farmId => text()();
  TextColumn get flockId => text().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get totalEggs => integer()();
  IntColumn get brokenEggs => integer().withDefault(const Constant(0))();
  IntColumn get gradeA => integer().nullable()();
  IntColumn get gradeB => integer().nullable()();
  IntColumn get gradeC => integer().nullable()();
  TextColumn get collectedBy => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class EggSaleTable extends Table {
  TextColumn get id => text()();
  TextColumn get farmId => text()();
  TextColumn get saleType => text()(); // 'sale' | 'personalUse' | etc
  IntColumn get quantity => integer()();
  RealColumn get pricePerUnit => real().nullable()();
  RealColumn get totalAmount => real().nullable()();
  TextColumn get buyerName => text().nullable()();
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class FeedTypeTable extends Table {
  TextColumn get id => text()();
  TextColumn get farmId => text()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get forPurpose => text().nullable()();
  RealColumn get currentStockKg => real()();
  RealColumn get lowStockThresholdKg => real()();
  RealColumn get pricePerKg => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class FeedLogTable extends Table {
  TextColumn get id => text()();
  TextColumn get farmId => text()();
  TextColumn get feedTypeId => text()();
  TextColumn get feedTypeName => text()();
  TextColumn get flockId => text().nullable()();
  TextColumn get flockName => text().nullable()();
  RealColumn get quantityKg => real()();
  RealColumn get costLKR => real().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class HealthRecordTable extends Table {
  TextColumn get id => text()();
  TextColumn get farmId => text()();
  TextColumn get flockId => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()(); // 'vaccination' | 'medication' | etc
  TextColumn get productName => text()();
  TextColumn get dosage => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get nextDueDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class VaccinationScheduleTable extends Table {
  TextColumn get id => text()();
  TextColumn get farmId => text()();
  TextColumn get flockId => text().nullable()();
  TextColumn get vaccineName => text()();
  DateTimeColumn get dueDate => dateTime()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class MedicineStockTable extends Table {
  TextColumn get id => text()();
  TextColumn get farmId => text()();
  TextColumn get name => text()();
  TextColumn get stockType => text()(); // 'medicine' | 'vaccine'
  TextColumn get unit => text().nullable()();
  RealColumn get currentQty => real()();
  RealColumn get lowStockThreshold => real()();
  RealColumn get pricePerUnit => real().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class FinanceTransactionTable extends Table {
  TextColumn get id => text()();
  TextColumn get farmId => text()();
  TextColumn get type => text()(); // 'income' | 'expense'
  TextColumn get category => text()();
  RealColumn get amount => real()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  FlockTable,
  BatchTable,
  EggRecordTable,
  EggSaleTable,
  FeedTypeTable,
  FeedLogTable,
  HealthRecordTable,
  VaccinationScheduleTable,
  MedicineStockTable,
  FinanceTransactionTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ── Flock CRUD ─────────────────────────────────────────────────────────────
  Future<List<FlockTableData>> getAllFlocks() => select(flockTable).get();
  Future<void> upsertFlock(FlockTableCompanion flock) =>
      into(flockTable).insertOnConflictUpdate(flock);
  Future<void> deleteFlock(String id) =>
      (delete(flockTable)..where((t) => t.id.equals(id))).go();

  // ── Batch CRUD ─────────────────────────────────────────────────────────────
  Future<List<BatchTableData>> getAllBatches() => select(batchTable).get();
  Future<void> upsertBatch(BatchTableCompanion batch) =>
      into(batchTable).insertOnConflictUpdate(batch);
  Future<void> deleteBatch(String id) =>
      (delete(batchTable)..where((t) => t.id.equals(id))).go();

  // ── Egg Records ────────────────────────────────────────────────────────────
  Future<List<EggRecordTableData>> getAllEggRecords() =>
      (select(eggRecordTable)
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();
  Future<void> upsertEggRecord(EggRecordTableCompanion r) =>
      into(eggRecordTable).insertOnConflictUpdate(r);
  Future<void> deleteEggRecord(String id) =>
      (delete(eggRecordTable)..where((t) => t.id.equals(id))).go();

  // ── Egg Sales ──────────────────────────────────────────────────────────────
  Future<List<EggSaleTableData>> getAllEggSales() =>
      (select(eggSaleTable)
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();
  Future<void> upsertEggSale(EggSaleTableCompanion s) =>
      into(eggSaleTable).insertOnConflictUpdate(s);

  // ── Feed Types ─────────────────────────────────────────────────────────────
  Future<List<FeedTypeTableData>> getAllFeedTypes() =>
      select(feedTypeTable).get();
  Future<void> upsertFeedType(FeedTypeTableCompanion ft) =>
      into(feedTypeTable).insertOnConflictUpdate(ft);
  Future<void> deleteFeedType(String id) =>
      (delete(feedTypeTable)..where((t) => t.id.equals(id))).go();

  // ── Feed Logs ──────────────────────────────────────────────────────────────
  Future<List<FeedLogTableData>> getAllFeedLogs() =>
      (select(feedLogTable)
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();
  Future<void> upsertFeedLog(FeedLogTableCompanion log) =>
      into(feedLogTable).insertOnConflictUpdate(log);
  Future<void> deleteFeedLog(String id) =>
      (delete(feedLogTable)..where((t) => t.id.equals(id))).go();

  // ── Health Records ─────────────────────────────────────────────────────────
  Future<List<HealthRecordTableData>> getAllHealthRecords() =>
      (select(healthRecordTable)
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();
  Future<void> upsertHealthRecord(HealthRecordTableCompanion r) =>
      into(healthRecordTable).insertOnConflictUpdate(r);
  Future<void> deleteHealthRecord(String id) =>
      (delete(healthRecordTable)..where((t) => t.id.equals(id))).go();

  // ── Vaccination Schedule ───────────────────────────────────────────────────
  Future<List<VaccinationScheduleTableData>> getAllVaccinationSchedules() =>
      (select(vaccinationScheduleTable)
            ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]))
          .get();
  Future<void> upsertVaccinationSchedule(
          VaccinationScheduleTableCompanion s) =>
      into(vaccinationScheduleTable).insertOnConflictUpdate(s);
  Future<void> deleteVaccinationSchedule(String id) =>
      (delete(vaccinationScheduleTable)..where((t) => t.id.equals(id))).go();

  // ── Medicine Stock ─────────────────────────────────────────────────────────
  Future<List<MedicineStockTableData>> getAllMedicineStock() =>
      select(medicineStockTable).get();
  Future<void> upsertMedicineStock(MedicineStockTableCompanion m) =>
      into(medicineStockTable).insertOnConflictUpdate(m);
  Future<void> deleteMedicineStock(String id) =>
      (delete(medicineStockTable)..where((t) => t.id.equals(id))).go();

  // ── Finance Transactions ───────────────────────────────────────────────────
  Future<List<FinanceTransactionTableData>> getAllTransactions() =>
      (select(financeTransactionTable)
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();
  Future<void> upsertTransaction(FinanceTransactionTableCompanion t) =>
      into(financeTransactionTable).insertOnConflictUpdate(t);
  Future<void> deleteTransaction(String id) =>
      (delete(financeTransactionTable)..where((t) => t.id.equals(id))).go();

  // ── Clear all (factory reset) ──────────────────────────────────────────────
  Future<void> clearAllData() async {
    await delete(flockTable).go();
    await delete(batchTable).go();
    await delete(eggRecordTable).go();
    await delete(eggSaleTable).go();
    await delete(feedTypeTable).go();
    await delete(feedLogTable).go();
    await delete(healthRecordTable).go();
    await delete(vaccinationScheduleTable).go();
    await delete(medicineStockTable).go();
    await delete(financeTransactionTable).go();
  }
}

// ── DB Connection ─────────────────────────────────────────────────────────────
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kukula_farm.sqlite'));
    return NativeDatabase(file);
  });
}

// ── Singleton provider ────────────────────────────────────────────────────────
AppDatabase? _dbInstance;
AppDatabase get appDb => _dbInstance ??= AppDatabase();
