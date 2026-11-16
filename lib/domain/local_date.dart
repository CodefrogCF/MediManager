/// A calendar date independent of time zones and daylight-saving changes.
final class LocalDate implements Comparable<LocalDate> {
  const LocalDate.fromEpochDay(this.epochDay);

  factory LocalDate.fromDateTime(DateTime date) => LocalDate.fromEpochDay(
    DateTime.utc(date.year, date.month, date.day).difference(_epoch).inDays,
  );

  static final _epoch = DateTime.utc(1970);

  final int epochDay;

  DateTime get calendarDate => _epoch.add(Duration(days: epochDay));
  int get weekday => calendarDate.weekday;

  LocalDate plusDays(int days) => LocalDate.fromEpochDay(epochDay + days);

  bool isBefore(LocalDate other) => epochDay < other.epochDay;

  @override
  int compareTo(LocalDate other) => epochDay.compareTo(other.epochDay);

  @override
  bool operator ==(Object other) =>
      other is LocalDate && epochDay == other.epochDay;

  @override
  int get hashCode => epochDay.hashCode;
}
