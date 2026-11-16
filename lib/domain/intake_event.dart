import 'local_date.dart';

/// Each schedule version represents at most one expected intake per date.
typedef ScheduledIntake = ({int scheduleId, LocalDate scheduledDate});

enum IntakeEventKind {
  confirmation,

  /// Withdraws the preceding confirmation for this scheduled intake.
  correction,
}

final class IntakeEvent {
  const IntakeEvent({
    required this.id,
    required this.scheduleId,
    required this.scheduledDate,
    required this.kind,
    required this.recordedAt,
    required this.reportedIntakeAt,
  });

  final int id;
  final int scheduleId;
  final LocalDate scheduledDate;
  final IntakeEventKind kind;
  final DateTime recordedAt;
  final DateTime? reportedIntakeAt;
}
