package com.codefrog.medimanager

import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteDatabaseLockedException
import android.net.Uri
import android.os.Build
import android.os.ResultReceiver
import android.util.Log
import io.flutter.util.PathUtils
import org.json.JSONObject
import java.io.File
import java.time.Duration
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Locale
import java.util.UUID
import java.util.concurrent.Executors

class ReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val pending = goAsync()
        worker.execute {
            val scheduler = ReminderScheduler(context.applicationContext)
            var result = false
            try {
                result = scheduler.handle(intent)
            } catch (_: SQLiteDatabaseLockedException) {
                scheduler.retry()
            } catch (error: RuntimeException) {
                Log.w("MediManagerReminders", "Reminder operation failed: ${error.javaClass.simpleName}")
            } finally {
                callback(intent)?.send(if (result) 1 else 0, null)
                pending.finish()
            }
        }
    }

    @Suppress("DEPRECATION")
    private fun callback(intent: Intent): ResultReceiver? =
        if (Build.VERSION.SDK_INT >= 33) intent.getParcelableExtra(RESULT, ResultReceiver::class.java)
        else intent.getParcelableExtra(RESULT)

    companion object {
        private val worker = Executors.newSingleThreadExecutor()
        const val CHANGED = "com.codefrog.medimanager.REMINDER_DATA_CHANGED"
        const val REFRESH = "com.codefrog.medimanager.REFRESH_REMINDERS"
        const val IN_APP_SNOOZE = "com.codefrog.medimanager.IN_APP_SNOOZE"
        const val RESULT = "result"
        const val SCHEDULE = "schedule"
        const val DAY = "day"
        const val EVENT = "event"
    }
}

internal class ReminderScheduler(private val context: Context) {
    private val alarms = context.getSystemService(AlarmManager::class.java)
    private val notifications = context.getSystemService(NotificationManager::class.java)

    fun handle(intent: Intent): Boolean {
        // Use Android SQLite in a separate process from Flutter's native SQLite
        // connection so both engines coordinate using SQLite's file locks.
        val file = File(PathUtils.getDataDirectory(context), "medimanager.sqlite")
        if (!file.isFile) return false
        val flags = SQLiteDatabase.OPEN_READWRITE or SQLiteDatabase.NO_LOCALIZED_COLLATORS or
            SQLiteDatabase.ENABLE_WRITE_AHEAD_LOGGING
        SQLiteDatabase.openDatabase(file.path, null, flags).use { database ->
            if (database.version != 4) return false
            database.setForeignKeyConstraintsEnabled(true)
            val store = ReminderStore(database)
            val now = Instant.now()
            val zone = ZoneId.systemDefault()
            val today = now.atZone(zone).toLocalDate()
            val action = intent.action
            val changed = if (action == TAKEN || action == LATER || action == ReminderReceiver.IN_APP_SNOOZE) {
                store.transaction { applyAction(store, intent, now, today) }
            } else {
                false
            }
            if (changed && action == TAKEN) {
                context.sendBroadcast(Intent(ReminderReceiver.CHANGED).setPackage(context.packageName))
            }
            // An OS delivery failure cannot undo a successful user action.
            try {
                val next = store.transaction { reconcile(store, now, today, zone) }
                arm(next)
            } catch (error: RuntimeException) {
                if (error is SQLiteDatabaseLockedException) retry()
                Log.w("MediManagerReminders", "Reminder refresh failed: ${error.javaClass.simpleName}")
            }
            return changed
        }
    }

