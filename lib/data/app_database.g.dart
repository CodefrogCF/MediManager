// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($MedicationsTable.$convertercreatedAt);
  @override
  List<GeneratedColumn> get $columns => [id, name, dosage, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medication> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: $MedicationsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const _UtcTimestampConverter();
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> dosage;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MedicationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.dosage = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Medication> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<bool>? isActive,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MedicationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? dosage,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $MedicationsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MedicationDetailsTable extends MedicationDetails
    with TableInfo<$MedicationDetailsTable, MedicationDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<int> medicationId = GeneratedColumn<int>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, int> startsOn =
      GeneratedColumn<int>(
        'starts_on',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>($MedicationDetailsTable.$converterstartsOn);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [medicationId, startsOn, name, dosage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationDetail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {medicationId, startsOn};
  @override
  MedicationDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationDetail(
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medication_id'],
      )!,
      startsOn: $MedicationDetailsTable.$converterstartsOn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}starts_on'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      ),
    );
  }

  @override
  $MedicationDetailsTable createAlias(String alias) {
    return $MedicationDetailsTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDate, int> $converterstartsOn =
      const _LocalDateConverter();
}

class MedicationDetail extends DataClass
    implements Insertable<MedicationDetail> {
  final int medicationId;
  final LocalDate startsOn;
  final String name;
  final String? dosage;
  const MedicationDetail({
    required this.medicationId,
    required this.startsOn,
    required this.name,
    this.dosage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['medication_id'] = Variable<int>(medicationId);
    {
      map['starts_on'] = Variable<int>(
        $MedicationDetailsTable.$converterstartsOn.toSql(startsOn),
      );
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<String>(dosage);
    }
    return map;
  }

  MedicationDetailsCompanion toCompanion(bool nullToAbsent) {
    return MedicationDetailsCompanion(
      medicationId: Value(medicationId),
      startsOn: Value(startsOn),
      name: Value(name),
      dosage: dosage == null && nullToAbsent
          ? const Value.absent()
          : Value(dosage),
    );
  }

  factory MedicationDetail.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationDetail(
      medicationId: serializer.fromJson<int>(json['medicationId']),
      startsOn: serializer.fromJson<LocalDate>(json['startsOn']),
      name: serializer.fromJson<String>(json['name']),
      dosage: serializer.fromJson<String?>(json['dosage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'medicationId': serializer.toJson<int>(medicationId),
      'startsOn': serializer.toJson<LocalDate>(startsOn),
      'name': serializer.toJson<String>(name),
      'dosage': serializer.toJson<String?>(dosage),
    };
  }

  MedicationDetail copyWith({
    int? medicationId,
    LocalDate? startsOn,
    String? name,
    Value<String?> dosage = const Value.absent(),
  }) => MedicationDetail(
    medicationId: medicationId ?? this.medicationId,
    startsOn: startsOn ?? this.startsOn,
    name: name ?? this.name,
    dosage: dosage.present ? dosage.value : this.dosage,
  );
  MedicationDetail copyWithCompanion(MedicationDetailsCompanion data) {
    return MedicationDetail(
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      startsOn: data.startsOn.present ? data.startsOn.value : this.startsOn,
      name: data.name.present ? data.name.value : this.name,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationDetail(')
          ..write('medicationId: $medicationId, ')
          ..write('startsOn: $startsOn, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(medicationId, startsOn, name, dosage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationDetail &&
          other.medicationId == this.medicationId &&
          other.startsOn == this.startsOn &&
          other.name == this.name &&
          other.dosage == this.dosage);
}

class MedicationDetailsCompanion extends UpdateCompanion<MedicationDetail> {
  final Value<int> medicationId;
  final Value<LocalDate> startsOn;
  final Value<String> name;
  final Value<String?> dosage;
  final Value<int> rowid;
  const MedicationDetailsCompanion({
    this.medicationId = const Value.absent(),
    this.startsOn = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationDetailsCompanion.insert({
    required int medicationId,
    required LocalDate startsOn,
    required String name,
    this.dosage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : medicationId = Value(medicationId),
       startsOn = Value(startsOn),
       name = Value(name);
  static Insertable<MedicationDetail> custom({
    Expression<int>? medicationId,
    Expression<int>? startsOn,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (medicationId != null) 'medication_id': medicationId,
      if (startsOn != null) 'starts_on': startsOn,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationDetailsCompanion copyWith({
    Value<int>? medicationId,
    Value<LocalDate>? startsOn,
    Value<String>? name,
    Value<String?>? dosage,
    Value<int>? rowid,
  }) {
    return MedicationDetailsCompanion(
      medicationId: medicationId ?? this.medicationId,
      startsOn: startsOn ?? this.startsOn,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (medicationId.present) {
      map['medication_id'] = Variable<int>(medicationId.value);
    }
    if (startsOn.present) {
      map['starts_on'] = Variable<int>(
        $MedicationDetailsTable.$converterstartsOn.toSql(startsOn.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationDetailsCompanion(')
          ..write('medicationId: $medicationId, ')
          ..write('startsOn: $startsOn, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationSchedulesTable extends MedicationSchedules
    with TableInfo<$MedicationSchedulesTable, MedicationSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<int> medicationId = GeneratedColumn<int>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Recurrence, int> recurrence =
      GeneratedColumn<int>(
        'recurrence',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Recurrence>(
        $MedicationSchedulesTable.$converterrecurrence,
      );
  static const VerificationMeta _minutesAfterMidnightMeta =
      const VerificationMeta('minutesAfterMidnight');
  @override
  late final GeneratedColumn<int> minutesAfterMidnight = GeneratedColumn<int>(
    'minutes_after_midnight',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, int> startsOn =
      GeneratedColumn<int>(
        'starts_on',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>($MedicationSchedulesTable.$converterstartsOn);
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate?, int> endsBefore =
      GeneratedColumn<int>(
        'ends_before',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<LocalDate?>(
        $MedicationSchedulesTable.$converterendsBeforen,
      );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medication_schedules (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    recurrence,
    minutesAfterMidnight,
    startsOn,
    endsBefore,
    label,
    planId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationSchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('minutes_after_midnight')) {
      context.handle(
        _minutesAfterMidnightMeta,
        minutesAfterMidnight.isAcceptableOrUnknown(
          data['minutes_after_midnight']!,
          _minutesAfterMidnightMeta,
        ),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationSchedule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medication_id'],
      )!,
      recurrence: $MedicationSchedulesTable.$converterrecurrence.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}recurrence'],
        )!,
      ),
      minutesAfterMidnight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes_after_midnight'],
      ),
      startsOn: $MedicationSchedulesTable.$converterstartsOn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}starts_on'],
        )!,
      ),
      endsBefore: $MedicationSchedulesTable.$converterendsBeforen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}ends_before'],
        ),
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      ),
    );
  }

  @override
  $MedicationSchedulesTable createAlias(String alias) {
    return $MedicationSchedulesTable(attachedDatabase, alias);
  }

  static TypeConverter<Recurrence, int> $converterrecurrence =
      const _RecurrenceConverter();
  static TypeConverter<LocalDate, int> $converterstartsOn =
      const _LocalDateConverter();
  static TypeConverter<LocalDate, int> $converterendsBefore =
      const _LocalDateConverter();
  static TypeConverter<LocalDate?, int?> $converterendsBeforen =
      NullAwareTypeConverter.wrap($converterendsBefore);
}

class MedicationSchedulesCompanion extends UpdateCompanion<MedicationSchedule> {
  final Value<int> id;
  final Value<int> medicationId;
  final Value<Recurrence> recurrence;
  final Value<int?> minutesAfterMidnight;
  final Value<LocalDate> startsOn;
  final Value<LocalDate?> endsBefore;
  final Value<String?> label;
  final Value<int?> planId;
  const MedicationSchedulesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.minutesAfterMidnight = const Value.absent(),
    this.startsOn = const Value.absent(),
    this.endsBefore = const Value.absent(),
    this.label = const Value.absent(),
    this.planId = const Value.absent(),
  });
  MedicationSchedulesCompanion.insert({
    this.id = const Value.absent(),
    required int medicationId,
    required Recurrence recurrence,
    this.minutesAfterMidnight = const Value.absent(),
    required LocalDate startsOn,
    this.endsBefore = const Value.absent(),
    this.label = const Value.absent(),
    this.planId = const Value.absent(),
  }) : medicationId = Value(medicationId),
       recurrence = Value(recurrence),
       startsOn = Value(startsOn);
  static Insertable<MedicationSchedule> custom({
    Expression<int>? id,
    Expression<int>? medicationId,
    Expression<int>? recurrence,
    Expression<int>? minutesAfterMidnight,
    Expression<int>? startsOn,
    Expression<int>? endsBefore,
    Expression<String>? label,
    Expression<int>? planId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (recurrence != null) 'recurrence': recurrence,
      if (minutesAfterMidnight != null)
        'minutes_after_midnight': minutesAfterMidnight,
      if (startsOn != null) 'starts_on': startsOn,
      if (endsBefore != null) 'ends_before': endsBefore,
      if (label != null) 'label': label,
      if (planId != null) 'plan_id': planId,
    });
  }

  MedicationSchedulesCompanion copyWith({
    Value<int>? id,
    Value<int>? medicationId,
    Value<Recurrence>? recurrence,
    Value<int?>? minutesAfterMidnight,
    Value<LocalDate>? startsOn,
    Value<LocalDate?>? endsBefore,
    Value<String?>? label,
    Value<int?>? planId,
  }) {
    return MedicationSchedulesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      recurrence: recurrence ?? this.recurrence,
      minutesAfterMidnight: minutesAfterMidnight ?? this.minutesAfterMidnight,
      startsOn: startsOn ?? this.startsOn,
      endsBefore: endsBefore ?? this.endsBefore,
      label: label ?? this.label,
      planId: planId ?? this.planId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<int>(medicationId.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<int>(
        $MedicationSchedulesTable.$converterrecurrence.toSql(recurrence.value),
      );
    }
    if (minutesAfterMidnight.present) {
      map['minutes_after_midnight'] = Variable<int>(minutesAfterMidnight.value);
    }
    if (startsOn.present) {
      map['starts_on'] = Variable<int>(
        $MedicationSchedulesTable.$converterstartsOn.toSql(startsOn.value),
      );
    }
    if (endsBefore.present) {
      map['ends_before'] = Variable<int>(
        $MedicationSchedulesTable.$converterendsBeforen.toSql(endsBefore.value),
      );
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('recurrence: $recurrence, ')
          ..write('minutesAfterMidnight: $minutesAfterMidnight, ')
          ..write('startsOn: $startsOn, ')
          ..write('endsBefore: $endsBefore, ')
          ..write('label: $label, ')
          ..write('planId: $planId')
          ..write(')'))
        .toString();
  }
}

class $IntakeEventsTable extends IntakeEvents
    with TableInfo<$IntakeEventsTable, IntakeEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntakeEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<int> scheduleId = GeneratedColumn<int>(
    'schedule_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medication_schedules (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, int> scheduledDate =
      GeneratedColumn<int>(
        'scheduled_date',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>($IntakeEventsTable.$converterscheduledDate);
  @override
  late final GeneratedColumnWithTypeConverter<IntakeEventKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<IntakeEventKind>($IntakeEventsTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> recordedAt =
      GeneratedColumn<int>(
        'recorded_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($IntakeEventsTable.$converterrecordedAt);
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate?, int> recordedOn =
      GeneratedColumn<int>(
        'recorded_on',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<LocalDate?>($IntakeEventsTable.$converterrecordedOnn);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> reportedIntakeAt =
      GeneratedColumn<int>(
        'reported_intake_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>(
        $IntakeEventsTable.$converterreportedIntakeAtn,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scheduleId,
    scheduledDate,
    kind,
    recordedAt,
    recordedOn,
    reportedIntakeAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'intake_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<IntakeEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IntakeEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IntakeEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_id'],
      )!,
      scheduledDate: $IntakeEventsTable.$converterscheduledDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}scheduled_date'],
        )!,
      ),
      kind: $IntakeEventsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      recordedAt: $IntakeEventsTable.$converterrecordedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}recorded_at'],
        )!,
      ),
      recordedOn: $IntakeEventsTable.$converterrecordedOnn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}recorded_on'],
        ),
      ),
      reportedIntakeAt: $IntakeEventsTable.$converterreportedIntakeAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}reported_intake_at'],
        ),
      ),
    );
  }

  @override
  $IntakeEventsTable createAlias(String alias) {
    return $IntakeEventsTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDate, int> $converterscheduledDate =
      const _LocalDateConverter();
  static JsonTypeConverter2<IntakeEventKind, String, String> $converterkind =
      const EnumNameConverter<IntakeEventKind>(IntakeEventKind.values);
  static TypeConverter<DateTime, int> $converterrecordedAt =
      const _UtcTimestampConverter();
  static TypeConverter<LocalDate, int> $converterrecordedOn =
      const _LocalDateConverter();
  static TypeConverter<LocalDate?, int?> $converterrecordedOnn =
      NullAwareTypeConverter.wrap($converterrecordedOn);
  static TypeConverter<DateTime, int> $converterreportedIntakeAt =
      const _UtcTimestampConverter();
  static TypeConverter<DateTime?, int?> $converterreportedIntakeAtn =
      NullAwareTypeConverter.wrap($converterreportedIntakeAt);
}

