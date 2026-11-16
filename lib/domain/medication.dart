import 'local_date.dart';

final class Medication {
  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.isActive,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String? dosage;
  final bool isActive;
  final DateTime createdAt;
}

/// Zero denotes daily recurrence. Bits 0–6 denote Monday through Sunday.
final class Recurrence {
  const Recurrence.daily() : weekdayMask = 0;

  Recurrence.fromMask(this.weekdayMask) {
    RangeError.checkValueInInterval(weekdayMask, 0, 127, 'weekdayMask');
  }

  factory Recurrence.weekly(Set<int> weekdays) {
    if (weekdays.isEmpty) {
      throw ArgumentError.value(weekdays, 'weekdays', 'Select a weekday');
    }
    var mask = 0;
    for (final day in weekdays) {
      RangeError.checkValueInInterval(day, DateTime.monday, DateTime.sunday);
      mask |= 1 << (day - 1);
    }
    return Recurrence.fromMask(mask);
  }

  final int weekdayMask;

  bool get isDaily => weekdayMask == 0;

  bool includes(int weekday) =>
      isDaily || (weekdayMask & (1 << (weekday - 1))) != 0;

  Set<int> get weekdays => {
    for (var day = DateTime.monday; day <= DateTime.sunday; day++)
      if (includes(day)) day,
  };
}

final class MedicationSchedule {
  const MedicationSchedule({
    required this.id,
    required this.medicationId,
    required this.recurrence,
    required this.minutesAfterMidnight,
    required this.startsOn,
    required this.endsBefore,
    this.label,
  });

  final int id;
  final int medicationId;
  final Recurrence recurrence;
  final int? minutesAfterMidnight;
  final LocalDate startsOn;
  final LocalDate? endsBefore;
  final String? label;

  bool occursOn(LocalDate date) {
    final end = endsBefore;
    return !date.isBefore(startsOn) &&
        (end == null || date.isBefore(end)) &&
        recurrence.includes(date.weekday);
  }

  bool isCurrentOrUpcoming(LocalDate today) {
    final end = endsBefore;
    return end == null || (today.isBefore(end) && startsOn.isBefore(end));
  }

  /// The current calendar day's expectations are preserved once a plan starts.
  LocalDate changeBoundary(LocalDate today) =>
      today.isBefore(startsOn) ? startsOn : today.plusDays(1);

  bool canChange(LocalDate today) {
    final end = endsBefore;
    return end == null || changeBoundary(today).isBefore(end);
  }
}