    private fun applyAction(store: ReminderStore, intent: Intent, now: Instant, today: LocalDate): Boolean {
        val key = ReminderKey(
            intent.getLongExtra(ReminderReceiver.SCHEDULE, 0),
            intent.getLongExtra(ReminderReceiver.DAY, Long.MAX_VALUE),
        )
        if (key.scheduleId <= 0 || key.day !in -100000000L..today.toEpochDay()) return false
        val plan = store.plan(key.scheduleId) ?: return false
        if (!plan.occursOn(key.date)) return false
        val latest = store.latest(key)
        if (latest.confirmed) return false
        val inApp = intent.action == ReminderReceiver.IN_APP_SNOOZE
        if (inApp) {
            if (key.date != today || !canNotify(context) ||
                intent.getLongExtra(ReminderReceiver.EVENT, -1) != latest.id) return false
        } else {
            val state = store.state(key) ?: return false
            if (state.token == null || state.token != intent.getStringExtra(TOKEN) ||
                state.eventId != latest.id) return false
        }
        if (intent.action == TAKEN) {
            store.confirm(key, now, today)
            store.store(ReminderState(key, null, null, latest.id))
        } else {
            // Replacing the row makes a snooze unique for the schedule and date.
            // Clearing the token makes repeated taps on the old notification inert.
            store.store(ReminderState(key, now.plusSeconds(plan.snoozeMinutes * 60L), null, latest.id))
        }
        return true
    }

    private fun reconcile(store: ReminderStore, now: Instant, today: LocalDate, zone: ZoneId): Instant? {
        val allowed = canNotify(context)
        val language by lazy { store.language() }
        val strings by lazy { reminderStrings(language) }
        if (Build.VERSION.SDK_INT >= 26 && notifications.getNotificationChannel(CHANNEL) != null) {
            createChannel(strings)
        }
        for (posted in notifications.activeNotifications) {
            val tag = posted.tag ?: continue
            if (!tag.startsWith("intake:")) continue
            val parts = tag.split(':')
            if (parts.size != 3) continue
            val key = ReminderKey(parts[1].toLongOrNull() ?: continue, parts[2].toLongOrNull() ?: continue)
            val state = store.state(key)
            val plan = store.plan(key.scheduleId)
            val latest = store.latest(key)
            if (!allowed || plan?.occursOn(key.date) != true || latest.confirmed ||
                state?.token == null || state.eventId != latest.id) {
                notifications.cancel(tag, NOTIFICATION_ID)
            }
        }
        if (!allowed) return null

        var next: Instant? = null
        fun consider(time: Instant) {
            if (next?.let { time.isBefore(it) } != false) next = time
        }

        for (state in store.snoozed()) {
            val until = checkNotNull(state.snoozedUntil)
            val plan = store.plan(state.key.scheduleId)
            val latest = store.latest(state.key)
            if (plan == null || !plan.occursOn(state.key.date) || latest.confirmed ||
                state.eventId != latest.id || until.isBefore(now.minus(Duration.ofDays(1)))) {
                store.store(state.copy(snoozedUntil = null))
            } else if (until.isAfter(now)) {
                consider(until)
            } else {
                show(store, plan, state.key, latest.id, strings, language)
            }
        }

        for (plan in store.plans(today)) {
            if (plan.reminderMinute == null) continue
            val enabledDay = plan.changedAt.atZone(zone).toLocalDate().toEpochDay()
            var date = LocalDate.ofEpochDay(maxOf(today.toEpochDay(), plan.startsOn, enabledDay))
            while (plan.endsBefore == null || date.toEpochDay() < plan.endsBefore) {
                if (plan.occursOn(date)) {
                    val key = ReminderKey(plan.id, date.toEpochDay())
                    val time = checkNotNull(plan.timeOn(date, zone))
                    val latest = store.latest(key)
                    if (!time.isBefore(plan.changedAt) && !latest.confirmed && store.state(key) == null) {
                        if (time.isAfter(now)) {
                            consider(time)
                            break
                        }
                        show(store, plan, key, latest.id, strings, language)
                    }
                }
                date = date.plusDays(1)
            }
        }
        return next
    }