class IntakeEventsCompanion extends UpdateCompanion<IntakeEvent> {
  final Value<int> id;
  final Value<int> scheduleId;
  final Value<LocalDate> scheduledDate;
  final Value<IntakeEventKind> kind;
  final Value<DateTime> recordedAt;
  final Value<LocalDate?> recordedOn;
  final Value<DateTime?> reportedIntakeAt;
  const IntakeEventsCompanion({
    this.id = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.kind = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.recordedOn = const Value.absent(),
    this.reportedIntakeAt = const Value.absent(),
  });
  IntakeEventsCompanion.insert({
    this.id = const Value.absent(),
    required int scheduleId,
    required LocalDate scheduledDate,
    required IntakeEventKind kind,
    required DateTime recordedAt,
    this.recordedOn = const Value.absent(),
    this.reportedIntakeAt = const Value.absent(),
  }) : scheduleId = Value(scheduleId),
       scheduledDate = Value(scheduledDate),
       kind = Value(kind),
       recordedAt = Value(recordedAt);
  static Insertable<IntakeEvent> custom({
    Expression<int>? id,
    Expression<int>? scheduleId,
    Expression<int>? scheduledDate,
    Expression<String>? kind,
    Expression<int>? recordedAt,
    Expression<int>? recordedOn,
    Expression<int>? reportedIntakeAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (kind != null) 'kind': kind,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (recordedOn != null) 'recorded_on': recordedOn,
      if (reportedIntakeAt != null) 'reported_intake_at': reportedIntakeAt,
    });
  }

  IntakeEventsCompanion copyWith({
    Value<int>? id,
    Value<int>? scheduleId,
    Value<LocalDate>? scheduledDate,
    Value<IntakeEventKind>? kind,
    Value<DateTime>? recordedAt,
    Value<LocalDate?>? recordedOn,
    Value<DateTime?>? reportedIntakeAt,
  }) {
    return IntakeEventsCompanion(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      kind: kind ?? this.kind,
      recordedAt: recordedAt ?? this.recordedAt,
      recordedOn: recordedOn ?? this.recordedOn,
      reportedIntakeAt: reportedIntakeAt ?? this.reportedIntakeAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<int>(scheduleId.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<int>(
        $IntakeEventsTable.$converterscheduledDate.toSql(scheduledDate.value),
      );
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $IntakeEventsTable.$converterkind.toSql(kind.value),
      );
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(
        $IntakeEventsTable.$converterrecordedAt.toSql(recordedAt.value),
      );
    }
    if (recordedOn.present) {
      map['recorded_on'] = Variable<int>(
        $IntakeEventsTable.$converterrecordedOnn.toSql(recordedOn.value),
      );
    }
    if (reportedIntakeAt.present) {
      map['reported_intake_at'] = Variable<int>(
        $IntakeEventsTable.$converterreportedIntakeAtn.toSql(
          reportedIntakeAt.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntakeEventsCompanion(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('kind: $kind, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('recordedOn: $recordedOn, ')
          ..write('reportedIntakeAt: $reportedIntakeAt')
          ..write(')'))
        .toString();
  }
}

class $SlotRemindersTable extends SlotReminders
    with TableInfo<$SlotRemindersTable, SlotReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SlotRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<int> scheduleId = GeneratedColumn<int>(
    'schedule_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medication_schedules (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _reminderMinuteMeta = const VerificationMeta(
    'reminderMinute',
  );
  @override
  late final GeneratedColumn<int> reminderMinute = GeneratedColumn<int>(
    'reminder_minute',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _snoozeMinutesMeta = const VerificationMeta(
    'snoozeMinutes',
  );
  @override
  late final GeneratedColumn<int> snoozeMinutes = GeneratedColumn<int>(
    'snooze_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> changedAt =
      GeneratedColumn<int>(
        'changed_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($SlotRemindersTable.$converterchangedAt);
  @override
  List<GeneratedColumn> get $columns => [
    scheduleId,
    enabled,
    reminderMinute,
    snoozeMinutes,
    changedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'slot_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<SlotReminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('reminder_minute')) {
      context.handle(
        _reminderMinuteMeta,
        reminderMinute.isAcceptableOrUnknown(
          data['reminder_minute']!,
          _reminderMinuteMeta,
        ),
      );
    }
    if (data.containsKey('snooze_minutes')) {
      context.handle(
        _snoozeMinutesMeta,
        snoozeMinutes.isAcceptableOrUnknown(
          data['snooze_minutes']!,
          _snoozeMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snoozeMinutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scheduleId};
  @override
  SlotReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SlotReminder(
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      reminderMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minute'],
      ),
      snoozeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snooze_minutes'],
      )!,
      changedAt: $SlotRemindersTable.$converterchangedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}changed_at'],
        )!,
      ),
    );
  }

  @override
  $SlotRemindersTable createAlias(String alias) {
    return $SlotRemindersTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterchangedAt =
      const _UtcTimestampConverter();
}

class SlotReminder extends DataClass implements Insertable<SlotReminder> {
  final int scheduleId;
  final bool enabled;
  final int? reminderMinute;
  final int snoozeMinutes;
  final DateTime changedAt;
  const SlotReminder({
    required this.scheduleId,
    required this.enabled,
    this.reminderMinute,
    required this.snoozeMinutes,
    required this.changedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['schedule_id'] = Variable<int>(scheduleId);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || reminderMinute != null) {
      map['reminder_minute'] = Variable<int>(reminderMinute);
    }
    map['snooze_minutes'] = Variable<int>(snoozeMinutes);
    {
      map['changed_at'] = Variable<int>(
        $SlotRemindersTable.$converterchangedAt.toSql(changedAt),
      );
    }
    return map;
  }

  SlotRemindersCompanion toCompanion(bool nullToAbsent) {
    return SlotRemindersCompanion(
      scheduleId: Value(scheduleId),
      enabled: Value(enabled),
      reminderMinute: reminderMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderMinute),
      snoozeMinutes: Value(snoozeMinutes),
      changedAt: Value(changedAt),
    );
  }

  factory SlotReminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SlotReminder(
      scheduleId: serializer.fromJson<int>(json['scheduleId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      reminderMinute: serializer.fromJson<int?>(json['reminderMinute']),
      snoozeMinutes: serializer.fromJson<int>(json['snoozeMinutes']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scheduleId': serializer.toJson<int>(scheduleId),
      'enabled': serializer.toJson<bool>(enabled),
      'reminderMinute': serializer.toJson<int?>(reminderMinute),
      'snoozeMinutes': serializer.toJson<int>(snoozeMinutes),
      'changedAt': serializer.toJson<DateTime>(changedAt),
    };
  }

  SlotReminder copyWith({
    int? scheduleId,
    bool? enabled,
    Value<int?> reminderMinute = const Value.absent(),
    int? snoozeMinutes,
    DateTime? changedAt,
  }) => SlotReminder(
    scheduleId: scheduleId ?? this.scheduleId,
    enabled: enabled ?? this.enabled,
    reminderMinute: reminderMinute.present
        ? reminderMinute.value
        : this.reminderMinute,
    snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
    changedAt: changedAt ?? this.changedAt,
  );
  SlotReminder copyWithCompanion(SlotRemindersCompanion data) {
    return SlotReminder(
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      reminderMinute: data.reminderMinute.present
          ? data.reminderMinute.value
          : this.reminderMinute,
      snoozeMinutes: data.snoozeMinutes.present
          ? data.snoozeMinutes.value
          : this.snoozeMinutes,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SlotReminder(')
          ..write('scheduleId: $scheduleId, ')
          ..write('enabled: $enabled, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('snoozeMinutes: $snoozeMinutes, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    scheduleId,
    enabled,
    reminderMinute,
    snoozeMinutes,
    changedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SlotReminder &&
          other.scheduleId == this.scheduleId &&
          other.enabled == this.enabled &&
          other.reminderMinute == this.reminderMinute &&
          other.snoozeMinutes == this.snoozeMinutes &&
          other.changedAt == this.changedAt);
}

class SlotRemindersCompanion extends UpdateCompanion<SlotReminder> {
  final Value<int> scheduleId;
  final Value<bool> enabled;
  final Value<int?> reminderMinute;
  final Value<int> snoozeMinutes;
  final Value<DateTime> changedAt;
  const SlotRemindersCompanion({
    this.scheduleId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.reminderMinute = const Value.absent(),
    this.snoozeMinutes = const Value.absent(),
    this.changedAt = const Value.absent(),
  });
  SlotRemindersCompanion.insert({
    this.scheduleId = const Value.absent(),
    required bool enabled,
    this.reminderMinute = const Value.absent(),
    required int snoozeMinutes,
    required DateTime changedAt,
  }) : enabled = Value(enabled),
       snoozeMinutes = Value(snoozeMinutes),
       changedAt = Value(changedAt);
  static Insertable<SlotReminder> custom({
    Expression<int>? scheduleId,
    Expression<bool>? enabled,
    Expression<int>? reminderMinute,
    Expression<int>? snoozeMinutes,
    Expression<int>? changedAt,
  }) {
    return RawValuesInsertable({
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (enabled != null) 'enabled': enabled,
      if (reminderMinute != null) 'reminder_minute': reminderMinute,
      if (snoozeMinutes != null) 'snooze_minutes': snoozeMinutes,
      if (changedAt != null) 'changed_at': changedAt,
    });
  }

  SlotRemindersCompanion copyWith({
    Value<int>? scheduleId,
    Value<bool>? enabled,
    Value<int?>? reminderMinute,
    Value<int>? snoozeMinutes,
    Value<DateTime>? changedAt,
  }) {
    return SlotRemindersCompanion(
      scheduleId: scheduleId ?? this.scheduleId,
      enabled: enabled ?? this.enabled,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      changedAt: changedAt ?? this.changedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scheduleId.present) {
      map['schedule_id'] = Variable<int>(scheduleId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (reminderMinute.present) {
      map['reminder_minute'] = Variable<int>(reminderMinute.value);
    }
    if (snoozeMinutes.present) {
      map['snooze_minutes'] = Variable<int>(snoozeMinutes.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<int>(
        $SlotRemindersTable.$converterchangedAt.toSql(changedAt.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SlotRemindersCompanion(')
          ..write('scheduleId: $scheduleId, ')
          ..write('enabled: $enabled, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('snoozeMinutes: $snoozeMinutes, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }
}

class $ReminderOccurrencesTable extends ReminderOccurrences
    with TableInfo<$ReminderOccurrencesTable, ReminderOccurrence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderOccurrencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<int> scheduleId = GeneratedColumn<int>(
    'schedule_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medication_schedules (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, int> scheduledDate =
      GeneratedColumn<int>(
        'scheduled_date',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>(
        $ReminderOccurrencesTable.$converterscheduledDate,
      );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> snoozedUntil =
      GeneratedColumn<int>(
        'snoozed_until',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>(
        $ReminderOccurrencesTable.$convertersnoozedUntiln,
      );
  static const VerificationMeta _actionTokenMeta = const VerificationMeta(
    'actionToken',
  );
  @override
  late final GeneratedColumn<String> actionToken = GeneratedColumn<String>(
    'action_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latestEventIdMeta = const VerificationMeta(
    'latestEventId',
  );
  @override
  late final GeneratedColumn<int> latestEventId = GeneratedColumn<int>(
    'latest_event_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    scheduleId,
    scheduledDate,
    snoozedUntil,
    actionToken,
    latestEventId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_occurrences';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderOccurrence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('action_token')) {
      context.handle(
        _actionTokenMeta,
        actionToken.isAcceptableOrUnknown(
          data['action_token']!,
          _actionTokenMeta,
        ),
      );
    }
    if (data.containsKey('latest_event_id')) {
      context.handle(
        _latestEventIdMeta,
        latestEventId.isAcceptableOrUnknown(
          data['latest_event_id']!,
          _latestEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_latestEventIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scheduleId, scheduledDate};
  @override
  ReminderOccurrence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderOccurrence(
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_id'],
      )!,
      scheduledDate: $ReminderOccurrencesTable.$converterscheduledDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}scheduled_date'],
        )!,
      ),
      snoozedUntil: $ReminderOccurrencesTable.$convertersnoozedUntiln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}snoozed_until'],
        ),
      ),
      actionToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_token'],
      ),
      latestEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}latest_event_id'],
      )!,
    );
  }

  @override
  $ReminderOccurrencesTable createAlias(String alias) {
    return $ReminderOccurrencesTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDate, int> $converterscheduledDate =
      const _LocalDateConverter();
  static TypeConverter<DateTime, int> $convertersnoozedUntil =
      const _UtcTimestampConverter();
  static TypeConverter<DateTime?, int?> $convertersnoozedUntiln =
      NullAwareTypeConverter.wrap($convertersnoozedUntil);
}

class ReminderOccurrence extends DataClass
    implements Insertable<ReminderOccurrence> {
  final int scheduleId;
  final LocalDate scheduledDate;
  final DateTime? snoozedUntil;
  final String? actionToken;
  final int latestEventId;
  const ReminderOccurrence({
    required this.scheduleId,
    required this.scheduledDate,
    this.snoozedUntil,
    this.actionToken,
    required this.latestEventId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['schedule_id'] = Variable<int>(scheduleId);
    {
      map['scheduled_date'] = Variable<int>(
        $ReminderOccurrencesTable.$converterscheduledDate.toSql(scheduledDate),
      );
    }
    if (!nullToAbsent || snoozedUntil != null) {
      map['snoozed_until'] = Variable<int>(
        $ReminderOccurrencesTable.$convertersnoozedUntiln.toSql(snoozedUntil),
      );
    }
    if (!nullToAbsent || actionToken != null) {
      map['action_token'] = Variable<String>(actionToken);
    }
    map['latest_event_id'] = Variable<int>(latestEventId);
    return map;
  }

  ReminderOccurrencesCompanion toCompanion(bool nullToAbsent) {
    return ReminderOccurrencesCompanion(
      scheduleId: Value(scheduleId),
      scheduledDate: Value(scheduledDate),
      snoozedUntil: snoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozedUntil),
      actionToken: actionToken == null && nullToAbsent
          ? const Value.absent()
          : Value(actionToken),
      latestEventId: Value(latestEventId),
    );
  }

  factory ReminderOccurrence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderOccurrence(
      scheduleId: serializer.fromJson<int>(json['scheduleId']),
      scheduledDate: serializer.fromJson<LocalDate>(json['scheduledDate']),
      snoozedUntil: serializer.fromJson<DateTime?>(json['snoozedUntil']),
      actionToken: serializer.fromJson<String?>(json['actionToken']),
      latestEventId: serializer.fromJson<int>(json['latestEventId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scheduleId': serializer.toJson<int>(scheduleId),
      'scheduledDate': serializer.toJson<LocalDate>(scheduledDate),
      'snoozedUntil': serializer.toJson<DateTime?>(snoozedUntil),
      'actionToken': serializer.toJson<String?>(actionToken),
      'latestEventId': serializer.toJson<int>(latestEventId),
    };
  }

  ReminderOccurrence copyWith({
    int? scheduleId,
    LocalDate? scheduledDate,
    Value<DateTime?> snoozedUntil = const Value.absent(),
    Value<String?> actionToken = const Value.absent(),
    int? latestEventId,
  }) => ReminderOccurrence(
    scheduleId: scheduleId ?? this.scheduleId,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    snoozedUntil: snoozedUntil.present ? snoozedUntil.value : this.snoozedUntil,
    actionToken: actionToken.present ? actionToken.value : this.actionToken,
    latestEventId: latestEventId ?? this.latestEventId,
  );
  ReminderOccurrence copyWithCompanion(ReminderOccurrencesCompanion data) {
    return ReminderOccurrence(
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      snoozedUntil: data.snoozedUntil.present
          ? data.snoozedUntil.value
          : this.snoozedUntil,
      actionToken: data.actionToken.present
          ? data.actionToken.value
          : this.actionToken,
      latestEventId: data.latestEventId.present
          ? data.latestEventId.value
          : this.latestEventId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderOccurrence(')
          ..write('scheduleId: $scheduleId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('actionToken: $actionToken, ')
          ..write('latestEventId: $latestEventId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    scheduleId,
    scheduledDate,
    snoozedUntil,
    actionToken,
    latestEventId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderOccurrence &&
          other.scheduleId == this.scheduleId &&
          other.scheduledDate == this.scheduledDate &&
          other.snoozedUntil == this.snoozedUntil &&
          other.actionToken == this.actionToken &&
          other.latestEventId == this.latestEventId);
}

class ReminderOccurrencesCompanion extends UpdateCompanion<ReminderOccurrence> {
  final Value<int> scheduleId;
  final Value<LocalDate> scheduledDate;
  final Value<DateTime?> snoozedUntil;
  final Value<String?> actionToken;
  final Value<int> latestEventId;
  final Value<int> rowid;
  const ReminderOccurrencesCompanion({
    this.scheduleId = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.actionToken = const Value.absent(),
    this.latestEventId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderOccurrencesCompanion.insert({
    required int scheduleId,
    required LocalDate scheduledDate,
    this.snoozedUntil = const Value.absent(),
    this.actionToken = const Value.absent(),
    required int latestEventId,
    this.rowid = const Value.absent(),
  }) : scheduleId = Value(scheduleId),
       scheduledDate = Value(scheduledDate),
       latestEventId = Value(latestEventId);
  static Insertable<ReminderOccurrence> custom({
    Expression<int>? scheduleId,
    Expression<int>? scheduledDate,
    Expression<int>? snoozedUntil,
    Expression<String>? actionToken,
    Expression<int>? latestEventId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (snoozedUntil != null) 'snoozed_until': snoozedUntil,
      if (actionToken != null) 'action_token': actionToken,
      if (latestEventId != null) 'latest_event_id': latestEventId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderOccurrencesCompanion copyWith({
    Value<int>? scheduleId,
    Value<LocalDate>? scheduledDate,
    Value<DateTime?>? snoozedUntil,
    Value<String?>? actionToken,
    Value<int>? latestEventId,
    Value<int>? rowid,
  }) {
    return ReminderOccurrencesCompanion(
      scheduleId: scheduleId ?? this.scheduleId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      actionToken: actionToken ?? this.actionToken,
      latestEventId: latestEventId ?? this.latestEventId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scheduleId.present) {
      map['schedule_id'] = Variable<int>(scheduleId.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<int>(
        $ReminderOccurrencesTable.$converterscheduledDate.toSql(
          scheduledDate.value,
        ),
      );
    }
    if (snoozedUntil.present) {
      map['snoozed_until'] = Variable<int>(
        $ReminderOccurrencesTable.$convertersnoozedUntiln.toSql(
          snoozedUntil.value,
        ),
      );
    }
    if (actionToken.present) {
      map['action_token'] = Variable<String>(actionToken.value);
    }
    if (latestEventId.present) {
      map['latest_event_id'] = Variable<int>(latestEventId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderOccurrencesCompanion(')
          ..write('scheduleId: $scheduleId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('actionToken: $actionToken, ')
          ..write('latestEventId: $latestEventId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accentMeta = const VerificationMeta('accent');
  @override
  late final GeneratedColumn<String> accent = GeneratedColumn<String>(
    'accent',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, themeMode, accent, language];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    } else if (isInserting) {
      context.missing(_themeModeMeta);
    }
    if (data.containsKey('accent')) {
      context.handle(
        _accentMeta,
        accent.isAcceptableOrUnknown(data['accent']!, _accentMeta),
      );
    } else if (isInserting) {
      context.missing(_accentMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      accent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accent'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String themeMode;
  final String accent;
  final String language;
  const AppSetting({
    required this.id,
    required this.themeMode,
    required this.accent,
    required this.language,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['accent'] = Variable<String>(accent);
    map['language'] = Variable<String>(language);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      accent: Value(accent),
      language: Value(language),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      accent: serializer.fromJson<String>(json['accent']),
      language: serializer.fromJson<String>(json['language']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'accent': serializer.toJson<String>(accent),
      'language': serializer.toJson<String>(language),
    };
  }

  AppSetting copyWith({
    int? id,
    String? themeMode,
    String? accent,
    String? language,
  }) => AppSetting(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    accent: accent ?? this.accent,
    language: language ?? this.language,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      accent: data.accent.present ? data.accent.value : this.accent,
      language: data.language.present ? data.language.value : this.language,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('accent: $accent, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, themeMode, accent, language);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.accent == this.accent &&
          other.language == this.language);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<String> accent;
  final Value<String> language;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accent = const Value.absent(),
    this.language = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String themeMode,
    required String accent,
    required String language,
  }) : themeMode = Value(themeMode),
       accent = Value(accent),
       language = Value(language);
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<String>? accent,
    Expression<String>? language,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (accent != null) 'accent': accent,
      if (language != null) 'language': language,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<String>? accent,
    Value<String>? language,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      accent: accent ?? this.accent,
      language: language ?? this.language,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (accent.present) {
      map['accent'] = Variable<String>(accent.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('accent: $accent, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedicationDetailsTable medicationDetails =
      $MedicationDetailsTable(this);
  late final $MedicationSchedulesTable medicationSchedules =
      $MedicationSchedulesTable(this);
  late final $IntakeEventsTable intakeEvents = $IntakeEventsTable(this);
  late final $SlotRemindersTable slotReminders = $SlotRemindersTable(this);
  late final $ReminderOccurrencesTable reminderOccurrences =
      $ReminderOccurrencesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final Index schedulesByMedication = Index(
    'schedules_by_medication',
    'CREATE INDEX schedules_by_medication ON medication_schedules (medication_id, starts_on)',
  );
  late final Index eventsByIntake = Index(
    'events_by_intake',
    'CREATE INDEX events_by_intake ON intake_events (schedule_id, scheduled_date, id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    medications,
    medicationDetails,
    medicationSchedules,
    intakeEvents,
    slotReminders,
    reminderOccurrences,
    appSettings,
    schedulesByMedication,
    eventsByIntake,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('medication_details', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medication_schedules',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('slot_reminders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medication_schedules',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminder_occurrences', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> dosage,
      Value<bool> isActive,
      required DateTime createdAt,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> dosage,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, Medication> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicationDetailsTable, List<MedicationDetail>>
  _medicationDetailsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.medicationDetails,
        aliasName: 'medications__id__medication_details__medication_id',
      );

  $$MedicationDetailsTableProcessedTableManager get medicationDetailsRefs {
    final manager = $$MedicationDetailsTableTableManager(
      $_db,
      $_db.medicationDetails,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _medicationDetailsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MedicationSchedulesTable,
    List<MedicationSchedule>
  >
  _medicationSchedulesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.medicationSchedules,
        aliasName: 'medications__id__medication_schedules__medication_id',
      );

  $$MedicationSchedulesTableProcessedTableManager get medicationSchedulesRefs {
    final manager = $$MedicationSchedulesTableTableManager(
      $_db,
      $_db.medicationSchedules,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _medicationSchedulesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> medicationDetailsRefs(
    Expression<bool> Function($$MedicationDetailsTableFilterComposer f) f,
  ) {
    final $$MedicationDetailsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationDetails,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationDetailsTableFilterComposer(
            $db: $db,
            $table: $db.medicationDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicationSchedulesRefs(
    Expression<bool> Function($$MedicationSchedulesTableFilterComposer f) f,
  ) {
    final $$MedicationSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationSchedules,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.medicationSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> medicationDetailsRefs<T extends Object>(
    Expression<T> Function($$MedicationDetailsTableAnnotationComposer a) f,
  ) {
    final $$MedicationDetailsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.medicationDetails,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationDetailsTableAnnotationComposer(
                $db: $db,
                $table: $db.medicationDetails,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> medicationSchedulesRefs<T extends Object>(
    Expression<T> Function($$MedicationSchedulesTableAnnotationComposer a) f,
  ) {
    final $$MedicationSchedulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.medicationSchedules,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationSchedulesTableAnnotationComposer(
                $db: $db,
                $table: $db.medicationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          Medication,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (Medication, $$MedicationsTableReferences),
          Medication,
          PrefetchHooks Function({
            bool medicationDetailsRefs,
            bool medicationSchedulesRefs,
          })
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> dosage = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                name: name,
                dosage: dosage,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> dosage = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
              }) => MedicationsCompanion.insert(
                id: id,
                name: name,
                dosage: dosage,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationsTable, Medication>(table),
                  $$MedicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                medicationDetailsRefs = false,
                medicationSchedulesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (medicationDetailsRefs) db.medicationDetails,
                    if (medicationSchedulesRefs) db.medicationSchedules,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (medicationDetailsRefs)
                        await $_getPrefetchedDataByColumns<
                          Medication,
                          $MedicationsTable,
                          MedicationDetail,
                          $MedicationDetailsTable
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationsTableReferences
                              ._medicationDetailsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).medicationDetailsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'medication_id',
                          typedResults: items,
                        ),
                      if (medicationSchedulesRefs)
                        await $_getPrefetchedDataByColumns<
                          Medication,
                          $MedicationsTable,
                          MedicationSchedule,
                          $MedicationSchedulesTable
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationsTableReferences
                              ._medicationSchedulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).medicationSchedulesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'medication_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      Medication,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (Medication, $$MedicationsTableReferences),
      Medication,
      PrefetchHooks Function({
        bool medicationDetailsRefs,
        bool medicationSchedulesRefs,
      })
    >;
typedef $$MedicationDetailsTableCreateCompanionBuilder =
    MedicationDetailsCompanion Function({
      required int medicationId,
      required LocalDate startsOn,
      required String name,
      Value<String?> dosage,
      Value<int> rowid,
    });
typedef $$MedicationDetailsTableUpdateCompanionBuilder =
    MedicationDetailsCompanion Function({
      Value<int> medicationId,
      Value<LocalDate> startsOn,
      Value<String> name,
      Value<String?> dosage,
      Value<int> rowid,
    });

final class $$MedicationDetailsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MedicationDetailsTable,
          MedicationDetail
        > {
  $$MedicationDetailsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) => db
      .medications
      .createAlias('medication_details__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<int>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationDetailsTable> {
  $$MedicationDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<LocalDate, LocalDate, int> get startsOn =>
      $composableBuilder(
        column: $table.startsOn,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationDetailsTable> {
  $$MedicationDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get startsOn => $composableBuilder(
    column: $table.startsOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationDetailsTable> {
  $$MedicationDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<LocalDate, int> get startsOn =>
      $composableBuilder(column: $table.startsOn, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationDetailsTable,
          MedicationDetail,
          $$MedicationDetailsTableFilterComposer,
          $$MedicationDetailsTableOrderingComposer,
          $$MedicationDetailsTableAnnotationComposer,
          $$MedicationDetailsTableCreateCompanionBuilder,
          $$MedicationDetailsTableUpdateCompanionBuilder,
          (MedicationDetail, $$MedicationDetailsTableReferences),
          MedicationDetail,
          PrefetchHooks Function({bool medicationId})
        > {
  $$MedicationDetailsTableTableManager(
    _$AppDatabase db,
    $MedicationDetailsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationDetailsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> medicationId = const Value.absent(),
                Value<LocalDate> startsOn = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> dosage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationDetailsCompanion(
                medicationId: medicationId,
                startsOn: startsOn,
                name: name,
                dosage: dosage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int medicationId,
                required LocalDate startsOn,
                required String name,
                Value<String?> dosage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationDetailsCompanion.insert(
                medicationId: medicationId,
                startsOn: startsOn,
                name: name,
                dosage: dosage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationDetailsTable, MedicationDetail>(table),
                  $$MedicationDetailsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicationId,
                        referencedTable: $$MedicationDetailsTableReferences
                            ._medicationIdTable(db),
                        referencedColumn: $$MedicationDetailsTableReferences
                            ._medicationIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicationDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationDetailsTable,
      MedicationDetail,
      $$MedicationDetailsTableFilterComposer,
      $$MedicationDetailsTableOrderingComposer,
      $$MedicationDetailsTableAnnotationComposer,
      $$MedicationDetailsTableCreateCompanionBuilder,
      $$MedicationDetailsTableUpdateCompanionBuilder,
      (MedicationDetail, $$MedicationDetailsTableReferences),
      MedicationDetail,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$MedicationSchedulesTableCreateCompanionBuilder =
    MedicationSchedulesCompanion Function({
      Value<int> id,
      required int medicationId,
      required Recurrence recurrence,
      Value<int?> minutesAfterMidnight,
      required LocalDate startsOn,
      Value<LocalDate?> endsBefore,
      Value<String?> label,
      Value<int?> planId,
    });
typedef $$MedicationSchedulesTableUpdateCompanionBuilder =
    MedicationSchedulesCompanion Function({
      Value<int> id,
      Value<int> medicationId,
      Value<Recurrence> recurrence,
      Value<int?> minutesAfterMidnight,
      Value<LocalDate> startsOn,
      Value<LocalDate?> endsBefore,
      Value<String?> label,
      Value<int?> planId,
    });

final class $$MedicationSchedulesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MedicationSchedulesTable,
          MedicationSchedule
        > {
  $$MedicationSchedulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) => db
      .medications
      .createAlias('medication_schedules__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<int>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MedicationSchedulesTable _planIdTable(_$AppDatabase db) => db
      .medicationSchedules
      .createAlias('medication_schedules__plan_id__medication_schedules__id');

  $$MedicationSchedulesTableProcessedTableManager? get planId {
    final $_column = $_itemColumn<int>('plan_id');
    if ($_column == null) return null;
    final manager = $$MedicationSchedulesTableTableManager(
      $_db,
      $_db.medicationSchedules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$IntakeEventsTable, List<IntakeEvent>>
  _intakeEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.intakeEvents,
    aliasName: 'medication_schedules__id__intake_events__schedule_id',
  );

  $$IntakeEventsTableProcessedTableManager get intakeEventsRefs {
    final manager = $$IntakeEventsTableTableManager(
      $_db,
      $_db.intakeEvents,
    ).filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_intakeEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SlotRemindersTable, List<SlotReminder>>
  _slotRemindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.slotReminders,
    aliasName: 'medication_schedules__id__slot_reminders__schedule_id',
  );

  $$SlotRemindersTableProcessedTableManager get slotRemindersRefs {
    final manager = $$SlotRemindersTableTableManager(
      $_db,
      $_db.slotReminders,
    ).filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_slotRemindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ReminderOccurrencesTable,
    List<ReminderOccurrence>
  >
  _reminderOccurrencesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.reminderOccurrences,
        aliasName:
            'medication_schedules__id__reminder_occurrences__schedule_id',
      );

  $$ReminderOccurrencesTableProcessedTableManager get reminderOccurrencesRefs {
    final manager = $$ReminderOccurrencesTableTableManager(
      $_db,
      $_db.reminderOccurrences,
    ).filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reminderOccurrencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicationSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Recurrence, Recurrence, int> get recurrence =>
      $composableBuilder(
        column: $table.recurrence,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get minutesAfterMidnight => $composableBuilder(
    column: $table.minutesAfterMidnight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate, LocalDate, int> get startsOn =>
      $composableBuilder(
        column: $table.startsOn,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<LocalDate?, LocalDate, int> get endsBefore =>
      $composableBuilder(
        column: $table.endsBefore,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicationSchedulesTableFilterComposer get planId {
    final $$MedicationSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.medicationSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.medicationSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> intakeEventsRefs(
    Expression<bool> Function($$IntakeEventsTableFilterComposer f) f,
  ) {
    final $$IntakeEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.intakeEvents,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntakeEventsTableFilterComposer(
            $db: $db,
            $table: $db.intakeEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> slotRemindersRefs(
    Expression<bool> Function($$SlotRemindersTableFilterComposer f) f,
  ) {
    final $$SlotRemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.slotReminders,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlotRemindersTableFilterComposer(
            $db: $db,
            $table: $db.slotReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reminderOccurrencesRefs(
    Expression<bool> Function($$ReminderOccurrencesTableFilterComposer f) f,
  ) {
    final $$ReminderOccurrencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderOccurrences,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderOccurrencesTableFilterComposer(
            $db: $db,
            $table: $db.reminderOccurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutesAfterMidnight => $composableBuilder(
    column: $table.minutesAfterMidnight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startsOn => $composableBuilder(
    column: $table.startsOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endsBefore => $composableBuilder(
    column: $table.endsBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicationSchedulesTableOrderingComposer get planId {
    final $$MedicationSchedulesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.planId,
          referencedTable: $db.medicationSchedules,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationSchedulesTableOrderingComposer(
                $db: $db,
                $table: $db.medicationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$MedicationSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Recurrence, int> get recurrence =>
      $composableBuilder(
        column: $table.recurrence,
        builder: (column) => column,
      );

  GeneratedColumn<int> get minutesAfterMidnight => $composableBuilder(
    column: $table.minutesAfterMidnight,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LocalDate, int> get startsOn =>
      $composableBuilder(column: $table.startsOn, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDate?, int> get endsBefore =>
      $composableBuilder(
        column: $table.endsBefore,
        builder: (column) => column,
      );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicationSchedulesTableAnnotationComposer get planId {
    final $$MedicationSchedulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.planId,
          referencedTable: $db.medicationSchedules,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationSchedulesTableAnnotationComposer(
                $db: $db,
                $table: $db.medicationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> intakeEventsRefs<T extends Object>(
    Expression<T> Function($$IntakeEventsTableAnnotationComposer a) f,
  ) {
    final $$IntakeEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.intakeEvents,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntakeEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.intakeEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> slotRemindersRefs<T extends Object>(
    Expression<T> Function($$SlotRemindersTableAnnotationComposer a) f,
  ) {
    final $$SlotRemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.slotReminders,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlotRemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.slotReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reminderOccurrencesRefs<T extends Object>(
    Expression<T> Function($$ReminderOccurrencesTableAnnotationComposer a) f,
  ) {
    final $$ReminderOccurrencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.reminderOccurrences,
          getReferencedColumn: (t) => t.scheduleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReminderOccurrencesTableAnnotationComposer(
                $db: $db,
                $table: $db.reminderOccurrences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MedicationSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationSchedulesTable,
          MedicationSchedule,
          $$MedicationSchedulesTableFilterComposer,
          $$MedicationSchedulesTableOrderingComposer,
          $$MedicationSchedulesTableAnnotationComposer,
          $$MedicationSchedulesTableCreateCompanionBuilder,
          $$MedicationSchedulesTableUpdateCompanionBuilder,
          (MedicationSchedule, $$MedicationSchedulesTableReferences),
          MedicationSchedule,
          PrefetchHooks Function({
            bool medicationId,
            bool planId,
            bool intakeEventsRefs,
            bool slotRemindersRefs,
            bool reminderOccurrencesRefs,
          })
        > {
  $$MedicationSchedulesTableTableManager(
    _$AppDatabase db,
    $MedicationSchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationSchedulesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MedicationSchedulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> medicationId = const Value.absent(),
                Value<Recurrence> recurrence = const Value.absent(),
                Value<int?> minutesAfterMidnight = const Value.absent(),
                Value<LocalDate> startsOn = const Value.absent(),
                Value<LocalDate?> endsBefore = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int?> planId = const Value.absent(),
              }) => MedicationSchedulesCompanion(
                id: id,
                medicationId: medicationId,
                recurrence: recurrence,
                minutesAfterMidnight: minutesAfterMidnight,
                startsOn: startsOn,
                endsBefore: endsBefore,
                label: label,
                planId: planId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medicationId,
                required Recurrence recurrence,
                Value<int?> minutesAfterMidnight = const Value.absent(),
                required LocalDate startsOn,
                Value<LocalDate?> endsBefore = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int?> planId = const Value.absent(),
              }) => MedicationSchedulesCompanion.insert(
                id: id,
                medicationId: medicationId,
                recurrence: recurrence,
                minutesAfterMidnight: minutesAfterMidnight,
                startsOn: startsOn,
                endsBefore: endsBefore,
                label: label,
                planId: planId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationSchedulesTable, MedicationSchedule>(
                    table,
                  ),
                  $$MedicationSchedulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                medicationId = false,
                planId = false,
                intakeEventsRefs = false,
                slotRemindersRefs = false,
                reminderOccurrencesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (intakeEventsRefs) db.intakeEvents,
                    if (slotRemindersRefs) db.slotReminders,
                    if (reminderOccurrencesRefs) db.reminderOccurrences,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (medicationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable:
                                $$MedicationSchedulesTableReferences
                                    ._medicationIdTable(db),
                            referencedColumn:
                                $$MedicationSchedulesTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (planId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.planId,
                            referencedTable:
                                $$MedicationSchedulesTableReferences
                                    ._planIdTable(db),
                            referencedColumn:
                                $$MedicationSchedulesTableReferences
                                    ._planIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (intakeEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          MedicationSchedule,
                          $MedicationSchedulesTable,
                          IntakeEvent,
                          $IntakeEventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationSchedulesTableReferences
                              ._intakeEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationSchedulesTableReferences(
                                db,
                                table,
                                p0,
                              ).intakeEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'schedule_id',
                          typedResults: items,
                        ),
                      if (slotRemindersRefs)
                        await $_getPrefetchedDataByColumns<
                          MedicationSchedule,
                          $MedicationSchedulesTable,
                          SlotReminder,
                          $SlotRemindersTable
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationSchedulesTableReferences
                              ._slotRemindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationSchedulesTableReferences(
                                db,
                                table,
                                p0,
                              ).slotRemindersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'schedule_id',
                          typedResults: items,
                        ),
                      if (reminderOccurrencesRefs)
                        await $_getPrefetchedDataByColumns<
                          MedicationSchedule,
                          $MedicationSchedulesTable,
                          ReminderOccurrence,
                          $ReminderOccurrencesTable
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationSchedulesTableReferences
                              ._reminderOccurrencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationSchedulesTableReferences(
                                db,
                                table,
                                p0,
                              ).reminderOccurrencesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'schedule_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicationSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationSchedulesTable,
      MedicationSchedule,
      $$MedicationSchedulesTableFilterComposer,
      $$MedicationSchedulesTableOrderingComposer,
      $$MedicationSchedulesTableAnnotationComposer,
      $$MedicationSchedulesTableCreateCompanionBuilder,
      $$MedicationSchedulesTableUpdateCompanionBuilder,
      (MedicationSchedule, $$MedicationSchedulesTableReferences),
      MedicationSchedule,
      PrefetchHooks Function({
        bool medicationId,
        bool planId,
        bool intakeEventsRefs,
        bool slotRemindersRefs,
        bool reminderOccurrencesRefs,
      })
    >;
typedef $$IntakeEventsTableCreateCompanionBuilder =
    IntakeEventsCompanion Function({
      Value<int> id,
      required int scheduleId,
      required LocalDate scheduledDate,
      required IntakeEventKind kind,
      required DateTime recordedAt,
      Value<LocalDate?> recordedOn,
      Value<DateTime?> reportedIntakeAt,
    });
typedef $$IntakeEventsTableUpdateCompanionBuilder =
    IntakeEventsCompanion Function({
      Value<int> id,
      Value<int> scheduleId,
      Value<LocalDate> scheduledDate,
      Value<IntakeEventKind> kind,
      Value<DateTime> recordedAt,
      Value<LocalDate?> recordedOn,
      Value<DateTime?> reportedIntakeAt,
    });

final class $$IntakeEventsTableReferences
    extends BaseReferences<_$AppDatabase, $IntakeEventsTable, IntakeEvent> {
  $$IntakeEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicationSchedulesTable _scheduleIdTable(_$AppDatabase db) => db
      .medicationSchedules
      .createAlias('intake_events__schedule_id__medication_schedules__id');

  $$MedicationSchedulesTableProcessedTableManager get scheduleId {
    final $_column = $_itemColumn<int>('schedule_id')!;

    final manager = $$MedicationSchedulesTableTableManager(
      $_db,
      $_db.medicationSchedules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IntakeEventsTableFilterComposer
    extends Composer<_$AppDatabase, $IntakeEventsTable> {
  $$IntakeEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate, LocalDate, int> get scheduledDate =>
      $composableBuilder(
        column: $table.scheduledDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<IntakeEventKind, IntakeEventKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get recordedAt =>
      $composableBuilder(
        column: $table.recordedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<LocalDate?, LocalDate, int> get recordedOn =>
      $composableBuilder(
        column: $table.recordedOn,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int>
  get reportedIntakeAt => $composableBuilder(
    column: $table.reportedIntakeAt,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$MedicationSchedulesTableFilterComposer get scheduleId {
    final $$MedicationSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.medicationSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.medicationSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IntakeEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $IntakeEventsTable> {
  $$IntakeEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedOn => $composableBuilder(
    column: $table.recordedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reportedIntakeAt => $composableBuilder(
    column: $table.reportedIntakeAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationSchedulesTableOrderingComposer get scheduleId {
    final $$MedicationSchedulesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.scheduleId,
          referencedTable: $db.medicationSchedules,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationSchedulesTableOrderingComposer(
                $db: $db,
                $table: $db.medicationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$IntakeEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IntakeEventsTable> {
  $$IntakeEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDate, int> get scheduledDate =>
      $composableBuilder(
        column: $table.scheduledDate,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<IntakeEventKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get recordedAt =>
      $composableBuilder(
        column: $table.recordedAt,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<LocalDate?, int> get recordedOn =>
      $composableBuilder(
        column: $table.recordedOn,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DateTime?, int> get reportedIntakeAt =>
      $composableBuilder(
        column: $table.reportedIntakeAt,
        builder: (column) => column,
      );

  $$MedicationSchedulesTableAnnotationComposer get scheduleId {
    final $$MedicationSchedulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.scheduleId,
          referencedTable: $db.medicationSchedules,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationSchedulesTableAnnotationComposer(
                $db: $db,
                $table: $db.medicationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$IntakeEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IntakeEventsTable,
          IntakeEvent,
          $$IntakeEventsTableFilterComposer,
          $$IntakeEventsTableOrderingComposer,
          $$IntakeEventsTableAnnotationComposer,
          $$IntakeEventsTableCreateCompanionBuilder,
          $$IntakeEventsTableUpdateCompanionBuilder,
          (IntakeEvent, $$IntakeEventsTableReferences),
          IntakeEvent,
          PrefetchHooks Function({bool scheduleId})
        > {
  $$IntakeEventsTableTableManager(_$AppDatabase db, $IntakeEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IntakeEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IntakeEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IntakeEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> scheduleId = const Value.absent(),
                Value<LocalDate> scheduledDate = const Value.absent(),
                Value<IntakeEventKind> kind = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<LocalDate?> recordedOn = const Value.absent(),
                Value<DateTime?> reportedIntakeAt = const Value.absent(),
              }) => IntakeEventsCompanion(
                id: id,
                scheduleId: scheduleId,
                scheduledDate: scheduledDate,
                kind: kind,
                recordedAt: recordedAt,
                recordedOn: recordedOn,
                reportedIntakeAt: reportedIntakeAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int scheduleId,
                required LocalDate scheduledDate,
                required IntakeEventKind kind,
                required DateTime recordedAt,
                Value<LocalDate?> recordedOn = const Value.absent(),
                Value<DateTime?> reportedIntakeAt = const Value.absent(),
              }) => IntakeEventsCompanion.insert(
                id: id,
                scheduleId: scheduleId,
                scheduledDate: scheduledDate,
                kind: kind,
                recordedAt: recordedAt,
                recordedOn: recordedOn,
                reportedIntakeAt: reportedIntakeAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IntakeEventsTable, IntakeEvent>(table),
                  $$IntakeEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({scheduleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (scheduleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.scheduleId,
                        referencedTable: $$IntakeEventsTableReferences
                            ._scheduleIdTable(db),
                        referencedColumn: $$IntakeEventsTableReferences
                            ._scheduleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IntakeEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IntakeEventsTable,
      IntakeEvent,
      $$IntakeEventsTableFilterComposer,
      $$IntakeEventsTableOrderingComposer,
      $$IntakeEventsTableAnnotationComposer,
      $$IntakeEventsTableCreateCompanionBuilder,
      $$IntakeEventsTableUpdateCompanionBuilder,
      (IntakeEvent, $$IntakeEventsTableReferences),
      IntakeEvent,
      PrefetchHooks Function({bool scheduleId})
    >;
typedef $$SlotRemindersTableCreateCompanionBuilder =
    SlotRemindersCompanion Function({
      Value<int> scheduleId,
      required bool enabled,
      Value<int?> reminderMinute,
      required int snoozeMinutes,
      required DateTime changedAt,
    });
typedef $$SlotRemindersTableUpdateCompanionBuilder =
    SlotRemindersCompanion Function({
      Value<int> scheduleId,
      Value<bool> enabled,
      Value<int?> reminderMinute,
      Value<int> snoozeMinutes,
      Value<DateTime> changedAt,
    });

final class $$SlotRemindersTableReferences
    extends BaseReferences<_$AppDatabase, $SlotRemindersTable, SlotReminder> {
  $$SlotRemindersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationSchedulesTable _scheduleIdTable(_$AppDatabase db) => db
      .medicationSchedules
      .createAlias('slot_reminders__schedule_id__medication_schedules__id');

  $$MedicationSchedulesTableProcessedTableManager get scheduleId {
    final $_column = $_itemColumn<int>('schedule_id')!;

    final manager = $$MedicationSchedulesTableTableManager(
      $_db,
      $_db.medicationSchedules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SlotRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $SlotRemindersTable> {
  $$SlotRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get snoozeMinutes => $composableBuilder(
    column: $table.snoozeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get changedAt =>
      $composableBuilder(
        column: $table.changedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$MedicationSchedulesTableFilterComposer get scheduleId {
    final $$MedicationSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.medicationSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.medicationSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SlotRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $SlotRemindersTable> {
  $$SlotRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get snoozeMinutes => $composableBuilder(
    column: $table.snoozeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationSchedulesTableOrderingComposer get scheduleId {
    final $$MedicationSchedulesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.scheduleId,
          referencedTable: $db.medicationSchedules,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationSchedulesTableOrderingComposer(
                $db: $db,
                $table: $db.medicationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SlotRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SlotRemindersTable> {
  $$SlotRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get snoozeMinutes => $composableBuilder(
    column: $table.snoozeMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime, int> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  $$MedicationSchedulesTableAnnotationComposer get scheduleId {
    final $$MedicationSchedulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.scheduleId,
          referencedTable: $db.medicationSchedules,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationSchedulesTableAnnotationComposer(
                $db: $db,
                $table: $db.medicationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SlotRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SlotRemindersTable,
          SlotReminder,
          $$SlotRemindersTableFilterComposer,
          $$SlotRemindersTableOrderingComposer,
          $$SlotRemindersTableAnnotationComposer,
          $$SlotRemindersTableCreateCompanionBuilder,
          $$SlotRemindersTableUpdateCompanionBuilder,
          (SlotReminder, $$SlotRemindersTableReferences),
          SlotReminder,
          PrefetchHooks Function({bool scheduleId})
        > {
  $$SlotRemindersTableTableManager(_$AppDatabase db, $SlotRemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SlotRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SlotRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SlotRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> scheduleId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int?> reminderMinute = const Value.absent(),
                Value<int> snoozeMinutes = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
              }) => SlotRemindersCompanion(
                scheduleId: scheduleId,
                enabled: enabled,
                reminderMinute: reminderMinute,
                snoozeMinutes: snoozeMinutes,
                changedAt: changedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> scheduleId = const Value.absent(),
                required bool enabled,
                Value<int?> reminderMinute = const Value.absent(),
                required int snoozeMinutes,
                required DateTime changedAt,
              }) => SlotRemindersCompanion.insert(
                scheduleId: scheduleId,
                enabled: enabled,
                reminderMinute: reminderMinute,
                snoozeMinutes: snoozeMinutes,
                changedAt: changedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SlotRemindersTable, SlotReminder>(table),
                  $$SlotRemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({scheduleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (scheduleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.scheduleId,
                        referencedTable: $$SlotRemindersTableReferences
                            ._scheduleIdTable(db),
                        referencedColumn: $$SlotRemindersTableReferences
                            ._scheduleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SlotRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SlotRemindersTable,
      SlotReminder,
      $$SlotRemindersTableFilterComposer,
      $$SlotRemindersTableOrderingComposer,
      $$SlotRemindersTableAnnotationComposer,
      $$SlotRemindersTableCreateCompanionBuilder,
      $$SlotRemindersTableUpdateCompanionBuilder,
      (SlotReminder, $$SlotRemindersTableReferences),
      SlotReminder,
      PrefetchHooks Function({bool scheduleId})
    >;
typedef $$ReminderOccurrencesTableCreateCompanionBuilder =
    ReminderOccurrencesCompanion Function({
      required int scheduleId,
      required LocalDate scheduledDate,
      Value<DateTime?> snoozedUntil,
      Value<String?> actionToken,
      required int latestEventId,
      Value<int> rowid,
    });
typedef $$ReminderOccurrencesTableUpdateCompanionBuilder =
    ReminderOccurrencesCompanion Function({
      Value<int> scheduleId,
      Value<LocalDate> scheduledDate,
      Value<DateTime?> snoozedUntil,
      Value<String?> actionToken,
      Value<int> latestEventId,
      Value<int> rowid,
    });

final class $$ReminderOccurrencesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReminderOccurrencesTable,
          ReminderOccurrence
        > {
  $$ReminderOccurrencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationSchedulesTable _scheduleIdTable(_$AppDatabase db) =>
      db.medicationSchedules.createAlias(
        'reminder_occurrences__schedule_id__medication_schedules__id',
      );

  $$MedicationSchedulesTableProcessedTableManager get scheduleId {
    final $_column = $_itemColumn<int>('schedule_id')!;

    final manager = $$MedicationSchedulesTableTableManager(
      $_db,
      $_db.medicationSchedules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReminderOccurrencesTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderOccurrencesTable> {
  $$ReminderOccurrencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<LocalDate, LocalDate, int> get scheduledDate =>
      $composableBuilder(
        column: $table.scheduledDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get snoozedUntil =>
      $composableBuilder(
        column: $table.snoozedUntil,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get actionToken => $composableBuilder(
    column: $table.actionToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get latestEventId => $composableBuilder(
    column: $table.latestEventId,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationSchedulesTableFilterComposer get scheduleId {
    final $$MedicationSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.medicationSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.medicationSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderOccurrencesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderOccurrencesTable> {
  $$ReminderOccurrencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionToken => $composableBuilder(
    column: $table.actionToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get latestEventId => $composableBuilder(
    column: $table.latestEventId,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationSchedulesTableOrderingComposer get scheduleId {
    final $$MedicationSchedulesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.scheduleId,
          referencedTable: $db.medicationSchedules,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationSchedulesTableOrderingComposer(
                $db: $db,
                $table: $db.medicationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ReminderOccurrencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderOccurrencesTable> {
  $$ReminderOccurrencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<LocalDate, int> get scheduledDate =>
      $composableBuilder(
        column: $table.scheduledDate,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DateTime?, int> get snoozedUntil =>
      $composableBuilder(
        column: $table.snoozedUntil,
        builder: (column) => column,
      );

  GeneratedColumn<String> get actionToken => $composableBuilder(
    column: $table.actionToken,
    builder: (column) => column,
  );

  GeneratedColumn<int> get latestEventId => $composableBuilder(
    column: $table.latestEventId,
    builder: (column) => column,
  );

  $$MedicationSchedulesTableAnnotationComposer get scheduleId {
    final $$MedicationSchedulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.scheduleId,
          referencedTable: $db.medicationSchedules,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationSchedulesTableAnnotationComposer(
                $db: $db,
                $table: $db.medicationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ReminderOccurrencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderOccurrencesTable,
          ReminderOccurrence,
          $$ReminderOccurrencesTableFilterComposer,
          $$ReminderOccurrencesTableOrderingComposer,
          $$ReminderOccurrencesTableAnnotationComposer,
          $$ReminderOccurrencesTableCreateCompanionBuilder,
          $$ReminderOccurrencesTableUpdateCompanionBuilder,
          (ReminderOccurrence, $$ReminderOccurrencesTableReferences),
          ReminderOccurrence,
          PrefetchHooks Function({bool scheduleId})
        > {
  $$ReminderOccurrencesTableTableManager(
    _$AppDatabase db,
    $ReminderOccurrencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderOccurrencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderOccurrencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReminderOccurrencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> scheduleId = const Value.absent(),
                Value<LocalDate> scheduledDate = const Value.absent(),
                Value<DateTime?> snoozedUntil = const Value.absent(),
                Value<String?> actionToken = const Value.absent(),
                Value<int> latestEventId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderOccurrencesCompanion(
                scheduleId: scheduleId,
                scheduledDate: scheduledDate,
                snoozedUntil: snoozedUntil,
                actionToken: actionToken,
                latestEventId: latestEventId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int scheduleId,
                required LocalDate scheduledDate,
                Value<DateTime?> snoozedUntil = const Value.absent(),
                Value<String?> actionToken = const Value.absent(),
                required int latestEventId,
                Value<int> rowid = const Value.absent(),
              }) => ReminderOccurrencesCompanion.insert(
                scheduleId: scheduleId,
                scheduledDate: scheduledDate,
                snoozedUntil: snoozedUntil,
                actionToken: actionToken,
                latestEventId: latestEventId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReminderOccurrencesTable, ReminderOccurrence>(
                    table,
                  ),
                  $$ReminderOccurrencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({scheduleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (scheduleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.scheduleId,
                        referencedTable: $$ReminderOccurrencesTableReferences
                            ._scheduleIdTable(db),
                        referencedColumn: $$ReminderOccurrencesTableReferences
                            ._scheduleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReminderOccurrencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderOccurrencesTable,
      ReminderOccurrence,
      $$ReminderOccurrencesTableFilterComposer,
      $$ReminderOccurrencesTableOrderingComposer,
      $$ReminderOccurrencesTableAnnotationComposer,
      $$ReminderOccurrencesTableCreateCompanionBuilder,
      $$ReminderOccurrencesTableUpdateCompanionBuilder,
      (ReminderOccurrence, $$ReminderOccurrencesTableReferences),
      ReminderOccurrence,
      PrefetchHooks Function({bool scheduleId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      required String themeMode,
      required String accent,
      required String language,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<String> accent,
      Value<String> language,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get accent =>
      $composableBuilder(column: $table.accent, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> accent = const Value.absent(),
                Value<String> language = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                themeMode: themeMode,
                accent: accent,
                language: language,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String themeMode,
                required String accent,
                required String language,
              }) => AppSettingsCompanion.insert(
                id: id,
                themeMode: themeMode,
                accent: accent,
                language: language,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedicationDetailsTableTableManager get medicationDetails =>
      $$MedicationDetailsTableTableManager(_db, _db.medicationDetails);
  $$MedicationSchedulesTableTableManager get medicationSchedules =>
      $$MedicationSchedulesTableTableManager(_db, _db.medicationSchedules);
  $$IntakeEventsTableTableManager get intakeEvents =>
      $$IntakeEventsTableTableManager(_db, _db.intakeEvents);
  $$SlotRemindersTableTableManager get slotReminders =>
      $$SlotRemindersTableTableManager(_db, _db.slotReminders);
  $$ReminderOccurrencesTableTableManager get reminderOccurrences =>
      $$ReminderOccurrencesTableTableManager(_db, _db.reminderOccurrences);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
