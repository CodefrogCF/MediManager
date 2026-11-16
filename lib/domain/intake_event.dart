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
    required this.recordedOn,
    required this.reportedIntakeAt,
  });

  final int id;
  final int scheduleId;
  final LocalDate scheduledDate;
  final IntakeEventKind kind;
  final DateTime recordedAt;

  /// The device's local date at recording time. V1 records lack this data.
  final LocalDate? recordedOn;
  final DateTime? reportedIntakeAt;

  bool get isConfirmation => kind == IntakeEventKind.confirmation;
  bool get isRetrospective =>
      recordedOn != null && scheduledDate.isBefore(recordedOn!);
}