    @Suppress("DEPRECATION")
    private fun show(
        store: ReminderStore, plan: ReminderPlan, key: ReminderKey, eventId: Long,
        strings: JSONObject, language: String,
    ) {
        createChannel(strings)
        val token = UUID.randomUUID().toString()
        val openApp = PendingIntent.getActivity(
            context, 0,
            Intent(context, MainActivity::class.java)
                .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        val format = if (language == "en") DateTimeFormatter.ISO_LOCAL_DATE
            else DateTimeFormatter.ofPattern("dd.MM.yyyy", Locale.GERMAN)
        val date = key.date.format(format)
        val time = plan.scheduledMinute?.let { String.format(Locale.ROOT, " · %02d:%02d", it / 60, it % 60) }.orEmpty()
        val slot = plan.label ?: strings.getString("slotIdentity").replace("{id}", plan.id.toString())
        val publicNotification = builder()
            .setSmallIcon(R.drawable.ic_reminder)
            .setContentTitle(strings.getString("app"))
            .setContentText(strings.getString("plannedIntake"))
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .build()
        val taken = Notification.Action.Builder(
            null, strings.getString("taken"), actionIntent(TAKEN, key, token),
        )
        if (Build.VERSION.SDK_INT >= 31) taken.setAuthenticationRequired(true)
        val notification = builder()
            .setSmallIcon(R.drawable.ic_reminder)
            .setContentTitle(store.nameOn(key) ?: plan.name)
            .setContentText("$slot · $date$time")
            .setCategory(Notification.CATEGORY_REMINDER)
            .setVisibility(Notification.VISIBILITY_PRIVATE)
            .setPublicVersion(publicNotification)
            .setContentIntent(openApp)
            .setAutoCancel(true)
            .addAction(taken.build())
            .addAction(Notification.Action.Builder(
                null, strings.getString("remindLater"), actionIntent(LATER, key, token),
            ).build())
        if (Build.VERSION.SDK_INT >= 26) notification.setTimeoutAfter(Duration.ofDays(1).toMillis())
        notifications.notify(key.tag, NOTIFICATION_ID, notification.build())
        store.store(ReminderState(key, null, token, eventId))
    }

    @Suppress("DEPRECATION")
    private fun builder() = if (Build.VERSION.SDK_INT >= 26) {
        Notification.Builder(context, CHANNEL)
    } else {
        Notification.Builder(context)
    }

    private fun actionIntent(action: String, key: ReminderKey, token: String): PendingIntent =
        PendingIntent.getBroadcast(
            context, 0,
            Intent(context, ReminderReceiver::class.java).setAction(action)
                .setData(Uri.parse("medimanager://reminder/${key.scheduleId}/${key.day}/$token"))
                .putExtra(ReminderReceiver.SCHEDULE, key.scheduleId)
                .putExtra(ReminderReceiver.DAY, key.day)
                .putExtra(TOKEN, token),
            PendingIntent.FLAG_IMMUTABLE,
        )

    private fun arm(next: Instant?) {
        val operation = PendingIntent.getBroadcast(
            context, 1, Intent(context, ReminderReceiver::class.java).setAction(ReminderReceiver.REFRESH),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        if (next == null) alarms.cancel(operation)
        else alarms.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, next.toEpochMilli(), operation)
    }

    fun retry() = arm(Instant.now().plusSeconds(60))

    private fun reminderStrings(language: String): JSONObject = runCatching {
        context.assets.open("flutter_assets/lib/l10n/app_$language.arb").bufferedReader().use {
            JSONObject(it.readText())
        }
    }.getOrElse { throw IllegalStateException("Reminder catalog unavailable", it) }

    private fun createChannel(strings: JSONObject) {
        if (Build.VERSION.SDK_INT >= 26) {
            val channel = NotificationChannel(
                CHANNEL, strings.getString("reminderChannelName"), NotificationManager.IMPORTANCE_DEFAULT,
            )
            channel.description = strings.getString("reminderChannelDescription")
            channel.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
            notifications.createNotificationChannel(channel)
        }
    }

    companion object {
        const val CHANNEL = "intake_reminders"
        private const val NOTIFICATION_ID = 1
        private const val TAKEN = "com.codefrog.medimanager.REMINDER_TAKEN"
        private const val LATER = "com.codefrog.medimanager.REMINDER_LATER"
        private const val TOKEN = "token"

        fun canNotify(context: Context): Boolean {
            val manager = context.getSystemService(NotificationManager::class.java)
            return manager.areNotificationsEnabled() &&
                (Build.VERSION.SDK_INT < 26 ||
                    manager.getNotificationChannel(CHANNEL)?.importance != NotificationManager.IMPORTANCE_NONE)
        }

    }
}
