import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimanager/data/app_database.dart';
import 'package:medimanager/data/intake_repository.dart';
import 'package:medimanager/data/medication_repository.dart';
import 'package:medimanager/domain/intake_event.dart';
import 'package:medimanager/domain/local_date.dart';
import 'package:medimanager/domain/medication.dart';

void main() {
  test(
    'a local date advances by calendar day across a daylight saving boundary',
    () {
      final sunday = _day(2026, 3, 29);
      expect(sunday.weekday, DateTime.sunday);
      expect(sunday.plusDays(1), _day(2026, 3, 30));
      expect(sunday.plusDays(1).weekday, DateTime.monday);
    },
  );

  test(
    'reopening the SQLite file preserves medications, plans and the event log',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'medimanager-test-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/medimanager.sqlite');
      final now = DateTime(2026, 3, 27, 23, 15, 40, 12, 100);
      final date = LocalDate.fromDateTime(now);
      final reported = now.subtract(const Duration(minutes: 15));
      final db = AppDatabase(NativeDatabase(file));
      late final int medicationId;
      late final ScheduledIntake intake;
      late final List<int> eventIds;
      try {
        final medications = MedicationRepository(db, now: () => now);
        final intakes = IntakeRepository(db, now: () => now);
        medicationId = await medications.createMedication(name: 'Testpräparat');
        await medications.updateMedication(
          medicationId,
          name: ' Testplan ',
          dosage: ' 1 Tablette ',
        );
        final scheduleId = await medications.saveSchedule(
          medicationId: medicationId,
          recurrence: Recurrence.weekly({DateTime.friday}),
          minutesAfterMidnight: 22 * 60,
          startsOn: date,
          endsBefore: date.plusDays(8),
        );
        intake = (scheduleId: scheduleId, scheduledDate: date);
        eventIds = [
          await intakes.confirm(intake, reportedIntakeAt: reported),
          await intakes.correct(intake),
          await intakes.confirm(intake),
        ];
      } finally {
        await db.close();
      }

      final reopened = AppDatabase(NativeDatabase(file));
      addTearDown(reopened.close);
      final meds = MedicationRepository(reopened);
      final intakes = IntakeRepository(reopened);
      expect(
        (await reopened.customSelect('PRAGMA user_version').getSingle())
            .read<int>('user_version'),
        3,
      );
      final medication = (await meds.watchMedication(medicationId).first)!;
      expect(medication.name, 'Testplan');
      expect(medication.dosage, '1 Tablette');
      expect(medication.isActive, isTrue);
      expect(medication.createdAt, now.toUtc());

      final plan = (await meds.watchSchedules(medicationId).first).single;
      expect(plan.id, intake.scheduleId);
      expect(plan.medicationId, medicationId);
      expect(plan.recurrence.weekdays, {DateTime.friday});
      expect(plan.minutesAfterMidnight, 22 * 60);
      expect(plan.endsBefore, date.plusDays(8));
      final events = await intakes.historyFor(intake);
      expect(events.map((event) => event.id), eventIds);
      expect(eventIds.toSet(), hasLength(3));
      expect(events.map((event) => event.kind), [
        IntakeEventKind.confirmation,
        IntakeEventKind.correction,
        IntakeEventKind.confirmation,
      ]);
      expect(events.every((event) => event.scheduledDate == date), isTrue);
      expect(events.every((event) => event.recordedAt.isUtc), isTrue);
      expect(events.first.recordedAt, now.toUtc());
      expect(events.first.reportedIntakeAt, reported.toUtc());
      expect(events.last.reportedIntakeAt, isNull);
    },
  );

  group('repository behavior', () {
    late AppDatabase db;
    late MedicationRepository medications;
    late IntakeRepository intakes;
    late DateTime now;
    late LocalDate friday;
    late int medicationId;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      now = DateTime(2026, 3, 27, 18);
      medications = MedicationRepository(db, now: () => now);
      intakes = IntakeRepository(db, now: () => now);
      friday = medications.today;
      medicationId = await medications.createMedication(name: 'Präparat A');
    });

    tearDown(() => db.close());

    Future<int> daily({LocalDate? startsOn, LocalDate? endsBefore}) =>
        medications.saveSchedule(
          medicationId: medicationId,
          recurrence: const Recurrence.daily(),
          minutesAfterMidnight: null,
          startsOn: startsOn ?? friday,
          endsBefore: endsBefore,
        );

    Future<List<int>> scheduledIds(LocalDate date) async =>
        (await medications.watchDailyIntakes(date).first)
            .map((entry) => entry.schedule.id)
            .toList();

    test('daily overview respects recurrence and effective dates without recording intake', () async {
      final dailyId = await daily(endsBefore: friday.plusDays(2));
      final weeklyId = await medications.saveSchedule(
        medicationId: medicationId,
        recurrence: Recurrence.weekly({DateTime.friday}),
        minutesAfterMidnight: 9 * 60,
        startsOn: friday,
        endsBefore: null,
      );
      final futureId = await daily(startsOn: friday.plusDays(3));
      expect(await scheduledIds(friday.plusDays(-1)), isEmpty);
      expect(await scheduledIds(friday), [weeklyId, dailyId]);
      final entries = await medications.watchDailyIntakes(friday).first;
      expect(entries.first.intake, (
        scheduleId: weeklyId,
        scheduledDate: friday,
      ));
      expect(await scheduledIds(friday.plusDays(1)), [dailyId]);
      expect(await scheduledIds(friday.plusDays(2)), isEmpty);
      expect(await scheduledIds(friday.plusDays(3)), [futureId]);
      expect(await scheduledIds(friday.plusDays(7)), [weeklyId, futureId]);
      expect(await intakes.watchForMedication(medicationId).first, isEmpty);
    });

    test('replacing an effective schedule preserves earlier expectations and events', () async {
      final oldId = await daily();
      final intake = (scheduleId: oldId, scheduledDate: friday);
      await intakes.confirm(intake);
      final saturday = friday.plusDays(1);
      await expectLater(
        medications.saveSchedule(
          medicationId: medicationId,
          replacesScheduleId: oldId,
          recurrence: const Recurrence.daily(),
          minutesAfterMidnight: 1440,
          startsOn: saturday,
          endsBefore: null,
        ),
        throwsRangeError,
      );
      expect(await scheduledIds(saturday), [oldId]);

      final newId = await medications.saveSchedule(
        medicationId: medicationId,
        replacesScheduleId: oldId,
        recurrence: Recurrence.weekly({DateTime.sunday}),
        minutesAfterMidnight: 480,
        startsOn: saturday,
        endsBefore: null,
      );
      expect(newId, isNot(oldId));
      expect(await scheduledIds(friday), [oldId]);
      expect(await scheduledIds(saturday), isEmpty);
      expect(await scheduledIds(friday.plusDays(2)), [newId]);
      expect((await intakes.historyFor(intake)).single.scheduleId, oldId);
      await expectLater(
        medications.saveSchedule(
          medicationId: medicationId,
          replacesScheduleId: oldId,
          recurrence: const Recurrence.daily(),
          minutesAfterMidnight: null,
          startsOn: saturday,
          endsBefore: null,
        ),
        throwsStateError,
      );
    });

    test(
      'deactivation ends plans and reactivation retains their history',
      () async {
        final currentId = await daily();
        final futureId = await daily(startsOn: friday.plusDays(3));
        final intake = (scheduleId: currentId, scheduledDate: friday);
        final eventId = await intakes.confirm(intake);

        await medications.setActive(medicationId, false);
        expect(
          (await medications.watchMedication(medicationId).first)!.isActive,
          isFalse,
        );
        expect(await scheduledIds(friday), [currentId]);
        expect(await scheduledIds(friday.plusDays(1)), isEmpty);
        final plans = await medications.watchSchedules(medicationId).first;
        final canceled = plans.singleWhere((plan) => plan.id == futureId);
        expect(canceled.endsBefore, canceled.startsOn);
        expect(await medications.deleteMedication(medicationId), isFalse);
        final stored =
            (await intakes.watchForMedication(medicationId).first).single;
        expect(stored.event.id, eventId);
        expect(stored.schedule.medicationId, medicationId);

        await medications.setActive(medicationId, true);
        expect(
          (await medications.watchMedication(medicationId).first)!.isActive,
          isTrue,
        );
        expect(await scheduledIds(friday.plusDays(3)), isEmpty);
        expect((await intakes.historyFor(intake)).single.id, eventId);
      },
    );

    test(
      'a schedule stop preserves a recorded date after the clock moves back',
      () async {
        final scheduleId = await daily();
        final sunday = friday.plusDays(2);
        now = DateTime(2026, 3, 29, 12);
        final intake = (scheduleId: scheduleId, scheduledDate: sunday);
        await intakes.confirm(intake);
        now = DateTime(2026, 3, 27, 18);
        await medications.stopSchedule(scheduleId);
        expect(await scheduledIds(sunday), [scheduleId]);
        expect(await scheduledIds(sunday.plusDays(1)), isEmpty);
        expect(await intakes.historyFor(intake), hasLength(1));
      },
    );

    test('validates input and serializes duplicate confirmations', () async {
      expect(
        () => medications.createMedication(name: '   '),
        throwsArgumentError,
      );
      expect(() => Recurrence.weekly({}), throwsArgumentError);
      final unused = await medications.createMedication(
        name: 'Ungenutzt',
        dosage: ' ',
      );
      expect((await medications.watchMedication(unused).first)!.dosage, isNull);
      expect(await medications.deleteMedication(unused), isTrue);
      expect(await medications.watchMedication(unused).first, isNull);

      final scheduleId = await daily();
      final intake = (scheduleId: scheduleId, scheduledDate: friday);
      await expectLater(intakes.correct(intake), throwsStateError);
      await expectLater(
        intakes.confirm((
          scheduleId: scheduleId,
          scheduledDate: friday.plusDays(1),
        )),
        throwsArgumentError,
      );
      final first = intakes.confirm(intake);
      final duplicate = intakes.confirm(intake);
      await Future.wait([first, expectLater(duplicate, throwsStateError)]);
      expect(await intakes.historyFor(intake), hasLength(1));
    });
  });
}

LocalDate _day(int year, int month, int day) =>
    LocalDate.fromDateTime(DateTime.utc(year, month, day));
