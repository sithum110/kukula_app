// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FlockTableTable extends FlockTable
    with TableInfo<$FlockTableTable, FlockTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlockTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _breedMeta = const VerificationMeta('breed');
  @override
  late final GeneratedColumn<String> breed = GeneratedColumn<String>(
      'breed', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purposeMeta =
      const VerificationMeta('purpose');
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
      'purpose', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentCountMeta =
      const VerificationMeta('currentCount');
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
      'current_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _initialCountMeta =
      const VerificationMeta('initialCount');
  @override
  late final GeneratedColumn<int> initialCount = GeneratedColumn<int>(
      'initial_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _penMeta = const VerificationMeta('pen');
  @override
  late final GeneratedColumn<String> pen = GeneratedColumn<String>(
      'pen', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _arrivalDateMeta =
      const VerificationMeta('arrivalDate');
  @override
  late final GeneratedColumn<DateTime> arrivalDate = GeneratedColumn<DateTime>(
      'arrival_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        name,
        breed,
        purpose,
        currentCount,
        initialCount,
        pen,
        arrivalDate,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flock_table';
  @override
  VerificationContext validateIntegrity(Insertable<FlockTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('breed')) {
      context.handle(
          _breedMeta, breed.isAcceptableOrUnknown(data['breed']!, _breedMeta));
    }
    if (data.containsKey('purpose')) {
      context.handle(_purposeMeta,
          purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta));
    } else if (isInserting) {
      context.missing(_purposeMeta);
    }
    if (data.containsKey('current_count')) {
      context.handle(
          _currentCountMeta,
          currentCount.isAcceptableOrUnknown(
              data['current_count']!, _currentCountMeta));
    } else if (isInserting) {
      context.missing(_currentCountMeta);
    }
    if (data.containsKey('initial_count')) {
      context.handle(
          _initialCountMeta,
          initialCount.isAcceptableOrUnknown(
              data['initial_count']!, _initialCountMeta));
    } else if (isInserting) {
      context.missing(_initialCountMeta);
    }
    if (data.containsKey('pen')) {
      context.handle(
          _penMeta, pen.isAcceptableOrUnknown(data['pen']!, _penMeta));
    }
    if (data.containsKey('arrival_date')) {
      context.handle(
          _arrivalDateMeta,
          arrivalDate.isAcceptableOrUnknown(
              data['arrival_date']!, _arrivalDateMeta));
    } else if (isInserting) {
      context.missing(_arrivalDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlockTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlockTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      breed: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}breed']),
      purpose: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purpose'])!,
      currentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_count'])!,
      initialCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}initial_count'])!,
      pen: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pen']),
      arrivalDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}arrival_date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FlockTableTable createAlias(String alias) {
    return $FlockTableTable(attachedDatabase, alias);
  }
}

class FlockTableData extends DataClass implements Insertable<FlockTableData> {
  final String id;
  final String farmId;
  final String name;
  final String? breed;
  final String purpose;
  final int currentCount;
  final int initialCount;
  final String? pen;
  final DateTime arrivalDate;
  final String status;
  final DateTime createdAt;
  const FlockTableData(
      {required this.id,
      required this.farmId,
      required this.name,
      this.breed,
      required this.purpose,
      required this.currentCount,
      required this.initialCount,
      this.pen,
      required this.arrivalDate,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || breed != null) {
      map['breed'] = Variable<String>(breed);
    }
    map['purpose'] = Variable<String>(purpose);
    map['current_count'] = Variable<int>(currentCount);
    map['initial_count'] = Variable<int>(initialCount);
    if (!nullToAbsent || pen != null) {
      map['pen'] = Variable<String>(pen);
    }
    map['arrival_date'] = Variable<DateTime>(arrivalDate);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FlockTableCompanion toCompanion(bool nullToAbsent) {
    return FlockTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      name: Value(name),
      breed:
          breed == null && nullToAbsent ? const Value.absent() : Value(breed),
      purpose: Value(purpose),
      currentCount: Value(currentCount),
      initialCount: Value(initialCount),
      pen: pen == null && nullToAbsent ? const Value.absent() : Value(pen),
      arrivalDate: Value(arrivalDate),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory FlockTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlockTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      name: serializer.fromJson<String>(json['name']),
      breed: serializer.fromJson<String?>(json['breed']),
      purpose: serializer.fromJson<String>(json['purpose']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      initialCount: serializer.fromJson<int>(json['initialCount']),
      pen: serializer.fromJson<String?>(json['pen']),
      arrivalDate: serializer.fromJson<DateTime>(json['arrivalDate']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'name': serializer.toJson<String>(name),
      'breed': serializer.toJson<String?>(breed),
      'purpose': serializer.toJson<String>(purpose),
      'currentCount': serializer.toJson<int>(currentCount),
      'initialCount': serializer.toJson<int>(initialCount),
      'pen': serializer.toJson<String?>(pen),
      'arrivalDate': serializer.toJson<DateTime>(arrivalDate),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FlockTableData copyWith(
          {String? id,
          String? farmId,
          String? name,
          Value<String?> breed = const Value.absent(),
          String? purpose,
          int? currentCount,
          int? initialCount,
          Value<String?> pen = const Value.absent(),
          DateTime? arrivalDate,
          String? status,
          DateTime? createdAt}) =>
      FlockTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        name: name ?? this.name,
        breed: breed.present ? breed.value : this.breed,
        purpose: purpose ?? this.purpose,
        currentCount: currentCount ?? this.currentCount,
        initialCount: initialCount ?? this.initialCount,
        pen: pen.present ? pen.value : this.pen,
        arrivalDate: arrivalDate ?? this.arrivalDate,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  FlockTableData copyWithCompanion(FlockTableCompanion data) {
    return FlockTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      name: data.name.present ? data.name.value : this.name,
      breed: data.breed.present ? data.breed.value : this.breed,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      currentCount: data.currentCount.present
          ? data.currentCount.value
          : this.currentCount,
      initialCount: data.initialCount.present
          ? data.initialCount.value
          : this.initialCount,
      pen: data.pen.present ? data.pen.value : this.pen,
      arrivalDate:
          data.arrivalDate.present ? data.arrivalDate.value : this.arrivalDate,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlockTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('breed: $breed, ')
          ..write('purpose: $purpose, ')
          ..write('currentCount: $currentCount, ')
          ..write('initialCount: $initialCount, ')
          ..write('pen: $pen, ')
          ..write('arrivalDate: $arrivalDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, farmId, name, breed, purpose,
      currentCount, initialCount, pen, arrivalDate, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlockTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.name == this.name &&
          other.breed == this.breed &&
          other.purpose == this.purpose &&
          other.currentCount == this.currentCount &&
          other.initialCount == this.initialCount &&
          other.pen == this.pen &&
          other.arrivalDate == this.arrivalDate &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class FlockTableCompanion extends UpdateCompanion<FlockTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> name;
  final Value<String?> breed;
  final Value<String> purpose;
  final Value<int> currentCount;
  final Value<int> initialCount;
  final Value<String?> pen;
  final Value<DateTime> arrivalDate;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FlockTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.name = const Value.absent(),
    this.breed = const Value.absent(),
    this.purpose = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.initialCount = const Value.absent(),
    this.pen = const Value.absent(),
    this.arrivalDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FlockTableCompanion.insert({
    required String id,
    required String farmId,
    required String name,
    this.breed = const Value.absent(),
    required String purpose,
    required int currentCount,
    required int initialCount,
    this.pen = const Value.absent(),
    required DateTime arrivalDate,
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        name = Value(name),
        purpose = Value(purpose),
        currentCount = Value(currentCount),
        initialCount = Value(initialCount),
        arrivalDate = Value(arrivalDate),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<FlockTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? name,
    Expression<String>? breed,
    Expression<String>? purpose,
    Expression<int>? currentCount,
    Expression<int>? initialCount,
    Expression<String>? pen,
    Expression<DateTime>? arrivalDate,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (name != null) 'name': name,
      if (breed != null) 'breed': breed,
      if (purpose != null) 'purpose': purpose,
      if (currentCount != null) 'current_count': currentCount,
      if (initialCount != null) 'initial_count': initialCount,
      if (pen != null) 'pen': pen,
      if (arrivalDate != null) 'arrival_date': arrivalDate,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FlockTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? name,
      Value<String?>? breed,
      Value<String>? purpose,
      Value<int>? currentCount,
      Value<int>? initialCount,
      Value<String?>? pen,
      Value<DateTime>? arrivalDate,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FlockTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      purpose: purpose ?? this.purpose,
      currentCount: currentCount ?? this.currentCount,
      initialCount: initialCount ?? this.initialCount,
      pen: pen ?? this.pen,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (breed.present) {
      map['breed'] = Variable<String>(breed.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (initialCount.present) {
      map['initial_count'] = Variable<int>(initialCount.value);
    }
    if (pen.present) {
      map['pen'] = Variable<String>(pen.value);
    }
    if (arrivalDate.present) {
      map['arrival_date'] = Variable<DateTime>(arrivalDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlockTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('breed: $breed, ')
          ..write('purpose: $purpose, ')
          ..write('currentCount: $currentCount, ')
          ..write('initialCount: $initialCount, ')
          ..write('pen: $pen, ')
          ..write('arrivalDate: $arrivalDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BatchTableTable extends BatchTable
    with TableInfo<$BatchTableTable, BatchTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatchTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _breedMeta = const VerificationMeta('breed');
  @override
  late final GeneratedColumn<String> breed = GeneratedColumn<String>(
      'breed', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _arrivalDateMeta =
      const VerificationMeta('arrivalDate');
  @override
  late final GeneratedColumn<DateTime> arrivalDate = GeneratedColumn<DateTime>(
      'arrival_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _initialCountMeta =
      const VerificationMeta('initialCount');
  @override
  late final GeneratedColumn<int> initialCount = GeneratedColumn<int>(
      'initial_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentCountMeta =
      const VerificationMeta('currentCount');
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
      'current_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _supplierMeta =
      const VerificationMeta('supplier');
  @override
  late final GeneratedColumn<String> supplier = GeneratedColumn<String>(
      'supplier', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        name,
        breed,
        arrivalDate,
        initialCount,
        currentCount,
        supplier,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batch_table';
  @override
  VerificationContext validateIntegrity(Insertable<BatchTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('breed')) {
      context.handle(
          _breedMeta, breed.isAcceptableOrUnknown(data['breed']!, _breedMeta));
    }
    if (data.containsKey('arrival_date')) {
      context.handle(
          _arrivalDateMeta,
          arrivalDate.isAcceptableOrUnknown(
              data['arrival_date']!, _arrivalDateMeta));
    } else if (isInserting) {
      context.missing(_arrivalDateMeta);
    }
    if (data.containsKey('initial_count')) {
      context.handle(
          _initialCountMeta,
          initialCount.isAcceptableOrUnknown(
              data['initial_count']!, _initialCountMeta));
    } else if (isInserting) {
      context.missing(_initialCountMeta);
    }
    if (data.containsKey('current_count')) {
      context.handle(
          _currentCountMeta,
          currentCount.isAcceptableOrUnknown(
              data['current_count']!, _currentCountMeta));
    } else if (isInserting) {
      context.missing(_currentCountMeta);
    }
    if (data.containsKey('supplier')) {
      context.handle(_supplierMeta,
          supplier.isAcceptableOrUnknown(data['supplier']!, _supplierMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BatchTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BatchTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      breed: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}breed']),
      arrivalDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}arrival_date'])!,
      initialCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}initial_count'])!,
      currentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_count'])!,
      supplier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BatchTableTable createAlias(String alias) {
    return $BatchTableTable(attachedDatabase, alias);
  }
}

class BatchTableData extends DataClass implements Insertable<BatchTableData> {
  final String id;
  final String farmId;
  final String name;
  final String? breed;
  final DateTime arrivalDate;
  final int initialCount;
  final int currentCount;
  final String? supplier;
  final String status;
  final DateTime createdAt;
  const BatchTableData(
      {required this.id,
      required this.farmId,
      required this.name,
      this.breed,
      required this.arrivalDate,
      required this.initialCount,
      required this.currentCount,
      this.supplier,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || breed != null) {
      map['breed'] = Variable<String>(breed);
    }
    map['arrival_date'] = Variable<DateTime>(arrivalDate);
    map['initial_count'] = Variable<int>(initialCount);
    map['current_count'] = Variable<int>(currentCount);
    if (!nullToAbsent || supplier != null) {
      map['supplier'] = Variable<String>(supplier);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BatchTableCompanion toCompanion(bool nullToAbsent) {
    return BatchTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      name: Value(name),
      breed:
          breed == null && nullToAbsent ? const Value.absent() : Value(breed),
      arrivalDate: Value(arrivalDate),
      initialCount: Value(initialCount),
      currentCount: Value(currentCount),
      supplier: supplier == null && nullToAbsent
          ? const Value.absent()
          : Value(supplier),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory BatchTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BatchTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      name: serializer.fromJson<String>(json['name']),
      breed: serializer.fromJson<String?>(json['breed']),
      arrivalDate: serializer.fromJson<DateTime>(json['arrivalDate']),
      initialCount: serializer.fromJson<int>(json['initialCount']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      supplier: serializer.fromJson<String?>(json['supplier']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'name': serializer.toJson<String>(name),
      'breed': serializer.toJson<String?>(breed),
      'arrivalDate': serializer.toJson<DateTime>(arrivalDate),
      'initialCount': serializer.toJson<int>(initialCount),
      'currentCount': serializer.toJson<int>(currentCount),
      'supplier': serializer.toJson<String?>(supplier),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BatchTableData copyWith(
          {String? id,
          String? farmId,
          String? name,
          Value<String?> breed = const Value.absent(),
          DateTime? arrivalDate,
          int? initialCount,
          int? currentCount,
          Value<String?> supplier = const Value.absent(),
          String? status,
          DateTime? createdAt}) =>
      BatchTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        name: name ?? this.name,
        breed: breed.present ? breed.value : this.breed,
        arrivalDate: arrivalDate ?? this.arrivalDate,
        initialCount: initialCount ?? this.initialCount,
        currentCount: currentCount ?? this.currentCount,
        supplier: supplier.present ? supplier.value : this.supplier,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  BatchTableData copyWithCompanion(BatchTableCompanion data) {
    return BatchTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      name: data.name.present ? data.name.value : this.name,
      breed: data.breed.present ? data.breed.value : this.breed,
      arrivalDate:
          data.arrivalDate.present ? data.arrivalDate.value : this.arrivalDate,
      initialCount: data.initialCount.present
          ? data.initialCount.value
          : this.initialCount,
      currentCount: data.currentCount.present
          ? data.currentCount.value
          : this.currentCount,
      supplier: data.supplier.present ? data.supplier.value : this.supplier,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BatchTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('breed: $breed, ')
          ..write('arrivalDate: $arrivalDate, ')
          ..write('initialCount: $initialCount, ')
          ..write('currentCount: $currentCount, ')
          ..write('supplier: $supplier, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, farmId, name, breed, arrivalDate,
      initialCount, currentCount, supplier, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BatchTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.name == this.name &&
          other.breed == this.breed &&
          other.arrivalDate == this.arrivalDate &&
          other.initialCount == this.initialCount &&
          other.currentCount == this.currentCount &&
          other.supplier == this.supplier &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class BatchTableCompanion extends UpdateCompanion<BatchTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> name;
  final Value<String?> breed;
  final Value<DateTime> arrivalDate;
  final Value<int> initialCount;
  final Value<int> currentCount;
  final Value<String?> supplier;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BatchTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.name = const Value.absent(),
    this.breed = const Value.absent(),
    this.arrivalDate = const Value.absent(),
    this.initialCount = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.supplier = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BatchTableCompanion.insert({
    required String id,
    required String farmId,
    required String name,
    this.breed = const Value.absent(),
    required DateTime arrivalDate,
    required int initialCount,
    required int currentCount,
    this.supplier = const Value.absent(),
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        name = Value(name),
        arrivalDate = Value(arrivalDate),
        initialCount = Value(initialCount),
        currentCount = Value(currentCount),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<BatchTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? name,
    Expression<String>? breed,
    Expression<DateTime>? arrivalDate,
    Expression<int>? initialCount,
    Expression<int>? currentCount,
    Expression<String>? supplier,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (name != null) 'name': name,
      if (breed != null) 'breed': breed,
      if (arrivalDate != null) 'arrival_date': arrivalDate,
      if (initialCount != null) 'initial_count': initialCount,
      if (currentCount != null) 'current_count': currentCount,
      if (supplier != null) 'supplier': supplier,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BatchTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? name,
      Value<String?>? breed,
      Value<DateTime>? arrivalDate,
      Value<int>? initialCount,
      Value<int>? currentCount,
      Value<String?>? supplier,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return BatchTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      initialCount: initialCount ?? this.initialCount,
      currentCount: currentCount ?? this.currentCount,
      supplier: supplier ?? this.supplier,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (breed.present) {
      map['breed'] = Variable<String>(breed.value);
    }
    if (arrivalDate.present) {
      map['arrival_date'] = Variable<DateTime>(arrivalDate.value);
    }
    if (initialCount.present) {
      map['initial_count'] = Variable<int>(initialCount.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (supplier.present) {
      map['supplier'] = Variable<String>(supplier.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatchTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('breed: $breed, ')
          ..write('arrivalDate: $arrivalDate, ')
          ..write('initialCount: $initialCount, ')
          ..write('currentCount: $currentCount, ')
          ..write('supplier: $supplier, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EggRecordTableTable extends EggRecordTable
    with TableInfo<$EggRecordTableTable, EggRecordTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EggRecordTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _flockIdMeta =
      const VerificationMeta('flockId');
  @override
  late final GeneratedColumn<String> flockId = GeneratedColumn<String>(
      'flock_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalEggsMeta =
      const VerificationMeta('totalEggs');
  @override
  late final GeneratedColumn<int> totalEggs = GeneratedColumn<int>(
      'total_eggs', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _brokenEggsMeta =
      const VerificationMeta('brokenEggs');
  @override
  late final GeneratedColumn<int> brokenEggs = GeneratedColumn<int>(
      'broken_eggs', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _gradeAMeta = const VerificationMeta('gradeA');
  @override
  late final GeneratedColumn<int> gradeA = GeneratedColumn<int>(
      'grade_a', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _gradeBMeta = const VerificationMeta('gradeB');
  @override
  late final GeneratedColumn<int> gradeB = GeneratedColumn<int>(
      'grade_b', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _gradeCMeta = const VerificationMeta('gradeC');
  @override
  late final GeneratedColumn<int> gradeC = GeneratedColumn<int>(
      'grade_c', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _collectedByMeta =
      const VerificationMeta('collectedBy');
  @override
  late final GeneratedColumn<String> collectedBy = GeneratedColumn<String>(
      'collected_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        flockId,
        date,
        totalEggs,
        brokenEggs,
        gradeA,
        gradeB,
        gradeC,
        collectedBy,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'egg_record_table';
  @override
  VerificationContext validateIntegrity(Insertable<EggRecordTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('flock_id')) {
      context.handle(_flockIdMeta,
          flockId.isAcceptableOrUnknown(data['flock_id']!, _flockIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_eggs')) {
      context.handle(_totalEggsMeta,
          totalEggs.isAcceptableOrUnknown(data['total_eggs']!, _totalEggsMeta));
    } else if (isInserting) {
      context.missing(_totalEggsMeta);
    }
    if (data.containsKey('broken_eggs')) {
      context.handle(
          _brokenEggsMeta,
          brokenEggs.isAcceptableOrUnknown(
              data['broken_eggs']!, _brokenEggsMeta));
    }
    if (data.containsKey('grade_a')) {
      context.handle(_gradeAMeta,
          gradeA.isAcceptableOrUnknown(data['grade_a']!, _gradeAMeta));
    }
    if (data.containsKey('grade_b')) {
      context.handle(_gradeBMeta,
          gradeB.isAcceptableOrUnknown(data['grade_b']!, _gradeBMeta));
    }
    if (data.containsKey('grade_c')) {
      context.handle(_gradeCMeta,
          gradeC.isAcceptableOrUnknown(data['grade_c']!, _gradeCMeta));
    }
    if (data.containsKey('collected_by')) {
      context.handle(
          _collectedByMeta,
          collectedBy.isAcceptableOrUnknown(
              data['collected_by']!, _collectedByMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EggRecordTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EggRecordTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      flockId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flock_id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      totalEggs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_eggs'])!,
      brokenEggs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}broken_eggs'])!,
      gradeA: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade_a']),
      gradeB: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade_b']),
      gradeC: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade_c']),
      collectedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}collected_by']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EggRecordTableTable createAlias(String alias) {
    return $EggRecordTableTable(attachedDatabase, alias);
  }
}

class EggRecordTableData extends DataClass
    implements Insertable<EggRecordTableData> {
  final String id;
  final String farmId;
  final String? flockId;
  final DateTime date;
  final int totalEggs;
  final int brokenEggs;
  final int? gradeA;
  final int? gradeB;
  final int? gradeC;
  final String? collectedBy;
  final DateTime createdAt;
  const EggRecordTableData(
      {required this.id,
      required this.farmId,
      this.flockId,
      required this.date,
      required this.totalEggs,
      required this.brokenEggs,
      this.gradeA,
      this.gradeB,
      this.gradeC,
      this.collectedBy,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    if (!nullToAbsent || flockId != null) {
      map['flock_id'] = Variable<String>(flockId);
    }
    map['date'] = Variable<DateTime>(date);
    map['total_eggs'] = Variable<int>(totalEggs);
    map['broken_eggs'] = Variable<int>(brokenEggs);
    if (!nullToAbsent || gradeA != null) {
      map['grade_a'] = Variable<int>(gradeA);
    }
    if (!nullToAbsent || gradeB != null) {
      map['grade_b'] = Variable<int>(gradeB);
    }
    if (!nullToAbsent || gradeC != null) {
      map['grade_c'] = Variable<int>(gradeC);
    }
    if (!nullToAbsent || collectedBy != null) {
      map['collected_by'] = Variable<String>(collectedBy);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EggRecordTableCompanion toCompanion(bool nullToAbsent) {
    return EggRecordTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      flockId: flockId == null && nullToAbsent
          ? const Value.absent()
          : Value(flockId),
      date: Value(date),
      totalEggs: Value(totalEggs),
      brokenEggs: Value(brokenEggs),
      gradeA:
          gradeA == null && nullToAbsent ? const Value.absent() : Value(gradeA),
      gradeB:
          gradeB == null && nullToAbsent ? const Value.absent() : Value(gradeB),
      gradeC:
          gradeC == null && nullToAbsent ? const Value.absent() : Value(gradeC),
      collectedBy: collectedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(collectedBy),
      createdAt: Value(createdAt),
    );
  }

  factory EggRecordTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EggRecordTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      flockId: serializer.fromJson<String?>(json['flockId']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalEggs: serializer.fromJson<int>(json['totalEggs']),
      brokenEggs: serializer.fromJson<int>(json['brokenEggs']),
      gradeA: serializer.fromJson<int?>(json['gradeA']),
      gradeB: serializer.fromJson<int?>(json['gradeB']),
      gradeC: serializer.fromJson<int?>(json['gradeC']),
      collectedBy: serializer.fromJson<String?>(json['collectedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'flockId': serializer.toJson<String?>(flockId),
      'date': serializer.toJson<DateTime>(date),
      'totalEggs': serializer.toJson<int>(totalEggs),
      'brokenEggs': serializer.toJson<int>(brokenEggs),
      'gradeA': serializer.toJson<int?>(gradeA),
      'gradeB': serializer.toJson<int?>(gradeB),
      'gradeC': serializer.toJson<int?>(gradeC),
      'collectedBy': serializer.toJson<String?>(collectedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EggRecordTableData copyWith(
          {String? id,
          String? farmId,
          Value<String?> flockId = const Value.absent(),
          DateTime? date,
          int? totalEggs,
          int? brokenEggs,
          Value<int?> gradeA = const Value.absent(),
          Value<int?> gradeB = const Value.absent(),
          Value<int?> gradeC = const Value.absent(),
          Value<String?> collectedBy = const Value.absent(),
          DateTime? createdAt}) =>
      EggRecordTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        flockId: flockId.present ? flockId.value : this.flockId,
        date: date ?? this.date,
        totalEggs: totalEggs ?? this.totalEggs,
        brokenEggs: brokenEggs ?? this.brokenEggs,
        gradeA: gradeA.present ? gradeA.value : this.gradeA,
        gradeB: gradeB.present ? gradeB.value : this.gradeB,
        gradeC: gradeC.present ? gradeC.value : this.gradeC,
        collectedBy: collectedBy.present ? collectedBy.value : this.collectedBy,
        createdAt: createdAt ?? this.createdAt,
      );
  EggRecordTableData copyWithCompanion(EggRecordTableCompanion data) {
    return EggRecordTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      flockId: data.flockId.present ? data.flockId.value : this.flockId,
      date: data.date.present ? data.date.value : this.date,
      totalEggs: data.totalEggs.present ? data.totalEggs.value : this.totalEggs,
      brokenEggs:
          data.brokenEggs.present ? data.brokenEggs.value : this.brokenEggs,
      gradeA: data.gradeA.present ? data.gradeA.value : this.gradeA,
      gradeB: data.gradeB.present ? data.gradeB.value : this.gradeB,
      gradeC: data.gradeC.present ? data.gradeC.value : this.gradeC,
      collectedBy:
          data.collectedBy.present ? data.collectedBy.value : this.collectedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EggRecordTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('flockId: $flockId, ')
          ..write('date: $date, ')
          ..write('totalEggs: $totalEggs, ')
          ..write('brokenEggs: $brokenEggs, ')
          ..write('gradeA: $gradeA, ')
          ..write('gradeB: $gradeB, ')
          ..write('gradeC: $gradeC, ')
          ..write('collectedBy: $collectedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, farmId, flockId, date, totalEggs,
      brokenEggs, gradeA, gradeB, gradeC, collectedBy, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EggRecordTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.flockId == this.flockId &&
          other.date == this.date &&
          other.totalEggs == this.totalEggs &&
          other.brokenEggs == this.brokenEggs &&
          other.gradeA == this.gradeA &&
          other.gradeB == this.gradeB &&
          other.gradeC == this.gradeC &&
          other.collectedBy == this.collectedBy &&
          other.createdAt == this.createdAt);
}

class EggRecordTableCompanion extends UpdateCompanion<EggRecordTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String?> flockId;
  final Value<DateTime> date;
  final Value<int> totalEggs;
  final Value<int> brokenEggs;
  final Value<int?> gradeA;
  final Value<int?> gradeB;
  final Value<int?> gradeC;
  final Value<String?> collectedBy;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EggRecordTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.flockId = const Value.absent(),
    this.date = const Value.absent(),
    this.totalEggs = const Value.absent(),
    this.brokenEggs = const Value.absent(),
    this.gradeA = const Value.absent(),
    this.gradeB = const Value.absent(),
    this.gradeC = const Value.absent(),
    this.collectedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EggRecordTableCompanion.insert({
    required String id,
    required String farmId,
    this.flockId = const Value.absent(),
    required DateTime date,
    required int totalEggs,
    this.brokenEggs = const Value.absent(),
    this.gradeA = const Value.absent(),
    this.gradeB = const Value.absent(),
    this.gradeC = const Value.absent(),
    this.collectedBy = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        date = Value(date),
        totalEggs = Value(totalEggs),
        createdAt = Value(createdAt);
  static Insertable<EggRecordTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? flockId,
    Expression<DateTime>? date,
    Expression<int>? totalEggs,
    Expression<int>? brokenEggs,
    Expression<int>? gradeA,
    Expression<int>? gradeB,
    Expression<int>? gradeC,
    Expression<String>? collectedBy,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (flockId != null) 'flock_id': flockId,
      if (date != null) 'date': date,
      if (totalEggs != null) 'total_eggs': totalEggs,
      if (brokenEggs != null) 'broken_eggs': brokenEggs,
      if (gradeA != null) 'grade_a': gradeA,
      if (gradeB != null) 'grade_b': gradeB,
      if (gradeC != null) 'grade_c': gradeC,
      if (collectedBy != null) 'collected_by': collectedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EggRecordTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String?>? flockId,
      Value<DateTime>? date,
      Value<int>? totalEggs,
      Value<int>? brokenEggs,
      Value<int?>? gradeA,
      Value<int?>? gradeB,
      Value<int?>? gradeC,
      Value<String?>? collectedBy,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return EggRecordTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      flockId: flockId ?? this.flockId,
      date: date ?? this.date,
      totalEggs: totalEggs ?? this.totalEggs,
      brokenEggs: brokenEggs ?? this.brokenEggs,
      gradeA: gradeA ?? this.gradeA,
      gradeB: gradeB ?? this.gradeB,
      gradeC: gradeC ?? this.gradeC,
      collectedBy: collectedBy ?? this.collectedBy,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (flockId.present) {
      map['flock_id'] = Variable<String>(flockId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalEggs.present) {
      map['total_eggs'] = Variable<int>(totalEggs.value);
    }
    if (brokenEggs.present) {
      map['broken_eggs'] = Variable<int>(brokenEggs.value);
    }
    if (gradeA.present) {
      map['grade_a'] = Variable<int>(gradeA.value);
    }
    if (gradeB.present) {
      map['grade_b'] = Variable<int>(gradeB.value);
    }
    if (gradeC.present) {
      map['grade_c'] = Variable<int>(gradeC.value);
    }
    if (collectedBy.present) {
      map['collected_by'] = Variable<String>(collectedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EggRecordTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('flockId: $flockId, ')
          ..write('date: $date, ')
          ..write('totalEggs: $totalEggs, ')
          ..write('brokenEggs: $brokenEggs, ')
          ..write('gradeA: $gradeA, ')
          ..write('gradeB: $gradeB, ')
          ..write('gradeC: $gradeC, ')
          ..write('collectedBy: $collectedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EggSaleTableTable extends EggSaleTable
    with TableInfo<$EggSaleTableTable, EggSaleTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EggSaleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saleTypeMeta =
      const VerificationMeta('saleType');
  @override
  late final GeneratedColumn<String> saleType = GeneratedColumn<String>(
      'sale_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pricePerUnitMeta =
      const VerificationMeta('pricePerUnit');
  @override
  late final GeneratedColumn<double> pricePerUnit = GeneratedColumn<double>(
      'price_per_unit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _buyerNameMeta =
      const VerificationMeta('buyerName');
  @override
  late final GeneratedColumn<String> buyerName = GeneratedColumn<String>(
      'buyer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        saleType,
        quantity,
        pricePerUnit,
        totalAmount,
        buyerName,
        date
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'egg_sale_table';
  @override
  VerificationContext validateIntegrity(Insertable<EggSaleTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('sale_type')) {
      context.handle(_saleTypeMeta,
          saleType.isAcceptableOrUnknown(data['sale_type']!, _saleTypeMeta));
    } else if (isInserting) {
      context.missing(_saleTypeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price_per_unit')) {
      context.handle(
          _pricePerUnitMeta,
          pricePerUnit.isAcceptableOrUnknown(
              data['price_per_unit']!, _pricePerUnitMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    }
    if (data.containsKey('buyer_name')) {
      context.handle(_buyerNameMeta,
          buyerName.isAcceptableOrUnknown(data['buyer_name']!, _buyerNameMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EggSaleTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EggSaleTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      saleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_type'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      pricePerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_per_unit']),
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount']),
      buyerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}buyer_name']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $EggSaleTableTable createAlias(String alias) {
    return $EggSaleTableTable(attachedDatabase, alias);
  }
}

class EggSaleTableData extends DataClass
    implements Insertable<EggSaleTableData> {
  final String id;
  final String farmId;
  final String saleType;
  final int quantity;
  final double? pricePerUnit;
  final double? totalAmount;
  final String? buyerName;
  final DateTime date;
  const EggSaleTableData(
      {required this.id,
      required this.farmId,
      required this.saleType,
      required this.quantity,
      this.pricePerUnit,
      this.totalAmount,
      this.buyerName,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['sale_type'] = Variable<String>(saleType);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || pricePerUnit != null) {
      map['price_per_unit'] = Variable<double>(pricePerUnit);
    }
    if (!nullToAbsent || totalAmount != null) {
      map['total_amount'] = Variable<double>(totalAmount);
    }
    if (!nullToAbsent || buyerName != null) {
      map['buyer_name'] = Variable<String>(buyerName);
    }
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  EggSaleTableCompanion toCompanion(bool nullToAbsent) {
    return EggSaleTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      saleType: Value(saleType),
      quantity: Value(quantity),
      pricePerUnit: pricePerUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerUnit),
      totalAmount: totalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmount),
      buyerName: buyerName == null && nullToAbsent
          ? const Value.absent()
          : Value(buyerName),
      date: Value(date),
    );
  }

  factory EggSaleTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EggSaleTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      saleType: serializer.fromJson<String>(json['saleType']),
      quantity: serializer.fromJson<int>(json['quantity']),
      pricePerUnit: serializer.fromJson<double?>(json['pricePerUnit']),
      totalAmount: serializer.fromJson<double?>(json['totalAmount']),
      buyerName: serializer.fromJson<String?>(json['buyerName']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'saleType': serializer.toJson<String>(saleType),
      'quantity': serializer.toJson<int>(quantity),
      'pricePerUnit': serializer.toJson<double?>(pricePerUnit),
      'totalAmount': serializer.toJson<double?>(totalAmount),
      'buyerName': serializer.toJson<String?>(buyerName),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  EggSaleTableData copyWith(
          {String? id,
          String? farmId,
          String? saleType,
          int? quantity,
          Value<double?> pricePerUnit = const Value.absent(),
          Value<double?> totalAmount = const Value.absent(),
          Value<String?> buyerName = const Value.absent(),
          DateTime? date}) =>
      EggSaleTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        saleType: saleType ?? this.saleType,
        quantity: quantity ?? this.quantity,
        pricePerUnit:
            pricePerUnit.present ? pricePerUnit.value : this.pricePerUnit,
        totalAmount: totalAmount.present ? totalAmount.value : this.totalAmount,
        buyerName: buyerName.present ? buyerName.value : this.buyerName,
        date: date ?? this.date,
      );
  EggSaleTableData copyWithCompanion(EggSaleTableCompanion data) {
    return EggSaleTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      saleType: data.saleType.present ? data.saleType.value : this.saleType,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      pricePerUnit: data.pricePerUnit.present
          ? data.pricePerUnit.value
          : this.pricePerUnit,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      buyerName: data.buyerName.present ? data.buyerName.value : this.buyerName,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EggSaleTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('saleType: $saleType, ')
          ..write('quantity: $quantity, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('buyerName: $buyerName, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, farmId, saleType, quantity, pricePerUnit,
      totalAmount, buyerName, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EggSaleTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.saleType == this.saleType &&
          other.quantity == this.quantity &&
          other.pricePerUnit == this.pricePerUnit &&
          other.totalAmount == this.totalAmount &&
          other.buyerName == this.buyerName &&
          other.date == this.date);
}

class EggSaleTableCompanion extends UpdateCompanion<EggSaleTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> saleType;
  final Value<int> quantity;
  final Value<double?> pricePerUnit;
  final Value<double?> totalAmount;
  final Value<String?> buyerName;
  final Value<DateTime> date;
  final Value<int> rowid;
  const EggSaleTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.saleType = const Value.absent(),
    this.quantity = const Value.absent(),
    this.pricePerUnit = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.buyerName = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EggSaleTableCompanion.insert({
    required String id,
    required String farmId,
    required String saleType,
    required int quantity,
    this.pricePerUnit = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.buyerName = const Value.absent(),
    required DateTime date,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        saleType = Value(saleType),
        quantity = Value(quantity),
        date = Value(date);
  static Insertable<EggSaleTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? saleType,
    Expression<int>? quantity,
    Expression<double>? pricePerUnit,
    Expression<double>? totalAmount,
    Expression<String>? buyerName,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (saleType != null) 'sale_type': saleType,
      if (quantity != null) 'quantity': quantity,
      if (pricePerUnit != null) 'price_per_unit': pricePerUnit,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (buyerName != null) 'buyer_name': buyerName,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EggSaleTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? saleType,
      Value<int>? quantity,
      Value<double?>? pricePerUnit,
      Value<double?>? totalAmount,
      Value<String?>? buyerName,
      Value<DateTime>? date,
      Value<int>? rowid}) {
    return EggSaleTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      saleType: saleType ?? this.saleType,
      quantity: quantity ?? this.quantity,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      totalAmount: totalAmount ?? this.totalAmount,
      buyerName: buyerName ?? this.buyerName,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (saleType.present) {
      map['sale_type'] = Variable<String>(saleType.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (pricePerUnit.present) {
      map['price_per_unit'] = Variable<double>(pricePerUnit.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (buyerName.present) {
      map['buyer_name'] = Variable<String>(buyerName.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EggSaleTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('saleType: $saleType, ')
          ..write('quantity: $quantity, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('buyerName: $buyerName, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeedTypeTableTable extends FeedTypeTable
    with TableInfo<$FeedTypeTableTable, FeedTypeTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedTypeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _forPurposeMeta =
      const VerificationMeta('forPurpose');
  @override
  late final GeneratedColumn<String> forPurpose = GeneratedColumn<String>(
      'for_purpose', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentStockKgMeta =
      const VerificationMeta('currentStockKg');
  @override
  late final GeneratedColumn<double> currentStockKg = GeneratedColumn<double>(
      'current_stock_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lowStockThresholdKgMeta =
      const VerificationMeta('lowStockThresholdKg');
  @override
  late final GeneratedColumn<double> lowStockThresholdKg =
      GeneratedColumn<double>('low_stock_threshold_kg', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pricePerKgMeta =
      const VerificationMeta('pricePerKg');
  @override
  late final GeneratedColumn<double> pricePerKg = GeneratedColumn<double>(
      'price_per_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        name,
        brand,
        forPurpose,
        currentStockKg,
        lowStockThresholdKg,
        pricePerKg,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feed_type_table';
  @override
  VerificationContext validateIntegrity(Insertable<FeedTypeTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('for_purpose')) {
      context.handle(
          _forPurposeMeta,
          forPurpose.isAcceptableOrUnknown(
              data['for_purpose']!, _forPurposeMeta));
    }
    if (data.containsKey('current_stock_kg')) {
      context.handle(
          _currentStockKgMeta,
          currentStockKg.isAcceptableOrUnknown(
              data['current_stock_kg']!, _currentStockKgMeta));
    } else if (isInserting) {
      context.missing(_currentStockKgMeta);
    }
    if (data.containsKey('low_stock_threshold_kg')) {
      context.handle(
          _lowStockThresholdKgMeta,
          lowStockThresholdKg.isAcceptableOrUnknown(
              data['low_stock_threshold_kg']!, _lowStockThresholdKgMeta));
    } else if (isInserting) {
      context.missing(_lowStockThresholdKgMeta);
    }
    if (data.containsKey('price_per_kg')) {
      context.handle(
          _pricePerKgMeta,
          pricePerKg.isAcceptableOrUnknown(
              data['price_per_kg']!, _pricePerKgMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedTypeTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedTypeTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      forPurpose: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}for_purpose']),
      currentStockKg: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}current_stock_kg'])!,
      lowStockThresholdKg: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}low_stock_threshold_kg'])!,
      pricePerKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_per_kg']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FeedTypeTableTable createAlias(String alias) {
    return $FeedTypeTableTable(attachedDatabase, alias);
  }
}

class FeedTypeTableData extends DataClass
    implements Insertable<FeedTypeTableData> {
  final String id;
  final String farmId;
  final String name;
  final String? brand;
  final String? forPurpose;
  final double currentStockKg;
  final double lowStockThresholdKg;
  final double? pricePerKg;
  final DateTime createdAt;
  const FeedTypeTableData(
      {required this.id,
      required this.farmId,
      required this.name,
      this.brand,
      this.forPurpose,
      required this.currentStockKg,
      required this.lowStockThresholdKg,
      this.pricePerKg,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || forPurpose != null) {
      map['for_purpose'] = Variable<String>(forPurpose);
    }
    map['current_stock_kg'] = Variable<double>(currentStockKg);
    map['low_stock_threshold_kg'] = Variable<double>(lowStockThresholdKg);
    if (!nullToAbsent || pricePerKg != null) {
      map['price_per_kg'] = Variable<double>(pricePerKg);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FeedTypeTableCompanion toCompanion(bool nullToAbsent) {
    return FeedTypeTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      name: Value(name),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      forPurpose: forPurpose == null && nullToAbsent
          ? const Value.absent()
          : Value(forPurpose),
      currentStockKg: Value(currentStockKg),
      lowStockThresholdKg: Value(lowStockThresholdKg),
      pricePerKg: pricePerKg == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerKg),
      createdAt: Value(createdAt),
    );
  }

  factory FeedTypeTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedTypeTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      forPurpose: serializer.fromJson<String?>(json['forPurpose']),
      currentStockKg: serializer.fromJson<double>(json['currentStockKg']),
      lowStockThresholdKg:
          serializer.fromJson<double>(json['lowStockThresholdKg']),
      pricePerKg: serializer.fromJson<double?>(json['pricePerKg']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'forPurpose': serializer.toJson<String?>(forPurpose),
      'currentStockKg': serializer.toJson<double>(currentStockKg),
      'lowStockThresholdKg': serializer.toJson<double>(lowStockThresholdKg),
      'pricePerKg': serializer.toJson<double?>(pricePerKg),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FeedTypeTableData copyWith(
          {String? id,
          String? farmId,
          String? name,
          Value<String?> brand = const Value.absent(),
          Value<String?> forPurpose = const Value.absent(),
          double? currentStockKg,
          double? lowStockThresholdKg,
          Value<double?> pricePerKg = const Value.absent(),
          DateTime? createdAt}) =>
      FeedTypeTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        name: name ?? this.name,
        brand: brand.present ? brand.value : this.brand,
        forPurpose: forPurpose.present ? forPurpose.value : this.forPurpose,
        currentStockKg: currentStockKg ?? this.currentStockKg,
        lowStockThresholdKg: lowStockThresholdKg ?? this.lowStockThresholdKg,
        pricePerKg: pricePerKg.present ? pricePerKg.value : this.pricePerKg,
        createdAt: createdAt ?? this.createdAt,
      );
  FeedTypeTableData copyWithCompanion(FeedTypeTableCompanion data) {
    return FeedTypeTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      forPurpose:
          data.forPurpose.present ? data.forPurpose.value : this.forPurpose,
      currentStockKg: data.currentStockKg.present
          ? data.currentStockKg.value
          : this.currentStockKg,
      lowStockThresholdKg: data.lowStockThresholdKg.present
          ? data.lowStockThresholdKg.value
          : this.lowStockThresholdKg,
      pricePerKg:
          data.pricePerKg.present ? data.pricePerKg.value : this.pricePerKg,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedTypeTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('forPurpose: $forPurpose, ')
          ..write('currentStockKg: $currentStockKg, ')
          ..write('lowStockThresholdKg: $lowStockThresholdKg, ')
          ..write('pricePerKg: $pricePerKg, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, farmId, name, brand, forPurpose,
      currentStockKg, lowStockThresholdKg, pricePerKg, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedTypeTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.forPurpose == this.forPurpose &&
          other.currentStockKg == this.currentStockKg &&
          other.lowStockThresholdKg == this.lowStockThresholdKg &&
          other.pricePerKg == this.pricePerKg &&
          other.createdAt == this.createdAt);
}

class FeedTypeTableCompanion extends UpdateCompanion<FeedTypeTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String?> forPurpose;
  final Value<double> currentStockKg;
  final Value<double> lowStockThresholdKg;
  final Value<double?> pricePerKg;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FeedTypeTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.forPurpose = const Value.absent(),
    this.currentStockKg = const Value.absent(),
    this.lowStockThresholdKg = const Value.absent(),
    this.pricePerKg = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeedTypeTableCompanion.insert({
    required String id,
    required String farmId,
    required String name,
    this.brand = const Value.absent(),
    this.forPurpose = const Value.absent(),
    required double currentStockKg,
    required double lowStockThresholdKg,
    this.pricePerKg = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        name = Value(name),
        currentStockKg = Value(currentStockKg),
        lowStockThresholdKg = Value(lowStockThresholdKg),
        createdAt = Value(createdAt);
  static Insertable<FeedTypeTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? forPurpose,
    Expression<double>? currentStockKg,
    Expression<double>? lowStockThresholdKg,
    Expression<double>? pricePerKg,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (forPurpose != null) 'for_purpose': forPurpose,
      if (currentStockKg != null) 'current_stock_kg': currentStockKg,
      if (lowStockThresholdKg != null)
        'low_stock_threshold_kg': lowStockThresholdKg,
      if (pricePerKg != null) 'price_per_kg': pricePerKg,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeedTypeTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? name,
      Value<String?>? brand,
      Value<String?>? forPurpose,
      Value<double>? currentStockKg,
      Value<double>? lowStockThresholdKg,
      Value<double?>? pricePerKg,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FeedTypeTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      forPurpose: forPurpose ?? this.forPurpose,
      currentStockKg: currentStockKg ?? this.currentStockKg,
      lowStockThresholdKg: lowStockThresholdKg ?? this.lowStockThresholdKg,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (forPurpose.present) {
      map['for_purpose'] = Variable<String>(forPurpose.value);
    }
    if (currentStockKg.present) {
      map['current_stock_kg'] = Variable<double>(currentStockKg.value);
    }
    if (lowStockThresholdKg.present) {
      map['low_stock_threshold_kg'] =
          Variable<double>(lowStockThresholdKg.value);
    }
    if (pricePerKg.present) {
      map['price_per_kg'] = Variable<double>(pricePerKg.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedTypeTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('forPurpose: $forPurpose, ')
          ..write('currentStockKg: $currentStockKg, ')
          ..write('lowStockThresholdKg: $lowStockThresholdKg, ')
          ..write('pricePerKg: $pricePerKg, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeedLogTableTable extends FeedLogTable
    with TableInfo<$FeedLogTableTable, FeedLogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedLogTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _feedTypeIdMeta =
      const VerificationMeta('feedTypeId');
  @override
  late final GeneratedColumn<String> feedTypeId = GeneratedColumn<String>(
      'feed_type_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _feedTypeNameMeta =
      const VerificationMeta('feedTypeName');
  @override
  late final GeneratedColumn<String> feedTypeName = GeneratedColumn<String>(
      'feed_type_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _flockIdMeta =
      const VerificationMeta('flockId');
  @override
  late final GeneratedColumn<String> flockId = GeneratedColumn<String>(
      'flock_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _flockNameMeta =
      const VerificationMeta('flockName');
  @override
  late final GeneratedColumn<String> flockName = GeneratedColumn<String>(
      'flock_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityKgMeta =
      const VerificationMeta('quantityKg');
  @override
  late final GeneratedColumn<double> quantityKg = GeneratedColumn<double>(
      'quantity_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costLKRMeta =
      const VerificationMeta('costLKR');
  @override
  late final GeneratedColumn<double> costLKR = GeneratedColumn<double>(
      'cost_l_k_r', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        feedTypeId,
        feedTypeName,
        flockId,
        flockName,
        quantityKg,
        costLKR,
        date,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feed_log_table';
  @override
  VerificationContext validateIntegrity(Insertable<FeedLogTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('feed_type_id')) {
      context.handle(
          _feedTypeIdMeta,
          feedTypeId.isAcceptableOrUnknown(
              data['feed_type_id']!, _feedTypeIdMeta));
    } else if (isInserting) {
      context.missing(_feedTypeIdMeta);
    }
    if (data.containsKey('feed_type_name')) {
      context.handle(
          _feedTypeNameMeta,
          feedTypeName.isAcceptableOrUnknown(
              data['feed_type_name']!, _feedTypeNameMeta));
    } else if (isInserting) {
      context.missing(_feedTypeNameMeta);
    }
    if (data.containsKey('flock_id')) {
      context.handle(_flockIdMeta,
          flockId.isAcceptableOrUnknown(data['flock_id']!, _flockIdMeta));
    }
    if (data.containsKey('flock_name')) {
      context.handle(_flockNameMeta,
          flockName.isAcceptableOrUnknown(data['flock_name']!, _flockNameMeta));
    }
    if (data.containsKey('quantity_kg')) {
      context.handle(
          _quantityKgMeta,
          quantityKg.isAcceptableOrUnknown(
              data['quantity_kg']!, _quantityKgMeta));
    } else if (isInserting) {
      context.missing(_quantityKgMeta);
    }
    if (data.containsKey('cost_l_k_r')) {
      context.handle(_costLKRMeta,
          costLKR.isAcceptableOrUnknown(data['cost_l_k_r']!, _costLKRMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedLogTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedLogTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      feedTypeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}feed_type_id'])!,
      feedTypeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}feed_type_name'])!,
      flockId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flock_id']),
      flockName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flock_name']),
      quantityKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity_kg'])!,
      costLKR: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_l_k_r']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FeedLogTableTable createAlias(String alias) {
    return $FeedLogTableTable(attachedDatabase, alias);
  }
}

class FeedLogTableData extends DataClass
    implements Insertable<FeedLogTableData> {
  final String id;
  final String farmId;
  final String feedTypeId;
  final String feedTypeName;
  final String? flockId;
  final String? flockName;
  final double quantityKg;
  final double? costLKR;
  final DateTime date;
  final DateTime createdAt;
  const FeedLogTableData(
      {required this.id,
      required this.farmId,
      required this.feedTypeId,
      required this.feedTypeName,
      this.flockId,
      this.flockName,
      required this.quantityKg,
      this.costLKR,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['feed_type_id'] = Variable<String>(feedTypeId);
    map['feed_type_name'] = Variable<String>(feedTypeName);
    if (!nullToAbsent || flockId != null) {
      map['flock_id'] = Variable<String>(flockId);
    }
    if (!nullToAbsent || flockName != null) {
      map['flock_name'] = Variable<String>(flockName);
    }
    map['quantity_kg'] = Variable<double>(quantityKg);
    if (!nullToAbsent || costLKR != null) {
      map['cost_l_k_r'] = Variable<double>(costLKR);
    }
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FeedLogTableCompanion toCompanion(bool nullToAbsent) {
    return FeedLogTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      feedTypeId: Value(feedTypeId),
      feedTypeName: Value(feedTypeName),
      flockId: flockId == null && nullToAbsent
          ? const Value.absent()
          : Value(flockId),
      flockName: flockName == null && nullToAbsent
          ? const Value.absent()
          : Value(flockName),
      quantityKg: Value(quantityKg),
      costLKR: costLKR == null && nullToAbsent
          ? const Value.absent()
          : Value(costLKR),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory FeedLogTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedLogTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      feedTypeId: serializer.fromJson<String>(json['feedTypeId']),
      feedTypeName: serializer.fromJson<String>(json['feedTypeName']),
      flockId: serializer.fromJson<String?>(json['flockId']),
      flockName: serializer.fromJson<String?>(json['flockName']),
      quantityKg: serializer.fromJson<double>(json['quantityKg']),
      costLKR: serializer.fromJson<double?>(json['costLKR']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'feedTypeId': serializer.toJson<String>(feedTypeId),
      'feedTypeName': serializer.toJson<String>(feedTypeName),
      'flockId': serializer.toJson<String?>(flockId),
      'flockName': serializer.toJson<String?>(flockName),
      'quantityKg': serializer.toJson<double>(quantityKg),
      'costLKR': serializer.toJson<double?>(costLKR),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FeedLogTableData copyWith(
          {String? id,
          String? farmId,
          String? feedTypeId,
          String? feedTypeName,
          Value<String?> flockId = const Value.absent(),
          Value<String?> flockName = const Value.absent(),
          double? quantityKg,
          Value<double?> costLKR = const Value.absent(),
          DateTime? date,
          DateTime? createdAt}) =>
      FeedLogTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        feedTypeId: feedTypeId ?? this.feedTypeId,
        feedTypeName: feedTypeName ?? this.feedTypeName,
        flockId: flockId.present ? flockId.value : this.flockId,
        flockName: flockName.present ? flockName.value : this.flockName,
        quantityKg: quantityKg ?? this.quantityKg,
        costLKR: costLKR.present ? costLKR.value : this.costLKR,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  FeedLogTableData copyWithCompanion(FeedLogTableCompanion data) {
    return FeedLogTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      feedTypeId:
          data.feedTypeId.present ? data.feedTypeId.value : this.feedTypeId,
      feedTypeName: data.feedTypeName.present
          ? data.feedTypeName.value
          : this.feedTypeName,
      flockId: data.flockId.present ? data.flockId.value : this.flockId,
      flockName: data.flockName.present ? data.flockName.value : this.flockName,
      quantityKg:
          data.quantityKg.present ? data.quantityKg.value : this.quantityKg,
      costLKR: data.costLKR.present ? data.costLKR.value : this.costLKR,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedLogTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('feedTypeId: $feedTypeId, ')
          ..write('feedTypeName: $feedTypeName, ')
          ..write('flockId: $flockId, ')
          ..write('flockName: $flockName, ')
          ..write('quantityKg: $quantityKg, ')
          ..write('costLKR: $costLKR, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, farmId, feedTypeId, feedTypeName, flockId,
      flockName, quantityKg, costLKR, date, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedLogTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.feedTypeId == this.feedTypeId &&
          other.feedTypeName == this.feedTypeName &&
          other.flockId == this.flockId &&
          other.flockName == this.flockName &&
          other.quantityKg == this.quantityKg &&
          other.costLKR == this.costLKR &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class FeedLogTableCompanion extends UpdateCompanion<FeedLogTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> feedTypeId;
  final Value<String> feedTypeName;
  final Value<String?> flockId;
  final Value<String?> flockName;
  final Value<double> quantityKg;
  final Value<double?> costLKR;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FeedLogTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.feedTypeId = const Value.absent(),
    this.feedTypeName = const Value.absent(),
    this.flockId = const Value.absent(),
    this.flockName = const Value.absent(),
    this.quantityKg = const Value.absent(),
    this.costLKR = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeedLogTableCompanion.insert({
    required String id,
    required String farmId,
    required String feedTypeId,
    required String feedTypeName,
    this.flockId = const Value.absent(),
    this.flockName = const Value.absent(),
    required double quantityKg,
    this.costLKR = const Value.absent(),
    required DateTime date,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        feedTypeId = Value(feedTypeId),
        feedTypeName = Value(feedTypeName),
        quantityKg = Value(quantityKg),
        date = Value(date),
        createdAt = Value(createdAt);
  static Insertable<FeedLogTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? feedTypeId,
    Expression<String>? feedTypeName,
    Expression<String>? flockId,
    Expression<String>? flockName,
    Expression<double>? quantityKg,
    Expression<double>? costLKR,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (feedTypeId != null) 'feed_type_id': feedTypeId,
      if (feedTypeName != null) 'feed_type_name': feedTypeName,
      if (flockId != null) 'flock_id': flockId,
      if (flockName != null) 'flock_name': flockName,
      if (quantityKg != null) 'quantity_kg': quantityKg,
      if (costLKR != null) 'cost_l_k_r': costLKR,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeedLogTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? feedTypeId,
      Value<String>? feedTypeName,
      Value<String?>? flockId,
      Value<String?>? flockName,
      Value<double>? quantityKg,
      Value<double?>? costLKR,
      Value<DateTime>? date,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FeedLogTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      feedTypeId: feedTypeId ?? this.feedTypeId,
      feedTypeName: feedTypeName ?? this.feedTypeName,
      flockId: flockId ?? this.flockId,
      flockName: flockName ?? this.flockName,
      quantityKg: quantityKg ?? this.quantityKg,
      costLKR: costLKR ?? this.costLKR,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (feedTypeId.present) {
      map['feed_type_id'] = Variable<String>(feedTypeId.value);
    }
    if (feedTypeName.present) {
      map['feed_type_name'] = Variable<String>(feedTypeName.value);
    }
    if (flockId.present) {
      map['flock_id'] = Variable<String>(flockId.value);
    }
    if (flockName.present) {
      map['flock_name'] = Variable<String>(flockName.value);
    }
    if (quantityKg.present) {
      map['quantity_kg'] = Variable<double>(quantityKg.value);
    }
    if (costLKR.present) {
      map['cost_l_k_r'] = Variable<double>(costLKR.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedLogTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('feedTypeId: $feedTypeId, ')
          ..write('feedTypeName: $feedTypeName, ')
          ..write('flockId: $flockId, ')
          ..write('flockName: $flockName, ')
          ..write('quantityKg: $quantityKg, ')
          ..write('costLKR: $costLKR, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthRecordTableTable extends HealthRecordTable
    with TableInfo<$HealthRecordTableTable, HealthRecordTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthRecordTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _flockIdMeta =
      const VerificationMeta('flockId');
  @override
  late final GeneratedColumn<String> flockId = GeneratedColumn<String>(
      'flock_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
      'dosage', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nextDueDateMeta =
      const VerificationMeta('nextDueDate');
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
      'next_due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        flockId,
        date,
        type,
        productName,
        dosage,
        notes,
        nextDueDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_record_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<HealthRecordTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('flock_id')) {
      context.handle(_flockIdMeta,
          flockId.isAcceptableOrUnknown(data['flock_id']!, _flockIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(_dosageMeta,
          dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
          _nextDueDateMeta,
          nextDueDate.isAcceptableOrUnknown(
              data['next_due_date']!, _nextDueDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthRecordTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthRecordTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      flockId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flock_id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      dosage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      nextDueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_due_date']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $HealthRecordTableTable createAlias(String alias) {
    return $HealthRecordTableTable(attachedDatabase, alias);
  }
}

class HealthRecordTableData extends DataClass
    implements Insertable<HealthRecordTableData> {
  final String id;
  final String farmId;
  final String? flockId;
  final DateTime date;
  final String type;
  final String productName;
  final String? dosage;
  final String? notes;
  final DateTime? nextDueDate;
  final DateTime createdAt;
  const HealthRecordTableData(
      {required this.id,
      required this.farmId,
      this.flockId,
      required this.date,
      required this.type,
      required this.productName,
      this.dosage,
      this.notes,
      this.nextDueDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    if (!nullToAbsent || flockId != null) {
      map['flock_id'] = Variable<String>(flockId);
    }
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<String>(dosage);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || nextDueDate != null) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HealthRecordTableCompanion toCompanion(bool nullToAbsent) {
    return HealthRecordTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      flockId: flockId == null && nullToAbsent
          ? const Value.absent()
          : Value(flockId),
      date: Value(date),
      type: Value(type),
      productName: Value(productName),
      dosage:
          dosage == null && nullToAbsent ? const Value.absent() : Value(dosage),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      nextDueDate: nextDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDueDate),
      createdAt: Value(createdAt),
    );
  }

  factory HealthRecordTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthRecordTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      flockId: serializer.fromJson<String?>(json['flockId']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      productName: serializer.fromJson<String>(json['productName']),
      dosage: serializer.fromJson<String?>(json['dosage']),
      notes: serializer.fromJson<String?>(json['notes']),
      nextDueDate: serializer.fromJson<DateTime?>(json['nextDueDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'flockId': serializer.toJson<String?>(flockId),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'productName': serializer.toJson<String>(productName),
      'dosage': serializer.toJson<String?>(dosage),
      'notes': serializer.toJson<String?>(notes),
      'nextDueDate': serializer.toJson<DateTime?>(nextDueDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HealthRecordTableData copyWith(
          {String? id,
          String? farmId,
          Value<String?> flockId = const Value.absent(),
          DateTime? date,
          String? type,
          String? productName,
          Value<String?> dosage = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<DateTime?> nextDueDate = const Value.absent(),
          DateTime? createdAt}) =>
      HealthRecordTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        flockId: flockId.present ? flockId.value : this.flockId,
        date: date ?? this.date,
        type: type ?? this.type,
        productName: productName ?? this.productName,
        dosage: dosage.present ? dosage.value : this.dosage,
        notes: notes.present ? notes.value : this.notes,
        nextDueDate: nextDueDate.present ? nextDueDate.value : this.nextDueDate,
        createdAt: createdAt ?? this.createdAt,
      );
  HealthRecordTableData copyWithCompanion(HealthRecordTableCompanion data) {
    return HealthRecordTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      flockId: data.flockId.present ? data.flockId.value : this.flockId,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      notes: data.notes.present ? data.notes.value : this.notes,
      nextDueDate:
          data.nextDueDate.present ? data.nextDueDate.value : this.nextDueDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('flockId: $flockId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('productName: $productName, ')
          ..write('dosage: $dosage, ')
          ..write('notes: $notes, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, farmId, flockId, date, type, productName,
      dosage, notes, nextDueDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthRecordTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.flockId == this.flockId &&
          other.date == this.date &&
          other.type == this.type &&
          other.productName == this.productName &&
          other.dosage == this.dosage &&
          other.notes == this.notes &&
          other.nextDueDate == this.nextDueDate &&
          other.createdAt == this.createdAt);
}

class HealthRecordTableCompanion
    extends UpdateCompanion<HealthRecordTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String?> flockId;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<String> productName;
  final Value<String?> dosage;
  final Value<String?> notes;
  final Value<DateTime?> nextDueDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HealthRecordTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.flockId = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.productName = const Value.absent(),
    this.dosage = const Value.absent(),
    this.notes = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthRecordTableCompanion.insert({
    required String id,
    required String farmId,
    this.flockId = const Value.absent(),
    required DateTime date,
    required String type,
    required String productName,
    this.dosage = const Value.absent(),
    this.notes = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        date = Value(date),
        type = Value(type),
        productName = Value(productName),
        createdAt = Value(createdAt);
  static Insertable<HealthRecordTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? flockId,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<String>? productName,
    Expression<String>? dosage,
    Expression<String>? notes,
    Expression<DateTime>? nextDueDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (flockId != null) 'flock_id': flockId,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (productName != null) 'product_name': productName,
      if (dosage != null) 'dosage': dosage,
      if (notes != null) 'notes': notes,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthRecordTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String?>? flockId,
      Value<DateTime>? date,
      Value<String>? type,
      Value<String>? productName,
      Value<String?>? dosage,
      Value<String?>? notes,
      Value<DateTime?>? nextDueDate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return HealthRecordTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      flockId: flockId ?? this.flockId,
      date: date ?? this.date,
      type: type ?? this.type,
      productName: productName ?? this.productName,
      dosage: dosage ?? this.dosage,
      notes: notes ?? this.notes,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (flockId.present) {
      map['flock_id'] = Variable<String>(flockId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('flockId: $flockId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('productName: $productName, ')
          ..write('dosage: $dosage, ')
          ..write('notes: $notes, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VaccinationScheduleTableTable extends VaccinationScheduleTable
    with
        TableInfo<$VaccinationScheduleTableTable,
            VaccinationScheduleTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaccinationScheduleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _flockIdMeta =
      const VerificationMeta('flockId');
  @override
  late final GeneratedColumn<String> flockId = GeneratedColumn<String>(
      'flock_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _vaccineNameMeta =
      const VerificationMeta('vaccineName');
  @override
  late final GeneratedColumn<String> vaccineName = GeneratedColumn<String>(
      'vaccine_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, farmId, flockId, vaccineName, dueDate, isCompleted, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vaccination_schedule_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<VaccinationScheduleTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('flock_id')) {
      context.handle(_flockIdMeta,
          flockId.isAcceptableOrUnknown(data['flock_id']!, _flockIdMeta));
    }
    if (data.containsKey('vaccine_name')) {
      context.handle(
          _vaccineNameMeta,
          vaccineName.isAcceptableOrUnknown(
              data['vaccine_name']!, _vaccineNameMeta));
    } else if (isInserting) {
      context.missing(_vaccineNameMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaccinationScheduleTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaccinationScheduleTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      flockId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flock_id']),
      vaccineName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vaccine_name'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $VaccinationScheduleTableTable createAlias(String alias) {
    return $VaccinationScheduleTableTable(attachedDatabase, alias);
  }
}

class VaccinationScheduleTableData extends DataClass
    implements Insertable<VaccinationScheduleTableData> {
  final String id;
  final String farmId;
  final String? flockId;
  final String vaccineName;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime createdAt;
  const VaccinationScheduleTableData(
      {required this.id,
      required this.farmId,
      this.flockId,
      required this.vaccineName,
      required this.dueDate,
      required this.isCompleted,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    if (!nullToAbsent || flockId != null) {
      map['flock_id'] = Variable<String>(flockId);
    }
    map['vaccine_name'] = Variable<String>(vaccineName);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VaccinationScheduleTableCompanion toCompanion(bool nullToAbsent) {
    return VaccinationScheduleTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      flockId: flockId == null && nullToAbsent
          ? const Value.absent()
          : Value(flockId),
      vaccineName: Value(vaccineName),
      dueDate: Value(dueDate),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
    );
  }

  factory VaccinationScheduleTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaccinationScheduleTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      flockId: serializer.fromJson<String?>(json['flockId']),
      vaccineName: serializer.fromJson<String>(json['vaccineName']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'flockId': serializer.toJson<String?>(flockId),
      'vaccineName': serializer.toJson<String>(vaccineName),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VaccinationScheduleTableData copyWith(
          {String? id,
          String? farmId,
          Value<String?> flockId = const Value.absent(),
          String? vaccineName,
          DateTime? dueDate,
          bool? isCompleted,
          DateTime? createdAt}) =>
      VaccinationScheduleTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        flockId: flockId.present ? flockId.value : this.flockId,
        vaccineName: vaccineName ?? this.vaccineName,
        dueDate: dueDate ?? this.dueDate,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt ?? this.createdAt,
      );
  VaccinationScheduleTableData copyWithCompanion(
      VaccinationScheduleTableCompanion data) {
    return VaccinationScheduleTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      flockId: data.flockId.present ? data.flockId.value : this.flockId,
      vaccineName:
          data.vaccineName.present ? data.vaccineName.value : this.vaccineName,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaccinationScheduleTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('flockId: $flockId, ')
          ..write('vaccineName: $vaccineName, ')
          ..write('dueDate: $dueDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, farmId, flockId, vaccineName, dueDate, isCompleted, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaccinationScheduleTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.flockId == this.flockId &&
          other.vaccineName == this.vaccineName &&
          other.dueDate == this.dueDate &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt);
}

class VaccinationScheduleTableCompanion
    extends UpdateCompanion<VaccinationScheduleTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String?> flockId;
  final Value<String> vaccineName;
  final Value<DateTime> dueDate;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VaccinationScheduleTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.flockId = const Value.absent(),
    this.vaccineName = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaccinationScheduleTableCompanion.insert({
    required String id,
    required String farmId,
    this.flockId = const Value.absent(),
    required String vaccineName,
    required DateTime dueDate,
    this.isCompleted = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        vaccineName = Value(vaccineName),
        dueDate = Value(dueDate),
        createdAt = Value(createdAt);
  static Insertable<VaccinationScheduleTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? flockId,
    Expression<String>? vaccineName,
    Expression<DateTime>? dueDate,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (flockId != null) 'flock_id': flockId,
      if (vaccineName != null) 'vaccine_name': vaccineName,
      if (dueDate != null) 'due_date': dueDate,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaccinationScheduleTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String?>? flockId,
      Value<String>? vaccineName,
      Value<DateTime>? dueDate,
      Value<bool>? isCompleted,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return VaccinationScheduleTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      flockId: flockId ?? this.flockId,
      vaccineName: vaccineName ?? this.vaccineName,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (flockId.present) {
      map['flock_id'] = Variable<String>(flockId.value);
    }
    if (vaccineName.present) {
      map['vaccine_name'] = Variable<String>(vaccineName.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaccinationScheduleTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('flockId: $flockId, ')
          ..write('vaccineName: $vaccineName, ')
          ..write('dueDate: $dueDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicineStockTableTable extends MedicineStockTable
    with TableInfo<$MedicineStockTableTable, MedicineStockTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicineStockTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stockTypeMeta =
      const VerificationMeta('stockType');
  @override
  late final GeneratedColumn<String> stockType = GeneratedColumn<String>(
      'stock_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentQtyMeta =
      const VerificationMeta('currentQty');
  @override
  late final GeneratedColumn<double> currentQty = GeneratedColumn<double>(
      'current_qty', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lowStockThresholdMeta =
      const VerificationMeta('lowStockThreshold');
  @override
  late final GeneratedColumn<double> lowStockThreshold =
      GeneratedColumn<double>('low_stock_threshold', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pricePerUnitMeta =
      const VerificationMeta('pricePerUnit');
  @override
  late final GeneratedColumn<double> pricePerUnit = GeneratedColumn<double>(
      'price_per_unit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        name,
        stockType,
        unit,
        currentQty,
        lowStockThreshold,
        pricePerUnit,
        expiryDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicine_stock_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<MedicineStockTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('stock_type')) {
      context.handle(_stockTypeMeta,
          stockType.isAcceptableOrUnknown(data['stock_type']!, _stockTypeMeta));
    } else if (isInserting) {
      context.missing(_stockTypeMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('current_qty')) {
      context.handle(
          _currentQtyMeta,
          currentQty.isAcceptableOrUnknown(
              data['current_qty']!, _currentQtyMeta));
    } else if (isInserting) {
      context.missing(_currentQtyMeta);
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
          _lowStockThresholdMeta,
          lowStockThreshold.isAcceptableOrUnknown(
              data['low_stock_threshold']!, _lowStockThresholdMeta));
    } else if (isInserting) {
      context.missing(_lowStockThresholdMeta);
    }
    if (data.containsKey('price_per_unit')) {
      context.handle(
          _pricePerUnitMeta,
          pricePerUnit.isAcceptableOrUnknown(
              data['price_per_unit']!, _pricePerUnitMeta));
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicineStockTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicineStockTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      stockType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stock_type'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      currentQty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_qty'])!,
      lowStockThreshold: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}low_stock_threshold'])!,
      pricePerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_per_unit']),
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MedicineStockTableTable createAlias(String alias) {
    return $MedicineStockTableTable(attachedDatabase, alias);
  }
}

class MedicineStockTableData extends DataClass
    implements Insertable<MedicineStockTableData> {
  final String id;
  final String farmId;
  final String name;
  final String stockType;
  final String? unit;
  final double currentQty;
  final double lowStockThreshold;
  final double? pricePerUnit;
  final DateTime? expiryDate;
  final DateTime createdAt;
  const MedicineStockTableData(
      {required this.id,
      required this.farmId,
      required this.name,
      required this.stockType,
      this.unit,
      required this.currentQty,
      required this.lowStockThreshold,
      this.pricePerUnit,
      this.expiryDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['name'] = Variable<String>(name);
    map['stock_type'] = Variable<String>(stockType);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['current_qty'] = Variable<double>(currentQty);
    map['low_stock_threshold'] = Variable<double>(lowStockThreshold);
    if (!nullToAbsent || pricePerUnit != null) {
      map['price_per_unit'] = Variable<double>(pricePerUnit);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MedicineStockTableCompanion toCompanion(bool nullToAbsent) {
    return MedicineStockTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      name: Value(name),
      stockType: Value(stockType),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      currentQty: Value(currentQty),
      lowStockThreshold: Value(lowStockThreshold),
      pricePerUnit: pricePerUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerUnit),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      createdAt: Value(createdAt),
    );
  }

  factory MedicineStockTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicineStockTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      name: serializer.fromJson<String>(json['name']),
      stockType: serializer.fromJson<String>(json['stockType']),
      unit: serializer.fromJson<String?>(json['unit']),
      currentQty: serializer.fromJson<double>(json['currentQty']),
      lowStockThreshold: serializer.fromJson<double>(json['lowStockThreshold']),
      pricePerUnit: serializer.fromJson<double?>(json['pricePerUnit']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'name': serializer.toJson<String>(name),
      'stockType': serializer.toJson<String>(stockType),
      'unit': serializer.toJson<String?>(unit),
      'currentQty': serializer.toJson<double>(currentQty),
      'lowStockThreshold': serializer.toJson<double>(lowStockThreshold),
      'pricePerUnit': serializer.toJson<double?>(pricePerUnit),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MedicineStockTableData copyWith(
          {String? id,
          String? farmId,
          String? name,
          String? stockType,
          Value<String?> unit = const Value.absent(),
          double? currentQty,
          double? lowStockThreshold,
          Value<double?> pricePerUnit = const Value.absent(),
          Value<DateTime?> expiryDate = const Value.absent(),
          DateTime? createdAt}) =>
      MedicineStockTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        name: name ?? this.name,
        stockType: stockType ?? this.stockType,
        unit: unit.present ? unit.value : this.unit,
        currentQty: currentQty ?? this.currentQty,
        lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
        pricePerUnit:
            pricePerUnit.present ? pricePerUnit.value : this.pricePerUnit,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        createdAt: createdAt ?? this.createdAt,
      );
  MedicineStockTableData copyWithCompanion(MedicineStockTableCompanion data) {
    return MedicineStockTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      name: data.name.present ? data.name.value : this.name,
      stockType: data.stockType.present ? data.stockType.value : this.stockType,
      unit: data.unit.present ? data.unit.value : this.unit,
      currentQty:
          data.currentQty.present ? data.currentQty.value : this.currentQty,
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
      pricePerUnit: data.pricePerUnit.present
          ? data.pricePerUnit.value
          : this.pricePerUnit,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicineStockTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('stockType: $stockType, ')
          ..write('unit: $unit, ')
          ..write('currentQty: $currentQty, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, farmId, name, stockType, unit, currentQty,
      lowStockThreshold, pricePerUnit, expiryDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicineStockTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.name == this.name &&
          other.stockType == this.stockType &&
          other.unit == this.unit &&
          other.currentQty == this.currentQty &&
          other.lowStockThreshold == this.lowStockThreshold &&
          other.pricePerUnit == this.pricePerUnit &&
          other.expiryDate == this.expiryDate &&
          other.createdAt == this.createdAt);
}

class MedicineStockTableCompanion
    extends UpdateCompanion<MedicineStockTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> name;
  final Value<String> stockType;
  final Value<String?> unit;
  final Value<double> currentQty;
  final Value<double> lowStockThreshold;
  final Value<double?> pricePerUnit;
  final Value<DateTime?> expiryDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MedicineStockTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.name = const Value.absent(),
    this.stockType = const Value.absent(),
    this.unit = const Value.absent(),
    this.currentQty = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.pricePerUnit = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicineStockTableCompanion.insert({
    required String id,
    required String farmId,
    required String name,
    required String stockType,
    this.unit = const Value.absent(),
    required double currentQty,
    required double lowStockThreshold,
    this.pricePerUnit = const Value.absent(),
    this.expiryDate = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        name = Value(name),
        stockType = Value(stockType),
        currentQty = Value(currentQty),
        lowStockThreshold = Value(lowStockThreshold),
        createdAt = Value(createdAt);
  static Insertable<MedicineStockTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? name,
    Expression<String>? stockType,
    Expression<String>? unit,
    Expression<double>? currentQty,
    Expression<double>? lowStockThreshold,
    Expression<double>? pricePerUnit,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (name != null) 'name': name,
      if (stockType != null) 'stock_type': stockType,
      if (unit != null) 'unit': unit,
      if (currentQty != null) 'current_qty': currentQty,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (pricePerUnit != null) 'price_per_unit': pricePerUnit,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicineStockTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? name,
      Value<String>? stockType,
      Value<String?>? unit,
      Value<double>? currentQty,
      Value<double>? lowStockThreshold,
      Value<double?>? pricePerUnit,
      Value<DateTime?>? expiryDate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return MedicineStockTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      stockType: stockType ?? this.stockType,
      unit: unit ?? this.unit,
      currentQty: currentQty ?? this.currentQty,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (stockType.present) {
      map['stock_type'] = Variable<String>(stockType.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (currentQty.present) {
      map['current_qty'] = Variable<double>(currentQty.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<double>(lowStockThreshold.value);
    }
    if (pricePerUnit.present) {
      map['price_per_unit'] = Variable<double>(pricePerUnit.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicineStockTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('stockType: $stockType, ')
          ..write('unit: $unit, ')
          ..write('currentQty: $currentQty, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinanceTransactionTableTable extends FinanceTransactionTable
    with TableInfo<$FinanceTransactionTableTable, FinanceTransactionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinanceTransactionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, farmId, type, category, amount, description, date, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finance_transaction_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<FinanceTransactionTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinanceTransactionTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinanceTransactionTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FinanceTransactionTableTable createAlias(String alias) {
    return $FinanceTransactionTableTable(attachedDatabase, alias);
  }
}

class FinanceTransactionTableData extends DataClass
    implements Insertable<FinanceTransactionTableData> {
  final String id;
  final String farmId;
  final String type;
  final String category;
  final double amount;
  final String? description;
  final DateTime date;
  final DateTime createdAt;
  const FinanceTransactionTableData(
      {required this.id,
      required this.farmId,
      required this.type,
      required this.category,
      required this.amount,
      this.description,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FinanceTransactionTableCompanion toCompanion(bool nullToAbsent) {
    return FinanceTransactionTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      type: Value(type),
      category: Value(category),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory FinanceTransactionTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinanceTransactionTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FinanceTransactionTableData copyWith(
          {String? id,
          String? farmId,
          String? type,
          String? category,
          double? amount,
          Value<String?> description = const Value.absent(),
          DateTime? date,
          DateTime? createdAt}) =>
      FinanceTransactionTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        type: type ?? this.type,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        description: description.present ? description.value : this.description,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  FinanceTransactionTableData copyWithCompanion(
      FinanceTransactionTableCompanion data) {
    return FinanceTransactionTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      description:
          data.description.present ? data.description.value : this.description,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinanceTransactionTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, farmId, type, category, amount, description, date, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinanceTransactionTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.type == this.type &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class FinanceTransactionTableCompanion
    extends UpdateCompanion<FinanceTransactionTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> type;
  final Value<String> category;
  final Value<double> amount;
  final Value<String?> description;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FinanceTransactionTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinanceTransactionTableCompanion.insert({
    required String id,
    required String farmId,
    required String type,
    required String category,
    required double amount,
    this.description = const Value.absent(),
    required DateTime date,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        type = Value(type),
        category = Value(category),
        amount = Value(amount),
        date = Value(date),
        createdAt = Value(createdAt);
  static Insertable<FinanceTransactionTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? type,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinanceTransactionTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? type,
      Value<String>? category,
      Value<double>? amount,
      Value<String?>? description,
      Value<DateTime>? date,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FinanceTransactionTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinanceTransactionTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FlockTableTable flockTable = $FlockTableTable(this);
  late final $BatchTableTable batchTable = $BatchTableTable(this);
  late final $EggRecordTableTable eggRecordTable = $EggRecordTableTable(this);
  late final $EggSaleTableTable eggSaleTable = $EggSaleTableTable(this);
  late final $FeedTypeTableTable feedTypeTable = $FeedTypeTableTable(this);
  late final $FeedLogTableTable feedLogTable = $FeedLogTableTable(this);
  late final $HealthRecordTableTable healthRecordTable =
      $HealthRecordTableTable(this);
  late final $VaccinationScheduleTableTable vaccinationScheduleTable =
      $VaccinationScheduleTableTable(this);
  late final $MedicineStockTableTable medicineStockTable =
      $MedicineStockTableTable(this);
  late final $FinanceTransactionTableTable financeTransactionTable =
      $FinanceTransactionTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        flockTable,
        batchTable,
        eggRecordTable,
        eggSaleTable,
        feedTypeTable,
        feedLogTable,
        healthRecordTable,
        vaccinationScheduleTable,
        medicineStockTable,
        financeTransactionTable
      ];
}

typedef $$FlockTableTableCreateCompanionBuilder = FlockTableCompanion Function({
  required String id,
  required String farmId,
  required String name,
  Value<String?> breed,
  required String purpose,
  required int currentCount,
  required int initialCount,
  Value<String?> pen,
  required DateTime arrivalDate,
  required String status,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FlockTableTableUpdateCompanionBuilder = FlockTableCompanion Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> name,
  Value<String?> breed,
  Value<String> purpose,
  Value<int> currentCount,
  Value<int> initialCount,
  Value<String?> pen,
  Value<DateTime> arrivalDate,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FlockTableTableFilterComposer
    extends Composer<_$AppDatabase, $FlockTableTable> {
  $$FlockTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breed => $composableBuilder(
      column: $table.breed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purpose => $composableBuilder(
      column: $table.purpose, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentCount => $composableBuilder(
      column: $table.currentCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get initialCount => $composableBuilder(
      column: $table.initialCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pen => $composableBuilder(
      column: $table.pen, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get arrivalDate => $composableBuilder(
      column: $table.arrivalDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FlockTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FlockTableTable> {
  $$FlockTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breed => $composableBuilder(
      column: $table.breed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purpose => $composableBuilder(
      column: $table.purpose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentCount => $composableBuilder(
      column: $table.currentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get initialCount => $composableBuilder(
      column: $table.initialCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pen => $composableBuilder(
      column: $table.pen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get arrivalDate => $composableBuilder(
      column: $table.arrivalDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FlockTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlockTableTable> {
  $$FlockTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<int> get currentCount => $composableBuilder(
      column: $table.currentCount, builder: (column) => column);

  GeneratedColumn<int> get initialCount => $composableBuilder(
      column: $table.initialCount, builder: (column) => column);

  GeneratedColumn<String> get pen =>
      $composableBuilder(column: $table.pen, builder: (column) => column);

  GeneratedColumn<DateTime> get arrivalDate => $composableBuilder(
      column: $table.arrivalDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FlockTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FlockTableTable,
    FlockTableData,
    $$FlockTableTableFilterComposer,
    $$FlockTableTableOrderingComposer,
    $$FlockTableTableAnnotationComposer,
    $$FlockTableTableCreateCompanionBuilder,
    $$FlockTableTableUpdateCompanionBuilder,
    (
      FlockTableData,
      BaseReferences<_$AppDatabase, $FlockTableTable, FlockTableData>
    ),
    FlockTableData,
    PrefetchHooks Function()> {
  $$FlockTableTableTableManager(_$AppDatabase db, $FlockTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlockTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlockTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlockTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> breed = const Value.absent(),
            Value<String> purpose = const Value.absent(),
            Value<int> currentCount = const Value.absent(),
            Value<int> initialCount = const Value.absent(),
            Value<String?> pen = const Value.absent(),
            Value<DateTime> arrivalDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FlockTableCompanion(
            id: id,
            farmId: farmId,
            name: name,
            breed: breed,
            purpose: purpose,
            currentCount: currentCount,
            initialCount: initialCount,
            pen: pen,
            arrivalDate: arrivalDate,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String name,
            Value<String?> breed = const Value.absent(),
            required String purpose,
            required int currentCount,
            required int initialCount,
            Value<String?> pen = const Value.absent(),
            required DateTime arrivalDate,
            required String status,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FlockTableCompanion.insert(
            id: id,
            farmId: farmId,
            name: name,
            breed: breed,
            purpose: purpose,
            currentCount: currentCount,
            initialCount: initialCount,
            pen: pen,
            arrivalDate: arrivalDate,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$FlockTableTable, FlockTableData>(table),
                    BaseReferences<_$AppDatabase, $FlockTableTable,
                        FlockTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FlockTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FlockTableTable,
    FlockTableData,
    $$FlockTableTableFilterComposer,
    $$FlockTableTableOrderingComposer,
    $$FlockTableTableAnnotationComposer,
    $$FlockTableTableCreateCompanionBuilder,
    $$FlockTableTableUpdateCompanionBuilder,
    (
      FlockTableData,
      BaseReferences<_$AppDatabase, $FlockTableTable, FlockTableData>
    ),
    FlockTableData,
    PrefetchHooks Function()>;
typedef $$BatchTableTableCreateCompanionBuilder = BatchTableCompanion Function({
  required String id,
  required String farmId,
  required String name,
  Value<String?> breed,
  required DateTime arrivalDate,
  required int initialCount,
  required int currentCount,
  Value<String?> supplier,
  required String status,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$BatchTableTableUpdateCompanionBuilder = BatchTableCompanion Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> name,
  Value<String?> breed,
  Value<DateTime> arrivalDate,
  Value<int> initialCount,
  Value<int> currentCount,
  Value<String?> supplier,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$BatchTableTableFilterComposer
    extends Composer<_$AppDatabase, $BatchTableTable> {
  $$BatchTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breed => $composableBuilder(
      column: $table.breed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get arrivalDate => $composableBuilder(
      column: $table.arrivalDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get initialCount => $composableBuilder(
      column: $table.initialCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentCount => $composableBuilder(
      column: $table.currentCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplier => $composableBuilder(
      column: $table.supplier, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BatchTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BatchTableTable> {
  $$BatchTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breed => $composableBuilder(
      column: $table.breed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get arrivalDate => $composableBuilder(
      column: $table.arrivalDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get initialCount => $composableBuilder(
      column: $table.initialCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentCount => $composableBuilder(
      column: $table.currentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplier => $composableBuilder(
      column: $table.supplier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BatchTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BatchTableTable> {
  $$BatchTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => column);

  GeneratedColumn<DateTime> get arrivalDate => $composableBuilder(
      column: $table.arrivalDate, builder: (column) => column);

  GeneratedColumn<int> get initialCount => $composableBuilder(
      column: $table.initialCount, builder: (column) => column);

  GeneratedColumn<int> get currentCount => $composableBuilder(
      column: $table.currentCount, builder: (column) => column);

  GeneratedColumn<String> get supplier =>
      $composableBuilder(column: $table.supplier, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BatchTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BatchTableTable,
    BatchTableData,
    $$BatchTableTableFilterComposer,
    $$BatchTableTableOrderingComposer,
    $$BatchTableTableAnnotationComposer,
    $$BatchTableTableCreateCompanionBuilder,
    $$BatchTableTableUpdateCompanionBuilder,
    (
      BatchTableData,
      BaseReferences<_$AppDatabase, $BatchTableTable, BatchTableData>
    ),
    BatchTableData,
    PrefetchHooks Function()> {
  $$BatchTableTableTableManager(_$AppDatabase db, $BatchTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatchTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatchTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BatchTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> breed = const Value.absent(),
            Value<DateTime> arrivalDate = const Value.absent(),
            Value<int> initialCount = const Value.absent(),
            Value<int> currentCount = const Value.absent(),
            Value<String?> supplier = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BatchTableCompanion(
            id: id,
            farmId: farmId,
            name: name,
            breed: breed,
            arrivalDate: arrivalDate,
            initialCount: initialCount,
            currentCount: currentCount,
            supplier: supplier,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String name,
            Value<String?> breed = const Value.absent(),
            required DateTime arrivalDate,
            required int initialCount,
            required int currentCount,
            Value<String?> supplier = const Value.absent(),
            required String status,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BatchTableCompanion.insert(
            id: id,
            farmId: farmId,
            name: name,
            breed: breed,
            arrivalDate: arrivalDate,
            initialCount: initialCount,
            currentCount: currentCount,
            supplier: supplier,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$BatchTableTable, BatchTableData>(table),
                    BaseReferences<_$AppDatabase, $BatchTableTable,
                        BatchTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BatchTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BatchTableTable,
    BatchTableData,
    $$BatchTableTableFilterComposer,
    $$BatchTableTableOrderingComposer,
    $$BatchTableTableAnnotationComposer,
    $$BatchTableTableCreateCompanionBuilder,
    $$BatchTableTableUpdateCompanionBuilder,
    (
      BatchTableData,
      BaseReferences<_$AppDatabase, $BatchTableTable, BatchTableData>
    ),
    BatchTableData,
    PrefetchHooks Function()>;
typedef $$EggRecordTableTableCreateCompanionBuilder = EggRecordTableCompanion
    Function({
  required String id,
  required String farmId,
  Value<String?> flockId,
  required DateTime date,
  required int totalEggs,
  Value<int> brokenEggs,
  Value<int?> gradeA,
  Value<int?> gradeB,
  Value<int?> gradeC,
  Value<String?> collectedBy,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$EggRecordTableTableUpdateCompanionBuilder = EggRecordTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String?> flockId,
  Value<DateTime> date,
  Value<int> totalEggs,
  Value<int> brokenEggs,
  Value<int?> gradeA,
  Value<int?> gradeB,
  Value<int?> gradeC,
  Value<String?> collectedBy,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$EggRecordTableTableFilterComposer
    extends Composer<_$AppDatabase, $EggRecordTableTable> {
  $$EggRecordTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flockId => $composableBuilder(
      column: $table.flockId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalEggs => $composableBuilder(
      column: $table.totalEggs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get brokenEggs => $composableBuilder(
      column: $table.brokenEggs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gradeA => $composableBuilder(
      column: $table.gradeA, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gradeB => $composableBuilder(
      column: $table.gradeB, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gradeC => $composableBuilder(
      column: $table.gradeC, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get collectedBy => $composableBuilder(
      column: $table.collectedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$EggRecordTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EggRecordTableTable> {
  $$EggRecordTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flockId => $composableBuilder(
      column: $table.flockId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalEggs => $composableBuilder(
      column: $table.totalEggs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get brokenEggs => $composableBuilder(
      column: $table.brokenEggs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gradeA => $composableBuilder(
      column: $table.gradeA, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gradeB => $composableBuilder(
      column: $table.gradeB, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gradeC => $composableBuilder(
      column: $table.gradeC, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get collectedBy => $composableBuilder(
      column: $table.collectedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$EggRecordTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EggRecordTableTable> {
  $$EggRecordTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get flockId =>
      $composableBuilder(column: $table.flockId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get totalEggs =>
      $composableBuilder(column: $table.totalEggs, builder: (column) => column);

  GeneratedColumn<int> get brokenEggs => $composableBuilder(
      column: $table.brokenEggs, builder: (column) => column);

  GeneratedColumn<int> get gradeA =>
      $composableBuilder(column: $table.gradeA, builder: (column) => column);

  GeneratedColumn<int> get gradeB =>
      $composableBuilder(column: $table.gradeB, builder: (column) => column);

  GeneratedColumn<int> get gradeC =>
      $composableBuilder(column: $table.gradeC, builder: (column) => column);

  GeneratedColumn<String> get collectedBy => $composableBuilder(
      column: $table.collectedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EggRecordTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EggRecordTableTable,
    EggRecordTableData,
    $$EggRecordTableTableFilterComposer,
    $$EggRecordTableTableOrderingComposer,
    $$EggRecordTableTableAnnotationComposer,
    $$EggRecordTableTableCreateCompanionBuilder,
    $$EggRecordTableTableUpdateCompanionBuilder,
    (
      EggRecordTableData,
      BaseReferences<_$AppDatabase, $EggRecordTableTable, EggRecordTableData>
    ),
    EggRecordTableData,
    PrefetchHooks Function()> {
  $$EggRecordTableTableTableManager(
      _$AppDatabase db, $EggRecordTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EggRecordTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EggRecordTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EggRecordTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String?> flockId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> totalEggs = const Value.absent(),
            Value<int> brokenEggs = const Value.absent(),
            Value<int?> gradeA = const Value.absent(),
            Value<int?> gradeB = const Value.absent(),
            Value<int?> gradeC = const Value.absent(),
            Value<String?> collectedBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EggRecordTableCompanion(
            id: id,
            farmId: farmId,
            flockId: flockId,
            date: date,
            totalEggs: totalEggs,
            brokenEggs: brokenEggs,
            gradeA: gradeA,
            gradeB: gradeB,
            gradeC: gradeC,
            collectedBy: collectedBy,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            Value<String?> flockId = const Value.absent(),
            required DateTime date,
            required int totalEggs,
            Value<int> brokenEggs = const Value.absent(),
            Value<int?> gradeA = const Value.absent(),
            Value<int?> gradeB = const Value.absent(),
            Value<int?> gradeC = const Value.absent(),
            Value<String?> collectedBy = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EggRecordTableCompanion.insert(
            id: id,
            farmId: farmId,
            flockId: flockId,
            date: date,
            totalEggs: totalEggs,
            brokenEggs: brokenEggs,
            gradeA: gradeA,
            gradeB: gradeB,
            gradeC: gradeC,
            collectedBy: collectedBy,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$EggRecordTableTable, EggRecordTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $EggRecordTableTable,
                        EggRecordTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EggRecordTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EggRecordTableTable,
    EggRecordTableData,
    $$EggRecordTableTableFilterComposer,
    $$EggRecordTableTableOrderingComposer,
    $$EggRecordTableTableAnnotationComposer,
    $$EggRecordTableTableCreateCompanionBuilder,
    $$EggRecordTableTableUpdateCompanionBuilder,
    (
      EggRecordTableData,
      BaseReferences<_$AppDatabase, $EggRecordTableTable, EggRecordTableData>
    ),
    EggRecordTableData,
    PrefetchHooks Function()>;
typedef $$EggSaleTableTableCreateCompanionBuilder = EggSaleTableCompanion
    Function({
  required String id,
  required String farmId,
  required String saleType,
  required int quantity,
  Value<double?> pricePerUnit,
  Value<double?> totalAmount,
  Value<String?> buyerName,
  required DateTime date,
  Value<int> rowid,
});
typedef $$EggSaleTableTableUpdateCompanionBuilder = EggSaleTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> saleType,
  Value<int> quantity,
  Value<double?> pricePerUnit,
  Value<double?> totalAmount,
  Value<String?> buyerName,
  Value<DateTime> date,
  Value<int> rowid,
});

class $$EggSaleTableTableFilterComposer
    extends Composer<_$AppDatabase, $EggSaleTableTable> {
  $$EggSaleTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saleType => $composableBuilder(
      column: $table.saleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buyerName => $composableBuilder(
      column: $table.buyerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));
}

class $$EggSaleTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EggSaleTableTable> {
  $$EggSaleTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saleType => $composableBuilder(
      column: $table.saleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buyerName => $composableBuilder(
      column: $table.buyerName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));
}

class $$EggSaleTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EggSaleTableTable> {
  $$EggSaleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get saleType =>
      $composableBuilder(column: $table.saleType, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<String> get buyerName =>
      $composableBuilder(column: $table.buyerName, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$EggSaleTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EggSaleTableTable,
    EggSaleTableData,
    $$EggSaleTableTableFilterComposer,
    $$EggSaleTableTableOrderingComposer,
    $$EggSaleTableTableAnnotationComposer,
    $$EggSaleTableTableCreateCompanionBuilder,
    $$EggSaleTableTableUpdateCompanionBuilder,
    (
      EggSaleTableData,
      BaseReferences<_$AppDatabase, $EggSaleTableTable, EggSaleTableData>
    ),
    EggSaleTableData,
    PrefetchHooks Function()> {
  $$EggSaleTableTableTableManager(_$AppDatabase db, $EggSaleTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EggSaleTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EggSaleTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EggSaleTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> saleType = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double?> pricePerUnit = const Value.absent(),
            Value<double?> totalAmount = const Value.absent(),
            Value<String?> buyerName = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EggSaleTableCompanion(
            id: id,
            farmId: farmId,
            saleType: saleType,
            quantity: quantity,
            pricePerUnit: pricePerUnit,
            totalAmount: totalAmount,
            buyerName: buyerName,
            date: date,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String saleType,
            required int quantity,
            Value<double?> pricePerUnit = const Value.absent(),
            Value<double?> totalAmount = const Value.absent(),
            Value<String?> buyerName = const Value.absent(),
            required DateTime date,
            Value<int> rowid = const Value.absent(),
          }) =>
              EggSaleTableCompanion.insert(
            id: id,
            farmId: farmId,
            saleType: saleType,
            quantity: quantity,
            pricePerUnit: pricePerUnit,
            totalAmount: totalAmount,
            buyerName: buyerName,
            date: date,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$EggSaleTableTable, EggSaleTableData>(table),
                    BaseReferences<_$AppDatabase, $EggSaleTableTable,
                        EggSaleTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EggSaleTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EggSaleTableTable,
    EggSaleTableData,
    $$EggSaleTableTableFilterComposer,
    $$EggSaleTableTableOrderingComposer,
    $$EggSaleTableTableAnnotationComposer,
    $$EggSaleTableTableCreateCompanionBuilder,
    $$EggSaleTableTableUpdateCompanionBuilder,
    (
      EggSaleTableData,
      BaseReferences<_$AppDatabase, $EggSaleTableTable, EggSaleTableData>
    ),
    EggSaleTableData,
    PrefetchHooks Function()>;
typedef $$FeedTypeTableTableCreateCompanionBuilder = FeedTypeTableCompanion
    Function({
  required String id,
  required String farmId,
  required String name,
  Value<String?> brand,
  Value<String?> forPurpose,
  required double currentStockKg,
  required double lowStockThresholdKg,
  Value<double?> pricePerKg,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FeedTypeTableTableUpdateCompanionBuilder = FeedTypeTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> name,
  Value<String?> brand,
  Value<String?> forPurpose,
  Value<double> currentStockKg,
  Value<double> lowStockThresholdKg,
  Value<double?> pricePerKg,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FeedTypeTableTableFilterComposer
    extends Composer<_$AppDatabase, $FeedTypeTableTable> {
  $$FeedTypeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get forPurpose => $composableBuilder(
      column: $table.forPurpose, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentStockKg => $composableBuilder(
      column: $table.currentStockKg,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lowStockThresholdKg => $composableBuilder(
      column: $table.lowStockThresholdKg,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pricePerKg => $composableBuilder(
      column: $table.pricePerKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FeedTypeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedTypeTableTable> {
  $$FeedTypeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get forPurpose => $composableBuilder(
      column: $table.forPurpose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentStockKg => $composableBuilder(
      column: $table.currentStockKg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lowStockThresholdKg => $composableBuilder(
      column: $table.lowStockThresholdKg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pricePerKg => $composableBuilder(
      column: $table.pricePerKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FeedTypeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedTypeTableTable> {
  $$FeedTypeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get forPurpose => $composableBuilder(
      column: $table.forPurpose, builder: (column) => column);

  GeneratedColumn<double> get currentStockKg => $composableBuilder(
      column: $table.currentStockKg, builder: (column) => column);

  GeneratedColumn<double> get lowStockThresholdKg => $composableBuilder(
      column: $table.lowStockThresholdKg, builder: (column) => column);

  GeneratedColumn<double> get pricePerKg => $composableBuilder(
      column: $table.pricePerKg, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FeedTypeTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FeedTypeTableTable,
    FeedTypeTableData,
    $$FeedTypeTableTableFilterComposer,
    $$FeedTypeTableTableOrderingComposer,
    $$FeedTypeTableTableAnnotationComposer,
    $$FeedTypeTableTableCreateCompanionBuilder,
    $$FeedTypeTableTableUpdateCompanionBuilder,
    (
      FeedTypeTableData,
      BaseReferences<_$AppDatabase, $FeedTypeTableTable, FeedTypeTableData>
    ),
    FeedTypeTableData,
    PrefetchHooks Function()> {
  $$FeedTypeTableTableTableManager(_$AppDatabase db, $FeedTypeTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedTypeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedTypeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedTypeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String?> forPurpose = const Value.absent(),
            Value<double> currentStockKg = const Value.absent(),
            Value<double> lowStockThresholdKg = const Value.absent(),
            Value<double?> pricePerKg = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FeedTypeTableCompanion(
            id: id,
            farmId: farmId,
            name: name,
            brand: brand,
            forPurpose: forPurpose,
            currentStockKg: currentStockKg,
            lowStockThresholdKg: lowStockThresholdKg,
            pricePerKg: pricePerKg,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String name,
            Value<String?> brand = const Value.absent(),
            Value<String?> forPurpose = const Value.absent(),
            required double currentStockKg,
            required double lowStockThresholdKg,
            Value<double?> pricePerKg = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FeedTypeTableCompanion.insert(
            id: id,
            farmId: farmId,
            name: name,
            brand: brand,
            forPurpose: forPurpose,
            currentStockKg: currentStockKg,
            lowStockThresholdKg: lowStockThresholdKg,
            pricePerKg: pricePerKg,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$FeedTypeTableTable, FeedTypeTableData>(table),
                    BaseReferences<_$AppDatabase, $FeedTypeTableTable,
                        FeedTypeTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FeedTypeTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FeedTypeTableTable,
    FeedTypeTableData,
    $$FeedTypeTableTableFilterComposer,
    $$FeedTypeTableTableOrderingComposer,
    $$FeedTypeTableTableAnnotationComposer,
    $$FeedTypeTableTableCreateCompanionBuilder,
    $$FeedTypeTableTableUpdateCompanionBuilder,
    (
      FeedTypeTableData,
      BaseReferences<_$AppDatabase, $FeedTypeTableTable, FeedTypeTableData>
    ),
    FeedTypeTableData,
    PrefetchHooks Function()>;
typedef $$FeedLogTableTableCreateCompanionBuilder = FeedLogTableCompanion
    Function({
  required String id,
  required String farmId,
  required String feedTypeId,
  required String feedTypeName,
  Value<String?> flockId,
  Value<String?> flockName,
  required double quantityKg,
  Value<double?> costLKR,
  required DateTime date,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FeedLogTableTableUpdateCompanionBuilder = FeedLogTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> feedTypeId,
  Value<String> feedTypeName,
  Value<String?> flockId,
  Value<String?> flockName,
  Value<double> quantityKg,
  Value<double?> costLKR,
  Value<DateTime> date,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FeedLogTableTableFilterComposer
    extends Composer<_$AppDatabase, $FeedLogTableTable> {
  $$FeedLogTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get feedTypeId => $composableBuilder(
      column: $table.feedTypeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get feedTypeName => $composableBuilder(
      column: $table.feedTypeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flockId => $composableBuilder(
      column: $table.flockId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flockName => $composableBuilder(
      column: $table.flockName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityKg => $composableBuilder(
      column: $table.quantityKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costLKR => $composableBuilder(
      column: $table.costLKR, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FeedLogTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedLogTableTable> {
  $$FeedLogTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get feedTypeId => $composableBuilder(
      column: $table.feedTypeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get feedTypeName => $composableBuilder(
      column: $table.feedTypeName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flockId => $composableBuilder(
      column: $table.flockId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flockName => $composableBuilder(
      column: $table.flockName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityKg => $composableBuilder(
      column: $table.quantityKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costLKR => $composableBuilder(
      column: $table.costLKR, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FeedLogTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedLogTableTable> {
  $$FeedLogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get feedTypeId => $composableBuilder(
      column: $table.feedTypeId, builder: (column) => column);

  GeneratedColumn<String> get feedTypeName => $composableBuilder(
      column: $table.feedTypeName, builder: (column) => column);

  GeneratedColumn<String> get flockId =>
      $composableBuilder(column: $table.flockId, builder: (column) => column);

  GeneratedColumn<String> get flockName =>
      $composableBuilder(column: $table.flockName, builder: (column) => column);

  GeneratedColumn<double> get quantityKg => $composableBuilder(
      column: $table.quantityKg, builder: (column) => column);

  GeneratedColumn<double> get costLKR =>
      $composableBuilder(column: $table.costLKR, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FeedLogTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FeedLogTableTable,
    FeedLogTableData,
    $$FeedLogTableTableFilterComposer,
    $$FeedLogTableTableOrderingComposer,
    $$FeedLogTableTableAnnotationComposer,
    $$FeedLogTableTableCreateCompanionBuilder,
    $$FeedLogTableTableUpdateCompanionBuilder,
    (
      FeedLogTableData,
      BaseReferences<_$AppDatabase, $FeedLogTableTable, FeedLogTableData>
    ),
    FeedLogTableData,
    PrefetchHooks Function()> {
  $$FeedLogTableTableTableManager(_$AppDatabase db, $FeedLogTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedLogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedLogTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedLogTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> feedTypeId = const Value.absent(),
            Value<String> feedTypeName = const Value.absent(),
            Value<String?> flockId = const Value.absent(),
            Value<String?> flockName = const Value.absent(),
            Value<double> quantityKg = const Value.absent(),
            Value<double?> costLKR = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FeedLogTableCompanion(
            id: id,
            farmId: farmId,
            feedTypeId: feedTypeId,
            feedTypeName: feedTypeName,
            flockId: flockId,
            flockName: flockName,
            quantityKg: quantityKg,
            costLKR: costLKR,
            date: date,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String feedTypeId,
            required String feedTypeName,
            Value<String?> flockId = const Value.absent(),
            Value<String?> flockName = const Value.absent(),
            required double quantityKg,
            Value<double?> costLKR = const Value.absent(),
            required DateTime date,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FeedLogTableCompanion.insert(
            id: id,
            farmId: farmId,
            feedTypeId: feedTypeId,
            feedTypeName: feedTypeName,
            flockId: flockId,
            flockName: flockName,
            quantityKg: quantityKg,
            costLKR: costLKR,
            date: date,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$FeedLogTableTable, FeedLogTableData>(table),
                    BaseReferences<_$AppDatabase, $FeedLogTableTable,
                        FeedLogTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FeedLogTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FeedLogTableTable,
    FeedLogTableData,
    $$FeedLogTableTableFilterComposer,
    $$FeedLogTableTableOrderingComposer,
    $$FeedLogTableTableAnnotationComposer,
    $$FeedLogTableTableCreateCompanionBuilder,
    $$FeedLogTableTableUpdateCompanionBuilder,
    (
      FeedLogTableData,
      BaseReferences<_$AppDatabase, $FeedLogTableTable, FeedLogTableData>
    ),
    FeedLogTableData,
    PrefetchHooks Function()>;
typedef $$HealthRecordTableTableCreateCompanionBuilder
    = HealthRecordTableCompanion Function({
  required String id,
  required String farmId,
  Value<String?> flockId,
  required DateTime date,
  required String type,
  required String productName,
  Value<String?> dosage,
  Value<String?> notes,
  Value<DateTime?> nextDueDate,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$HealthRecordTableTableUpdateCompanionBuilder
    = HealthRecordTableCompanion Function({
  Value<String> id,
  Value<String> farmId,
  Value<String?> flockId,
  Value<DateTime> date,
  Value<String> type,
  Value<String> productName,
  Value<String?> dosage,
  Value<String?> notes,
  Value<DateTime?> nextDueDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$HealthRecordTableTableFilterComposer
    extends Composer<_$AppDatabase, $HealthRecordTableTable> {
  $$HealthRecordTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flockId => $composableBuilder(
      column: $table.flockId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$HealthRecordTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthRecordTableTable> {
  $$HealthRecordTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flockId => $composableBuilder(
      column: $table.flockId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$HealthRecordTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthRecordTableTable> {
  $$HealthRecordTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get flockId =>
      $composableBuilder(column: $table.flockId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HealthRecordTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HealthRecordTableTable,
    HealthRecordTableData,
    $$HealthRecordTableTableFilterComposer,
    $$HealthRecordTableTableOrderingComposer,
    $$HealthRecordTableTableAnnotationComposer,
    $$HealthRecordTableTableCreateCompanionBuilder,
    $$HealthRecordTableTableUpdateCompanionBuilder,
    (
      HealthRecordTableData,
      BaseReferences<_$AppDatabase, $HealthRecordTableTable,
          HealthRecordTableData>
    ),
    HealthRecordTableData,
    PrefetchHooks Function()> {
  $$HealthRecordTableTableTableManager(
      _$AppDatabase db, $HealthRecordTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthRecordTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthRecordTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthRecordTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String?> flockId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<String?> dosage = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> nextDueDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HealthRecordTableCompanion(
            id: id,
            farmId: farmId,
            flockId: flockId,
            date: date,
            type: type,
            productName: productName,
            dosage: dosage,
            notes: notes,
            nextDueDate: nextDueDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            Value<String?> flockId = const Value.absent(),
            required DateTime date,
            required String type,
            required String productName,
            Value<String?> dosage = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> nextDueDate = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HealthRecordTableCompanion.insert(
            id: id,
            farmId: farmId,
            flockId: flockId,
            date: date,
            type: type,
            productName: productName,
            dosage: dosage,
            notes: notes,
            nextDueDate: nextDueDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$HealthRecordTableTable, HealthRecordTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $HealthRecordTableTable,
                        HealthRecordTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HealthRecordTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HealthRecordTableTable,
    HealthRecordTableData,
    $$HealthRecordTableTableFilterComposer,
    $$HealthRecordTableTableOrderingComposer,
    $$HealthRecordTableTableAnnotationComposer,
    $$HealthRecordTableTableCreateCompanionBuilder,
    $$HealthRecordTableTableUpdateCompanionBuilder,
    (
      HealthRecordTableData,
      BaseReferences<_$AppDatabase, $HealthRecordTableTable,
          HealthRecordTableData>
    ),
    HealthRecordTableData,
    PrefetchHooks Function()>;
typedef $$VaccinationScheduleTableTableCreateCompanionBuilder
    = VaccinationScheduleTableCompanion Function({
  required String id,
  required String farmId,
  Value<String?> flockId,
  required String vaccineName,
  required DateTime dueDate,
  Value<bool> isCompleted,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$VaccinationScheduleTableTableUpdateCompanionBuilder
    = VaccinationScheduleTableCompanion Function({
  Value<String> id,
  Value<String> farmId,
  Value<String?> flockId,
  Value<String> vaccineName,
  Value<DateTime> dueDate,
  Value<bool> isCompleted,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$VaccinationScheduleTableTableFilterComposer
    extends Composer<_$AppDatabase, $VaccinationScheduleTableTable> {
  $$VaccinationScheduleTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flockId => $composableBuilder(
      column: $table.flockId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vaccineName => $composableBuilder(
      column: $table.vaccineName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$VaccinationScheduleTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VaccinationScheduleTableTable> {
  $$VaccinationScheduleTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flockId => $composableBuilder(
      column: $table.flockId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vaccineName => $composableBuilder(
      column: $table.vaccineName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$VaccinationScheduleTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaccinationScheduleTableTable> {
  $$VaccinationScheduleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get flockId =>
      $composableBuilder(column: $table.flockId, builder: (column) => column);

  GeneratedColumn<String> get vaccineName => $composableBuilder(
      column: $table.vaccineName, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VaccinationScheduleTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VaccinationScheduleTableTable,
    VaccinationScheduleTableData,
    $$VaccinationScheduleTableTableFilterComposer,
    $$VaccinationScheduleTableTableOrderingComposer,
    $$VaccinationScheduleTableTableAnnotationComposer,
    $$VaccinationScheduleTableTableCreateCompanionBuilder,
    $$VaccinationScheduleTableTableUpdateCompanionBuilder,
    (
      VaccinationScheduleTableData,
      BaseReferences<_$AppDatabase, $VaccinationScheduleTableTable,
          VaccinationScheduleTableData>
    ),
    VaccinationScheduleTableData,
    PrefetchHooks Function()> {
  $$VaccinationScheduleTableTableTableManager(
      _$AppDatabase db, $VaccinationScheduleTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaccinationScheduleTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$VaccinationScheduleTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaccinationScheduleTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String?> flockId = const Value.absent(),
            Value<String> vaccineName = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VaccinationScheduleTableCompanion(
            id: id,
            farmId: farmId,
            flockId: flockId,
            vaccineName: vaccineName,
            dueDate: dueDate,
            isCompleted: isCompleted,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            Value<String?> flockId = const Value.absent(),
            required String vaccineName,
            required DateTime dueDate,
            Value<bool> isCompleted = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              VaccinationScheduleTableCompanion.insert(
            id: id,
            farmId: farmId,
            flockId: flockId,
            vaccineName: vaccineName,
            dueDate: dueDate,
            isCompleted: isCompleted,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$VaccinationScheduleTableTable,
                        VaccinationScheduleTableData>(table),
                    BaseReferences<
                        _$AppDatabase,
                        $VaccinationScheduleTableTable,
                        VaccinationScheduleTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VaccinationScheduleTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $VaccinationScheduleTableTable,
        VaccinationScheduleTableData,
        $$VaccinationScheduleTableTableFilterComposer,
        $$VaccinationScheduleTableTableOrderingComposer,
        $$VaccinationScheduleTableTableAnnotationComposer,
        $$VaccinationScheduleTableTableCreateCompanionBuilder,
        $$VaccinationScheduleTableTableUpdateCompanionBuilder,
        (
          VaccinationScheduleTableData,
          BaseReferences<_$AppDatabase, $VaccinationScheduleTableTable,
              VaccinationScheduleTableData>
        ),
        VaccinationScheduleTableData,
        PrefetchHooks Function()>;
typedef $$MedicineStockTableTableCreateCompanionBuilder
    = MedicineStockTableCompanion Function({
  required String id,
  required String farmId,
  required String name,
  required String stockType,
  Value<String?> unit,
  required double currentQty,
  required double lowStockThreshold,
  Value<double?> pricePerUnit,
  Value<DateTime?> expiryDate,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$MedicineStockTableTableUpdateCompanionBuilder
    = MedicineStockTableCompanion Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> name,
  Value<String> stockType,
  Value<String?> unit,
  Value<double> currentQty,
  Value<double> lowStockThreshold,
  Value<double?> pricePerUnit,
  Value<DateTime?> expiryDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$MedicineStockTableTableFilterComposer
    extends Composer<_$AppDatabase, $MedicineStockTableTable> {
  $$MedicineStockTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stockType => $composableBuilder(
      column: $table.stockType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentQty => $composableBuilder(
      column: $table.currentQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$MedicineStockTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicineStockTableTable> {
  $$MedicineStockTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stockType => $composableBuilder(
      column: $table.stockType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentQty => $composableBuilder(
      column: $table.currentQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MedicineStockTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicineStockTableTable> {
  $$MedicineStockTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get stockType =>
      $composableBuilder(column: $table.stockType, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get currentQty => $composableBuilder(
      column: $table.currentQty, builder: (column) => column);

  GeneratedColumn<double> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold, builder: (column) => column);

  GeneratedColumn<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MedicineStockTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicineStockTableTable,
    MedicineStockTableData,
    $$MedicineStockTableTableFilterComposer,
    $$MedicineStockTableTableOrderingComposer,
    $$MedicineStockTableTableAnnotationComposer,
    $$MedicineStockTableTableCreateCompanionBuilder,
    $$MedicineStockTableTableUpdateCompanionBuilder,
    (
      MedicineStockTableData,
      BaseReferences<_$AppDatabase, $MedicineStockTableTable,
          MedicineStockTableData>
    ),
    MedicineStockTableData,
    PrefetchHooks Function()> {
  $$MedicineStockTableTableTableManager(
      _$AppDatabase db, $MedicineStockTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicineStockTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicineStockTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicineStockTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> stockType = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<double> currentQty = const Value.absent(),
            Value<double> lowStockThreshold = const Value.absent(),
            Value<double?> pricePerUnit = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicineStockTableCompanion(
            id: id,
            farmId: farmId,
            name: name,
            stockType: stockType,
            unit: unit,
            currentQty: currentQty,
            lowStockThreshold: lowStockThreshold,
            pricePerUnit: pricePerUnit,
            expiryDate: expiryDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String name,
            required String stockType,
            Value<String?> unit = const Value.absent(),
            required double currentQty,
            required double lowStockThreshold,
            Value<double?> pricePerUnit = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicineStockTableCompanion.insert(
            id: id,
            farmId: farmId,
            name: name,
            stockType: stockType,
            unit: unit,
            currentQty: currentQty,
            lowStockThreshold: lowStockThreshold,
            pricePerUnit: pricePerUnit,
            expiryDate: expiryDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MedicineStockTableTable,
                        MedicineStockTableData>(table),
                    BaseReferences<_$AppDatabase, $MedicineStockTableTable,
                        MedicineStockTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MedicineStockTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicineStockTableTable,
    MedicineStockTableData,
    $$MedicineStockTableTableFilterComposer,
    $$MedicineStockTableTableOrderingComposer,
    $$MedicineStockTableTableAnnotationComposer,
    $$MedicineStockTableTableCreateCompanionBuilder,
    $$MedicineStockTableTableUpdateCompanionBuilder,
    (
      MedicineStockTableData,
      BaseReferences<_$AppDatabase, $MedicineStockTableTable,
          MedicineStockTableData>
    ),
    MedicineStockTableData,
    PrefetchHooks Function()>;
typedef $$FinanceTransactionTableTableCreateCompanionBuilder
    = FinanceTransactionTableCompanion Function({
  required String id,
  required String farmId,
  required String type,
  required String category,
  required double amount,
  Value<String?> description,
  required DateTime date,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FinanceTransactionTableTableUpdateCompanionBuilder
    = FinanceTransactionTableCompanion Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> type,
  Value<String> category,
  Value<double> amount,
  Value<String?> description,
  Value<DateTime> date,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FinanceTransactionTableTableFilterComposer
    extends Composer<_$AppDatabase, $FinanceTransactionTableTable> {
  $$FinanceTransactionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FinanceTransactionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FinanceTransactionTableTable> {
  $$FinanceTransactionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FinanceTransactionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinanceTransactionTableTable> {
  $$FinanceTransactionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FinanceTransactionTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinanceTransactionTableTable,
    FinanceTransactionTableData,
    $$FinanceTransactionTableTableFilterComposer,
    $$FinanceTransactionTableTableOrderingComposer,
    $$FinanceTransactionTableTableAnnotationComposer,
    $$FinanceTransactionTableTableCreateCompanionBuilder,
    $$FinanceTransactionTableTableUpdateCompanionBuilder,
    (
      FinanceTransactionTableData,
      BaseReferences<_$AppDatabase, $FinanceTransactionTableTable,
          FinanceTransactionTableData>
    ),
    FinanceTransactionTableData,
    PrefetchHooks Function()> {
  $$FinanceTransactionTableTableTableManager(
      _$AppDatabase db, $FinanceTransactionTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinanceTransactionTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$FinanceTransactionTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinanceTransactionTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinanceTransactionTableCompanion(
            id: id,
            farmId: farmId,
            type: type,
            category: category,
            amount: amount,
            description: description,
            date: date,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String type,
            required String category,
            required double amount,
            Value<String?> description = const Value.absent(),
            required DateTime date,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FinanceTransactionTableCompanion.insert(
            id: id,
            farmId: farmId,
            type: type,
            category: category,
            amount: amount,
            description: description,
            date: date,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$FinanceTransactionTableTable,
                        FinanceTransactionTableData>(table),
                    BaseReferences<_$AppDatabase, $FinanceTransactionTableTable,
                        FinanceTransactionTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinanceTransactionTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $FinanceTransactionTableTable,
        FinanceTransactionTableData,
        $$FinanceTransactionTableTableFilterComposer,
        $$FinanceTransactionTableTableOrderingComposer,
        $$FinanceTransactionTableTableAnnotationComposer,
        $$FinanceTransactionTableTableCreateCompanionBuilder,
        $$FinanceTransactionTableTableUpdateCompanionBuilder,
        (
          FinanceTransactionTableData,
          BaseReferences<_$AppDatabase, $FinanceTransactionTableTable,
              FinanceTransactionTableData>
        ),
        FinanceTransactionTableData,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FlockTableTableTableManager get flockTable =>
      $$FlockTableTableTableManager(_db, _db.flockTable);
  $$BatchTableTableTableManager get batchTable =>
      $$BatchTableTableTableManager(_db, _db.batchTable);
  $$EggRecordTableTableTableManager get eggRecordTable =>
      $$EggRecordTableTableTableManager(_db, _db.eggRecordTable);
  $$EggSaleTableTableTableManager get eggSaleTable =>
      $$EggSaleTableTableTableManager(_db, _db.eggSaleTable);
  $$FeedTypeTableTableTableManager get feedTypeTable =>
      $$FeedTypeTableTableTableManager(_db, _db.feedTypeTable);
  $$FeedLogTableTableTableManager get feedLogTable =>
      $$FeedLogTableTableTableManager(_db, _db.feedLogTable);
  $$HealthRecordTableTableTableManager get healthRecordTable =>
      $$HealthRecordTableTableTableManager(_db, _db.healthRecordTable);
  $$VaccinationScheduleTableTableTableManager get vaccinationScheduleTable =>
      $$VaccinationScheduleTableTableTableManager(
          _db, _db.vaccinationScheduleTable);
  $$MedicineStockTableTableTableManager get medicineStockTable =>
      $$MedicineStockTableTableTableManager(_db, _db.medicineStockTable);
  $$FinanceTransactionTableTableTableManager get financeTransactionTable =>
      $$FinanceTransactionTableTableTableManager(
          _db, _db.financeTransactionTable);
}
