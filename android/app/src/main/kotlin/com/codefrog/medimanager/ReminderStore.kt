package com.codefrog.medimanager

import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId

internal data class ReminderKey(val scheduleId: Long, val day: Long) {
    val date: LocalDate get() = LocalDate.ofEpochDay(day)
    val tag: String get() = "intake:$scheduleId:$day"
}

internal data class ReminderPlan(
    val id: Long,
    val name: String,
    val startsOn: Long,
    val endsBefore: Long?,
    val weekdays: Int,
    val scheduledMinute: Int?,
    val reminderMinute: Int?,
    val snoozeMinutes: Int,
    val changedAt: Instant,
) {
    fun occursOn(date: LocalDate): Boolean {
        val day = date.toEpochDay()
        return day >= startsOn && (endsBefore == null || day < endsBefore) &&
            (weekdays == 0 || weekdays and (1 shl (date.dayOfWeek.value - 1)) != 0)
    }

    // A spring-forward gap moves the reminder forward by the gap. An overlap uses
    // the earlier offset. The calendar date still identifies just one occurrence.
    fun timeOn(date: LocalDate, zone: ZoneId): Instant? =
        reminderMinute?.let { date.atTime(it / 60, it % 60).atZone(zone).toInstant() }
}

internal data class ReminderState(
    val key: ReminderKey,
    val snoozedUntil: Instant?,
    val token: String?,
    val eventId: Long,
)

internal data class LatestIntake(val id: Long = 0, val confirmed: Boolean = false)

internal class ReminderStore(private val db: SQLiteDatabase) {
    inline fun <T> transaction(action: () -> T): T {
        // Obtain the write lock before reading status so Flutter and notification
        // actions cannot both confirm the same occurrence.
        db.beginTransactionNonExclusive()
        try {
            val result = action()
            db.setTransactionSuccessful()
            return result
        } finally {
            db.endTransaction()
        }
    }

    private val planQuery = """
        SELECT s.id, m.name, s.starts_on, s.ends_before, s.recurrence,
               s.minutes_after_midnight, coalesce(r.reminder_minute, s.minutes_after_midnight),
               r.snooze_minutes, r.changed_at
        FROM medication_schedules s
        JOIN medications m ON s.medication_id = m.id
        JOIN medication_reminders r ON r.medication_id = m.id
        WHERE m.is_active = 1 AND r.enabled = 1
    """.trimIndent()

    fun plans(today: LocalDate): List<ReminderPlan> = db.rawQuery(
        "$planQuery AND (s.ends_before IS NULL OR s.ends_before > ?)",
        arrayOf(today.toEpochDay().toString()),
    ).use { cursor ->
        buildList { while (cursor.moveToNext()) add(cursor.plan()) }
    }

    fun plan(id: Long): ReminderPlan? = db.rawQuery(
        "$planQuery AND s.id = ?", arrayOf(id.toString()),
    ).use { if (it.moveToFirst()) it.plan() else null }

    private fun Cursor.plan() = ReminderPlan(
        getLong(0), getString(1), getLong(2), nullableLong(3), getInt(4),
        nullableLong(5)?.toInt(), nullableLong(6)?.toInt(), getInt(7),
        Instant.ofEpochMilli(getLong(8) / 1000),
    )

    fun latest(key: ReminderKey): LatestIntake = db.rawQuery(
        """SELECT id, kind FROM intake_events WHERE schedule_id = ? AND scheduled_date = ?
           ORDER BY id DESC LIMIT 1""",
        key.arguments(),
    ).use { if (it.moveToFirst()) LatestIntake(it.getLong(0), it.getString(1) == "confirmation") else LatestIntake() }

    fun state(key: ReminderKey): ReminderState? = db.rawQuery(
        """SELECT schedule_id, scheduled_date, snoozed_until, action_token, latest_event_id
           FROM reminder_occurrences WHERE schedule_id = ? AND scheduled_date = ?""",
        key.arguments(),
    ).use { if (it.moveToFirst()) it.reminderState() else null }

    fun snoozed(): List<ReminderState> = db.rawQuery(
        """SELECT schedule_id, scheduled_date, snoozed_until, action_token, latest_event_id
           FROM reminder_occurrences WHERE snoozed_until IS NOT NULL""", null,
    ).use { cursor ->
        buildList { while (cursor.moveToNext()) add(cursor.reminderState()) }
    }

    private fun Cursor.reminderState() = ReminderState(
        ReminderKey(getLong(0), getLong(1)),
        nullableLong(2)?.let { Instant.ofEpochMilli(it / 1000) },
        getString(3),
        getLong(4),
    )

    fun store(state: ReminderState) {
        db.execSQL(
            """INSERT OR REPLACE INTO reminder_occurrences
               (schedule_id, scheduled_date, snoozed_until, action_token, latest_event_id)
               VALUES (?, ?, ?, ?, ?)""",
            arrayOf<Any?>(state.key.scheduleId, state.key.day, state.snoozedUntil?.toEpochMicroseconds(),
                state.token, state.eventId),
        )
    }

    // Called only by the explicit Taken action, after validating its token and
    // reading the latest intake event inside the same write transaction.
    fun confirm(key: ReminderKey, now: Instant, today: LocalDate) {
        db.execSQL(
            """INSERT INTO intake_events (schedule_id, scheduled_date, kind, recorded_at, recorded_on)
               VALUES (?, ?, 'confirmation', ?, ?)""",
            arrayOf(key.scheduleId, key.day, now.toEpochMicroseconds(), today.toEpochDay()),
        )
    }

    private fun ReminderKey.arguments() = arrayOf(scheduleId.toString(), day.toString())
    private fun Cursor.nullableLong(column: Int) = if (isNull(column)) null else getLong(column)
}

internal fun Instant.toEpochMicroseconds() = toEpochMilli() * 1000L
