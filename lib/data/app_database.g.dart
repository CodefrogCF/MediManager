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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    recurrence,
    minutesAfterMidnight,
    startsOn,
    endsBefore,
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
  const MedicationSchedulesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.minutesAfterMidnight = const Value.absent(),
    this.startsOn = const Value.absent(),
    this.endsBefore = const Value.absent(),
  });
  MedicationSchedulesCompanion.insert({
    this.id = const Value.absent(),
    required int medicationId,
    required Recurrence recurrence,
    this.minutesAfterMidnight = const Value.absent(),
    required LocalDate startsOn,
    this.endsBefore = const Value.absent(),
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (recurrence != null) 'recurrence': recurrence,
      if (minutesAfterMidnight != null)
        'minutes_after_midnight': minutesAfterMidnight,
      if (startsOn != null) 'starts_on': startsOn,
      if (endsBefore != null) 'ends_before': endsBefore,
    });
  }

  MedicationSchedulesCompanion copyWith({
    Value<int>? id,
    Value<int>? medicationId,
    Value<Recurrence>? recurrence,
    Value<int?>? minutesAfterMidnight,
    Value<LocalDate>? startsOn,
    Value<LocalDate?>? endsBefore,
  }) {
    return MedicationSchedulesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      recurrence: recurrence ?? this.recurrence,
      minutesAfterMidnight: minutesAfterMidnight ?? this.minutesAfterMidnight,
      startsOn: startsOn ?? this.startsOn,
      endsBefore: endsBefore ?? this.endsBefore,
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
          ..write('endsBefore: $endsBefore')
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
  final Value<DateTime?> reportedIntakeAt;
  const IntakeEventsCompanion({
    this.id = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.kind = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.reportedIntakeAt = const Value.absent(),
  });
  IntakeEventsCompanion.insert({
    this.id = const Value.absent(),
    required int scheduleId,
    required LocalDate scheduledDate,
    required IntakeEventKind kind,
    required DateTime recordedAt,
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
    Expression<int>? reportedIntakeAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (kind != null) 'kind': kind,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (reportedIntakeAt != null) 'reported_intake_at': reportedIntakeAt,
    });
  }

  IntakeEventsCompanion copyWith({
    Value<int>? id,
    Value<int>? scheduleId,
    Value<LocalDate>? scheduledDate,
    Value<IntakeEventKind>? kind,
    Value<DateTime>? recordedAt,
    Value<DateTime?>? reportedIntakeAt,
  }) {
    return IntakeEventsCompanion(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      kind: kind ?? this.kind,
      recordedAt: recordedAt ?? this.recordedAt,
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
          ..write('reportedIntakeAt: $reportedIntakeAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedicationSchedulesTable medicationSchedules =
      $MedicationSchedulesTable(this);
  late final $IntakeEventsTable intakeEvents = $IntakeEventsTable(this);
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
    medicationSchedules,
    intakeEvents,
    schedulesByMedication,
    eventsByIntake,
  ];
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
          PrefetchHooks Function({bool medicationSchedulesRefs})
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
          prefetchHooksCallback: ({medicationSchedulesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicationSchedulesRefs) db.medicationSchedules,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
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
      PrefetchHooks Function({bool medicationSchedulesRefs})
    >;
typedef $$MedicationSchedulesTableCreateCompanionBuilder =
    MedicationSchedulesCompanion Function({
      Value<int> id,
      required int medicationId,
      required Recurrence recurrence,
      Value<int?> minutesAfterMidnight,
      required LocalDate startsOn,
      Value<LocalDate?> endsBefore,
    });
typedef $$MedicationSchedulesTableUpdateCompanionBuilder =
    MedicationSchedulesCompanion Function({
      Value<int> id,
      Value<int> medicationId,
      Value<Recurrence> recurrence,
      Value<int?> minutesAfterMidnight,
      Value<LocalDate> startsOn,
      Value<LocalDate?> endsBefore,
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
          PrefetchHooks Function({bool medicationId, bool intakeEventsRefs})
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
              }) => MedicationSchedulesCompanion(
                id: id,
                medicationId: medicationId,
                recurrence: recurrence,
                minutesAfterMidnight: minutesAfterMidnight,
                startsOn: startsOn,
                endsBefore: endsBefore,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medicationId,
                required Recurrence recurrence,
                Value<int?> minutesAfterMidnight = const Value.absent(),
                required LocalDate startsOn,
                Value<LocalDate?> endsBefore = const Value.absent(),
              }) => MedicationSchedulesCompanion.insert(
                id: id,
                medicationId: medicationId,
                recurrence: recurrence,
                minutesAfterMidnight: minutesAfterMidnight,
                startsOn: startsOn,
                endsBefore: endsBefore,
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
              ({medicationId = false, intakeEventsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (intakeEventsRefs) db.intakeEvents,
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
      PrefetchHooks Function({bool medicationId, bool intakeEventsRefs})
    >;
typedef $$IntakeEventsTableCreateCompanionBuilder =
    IntakeEventsCompanion Function({
      Value<int> id,
      required int scheduleId,
      required LocalDate scheduledDate,
      required IntakeEventKind kind,
      required DateTime recordedAt,
      Value<DateTime?> reportedIntakeAt,
    });
typedef $$IntakeEventsTableUpdateCompanionBuilder =
    IntakeEventsCompanion Function({
      Value<int> id,
      Value<int> scheduleId,
      Value<LocalDate> scheduledDate,
      Value<IntakeEventKind> kind,
      Value<DateTime> recordedAt,
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
                Value<DateTime?> reportedIntakeAt = const Value.absent(),
              }) => IntakeEventsCompanion(
                id: id,
                scheduleId: scheduleId,
                scheduledDate: scheduledDate,
                kind: kind,
                recordedAt: recordedAt,
                reportedIntakeAt: reportedIntakeAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int scheduleId,
                required LocalDate scheduledDate,
                required IntakeEventKind kind,
                required DateTime recordedAt,
                Value<DateTime?> reportedIntakeAt = const Value.absent(),
              }) => IntakeEventsCompanion.insert(
                id: id,
                scheduleId: scheduleId,
                scheduledDate: scheduledDate,
                kind: kind,
                recordedAt: recordedAt,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedicationSchedulesTableTableManager get medicationSchedules =>
      $$MedicationSchedulesTableTableManager(_db, _db.medicationSchedules);
  $$IntakeEventsTableTableManager get intakeEvents =>
      $$IntakeEventsTableTableManager(_db, _db.intakeEvents);
}
