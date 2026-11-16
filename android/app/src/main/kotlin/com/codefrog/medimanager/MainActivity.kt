package com.codefrog.medimanager

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.ResultReceiver
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var clockChannel: EventChannel? = null
    private var clockReceiver: BroadcastReceiver? = null
    private var reminderChannel: MethodChannel? = null
    private var permissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        clockChannel = EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "medimanager/clock_changes",
        ).also { channel ->
            channel.setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    stopClockReceiver()
                    val filter = IntentFilter().apply {
                        addAction(Intent.ACTION_DATE_CHANGED)
                        addAction(Intent.ACTION_TIME_CHANGED)
                        addAction(Intent.ACTION_TIMEZONE_CHANGED)
                        addAction(ReminderReceiver.CHANGED)
                    }
                    val receiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context, intent: Intent) {
                            events.success(intent.action)
                        }
                    }
                    if (Build.VERSION.SDK_INT >= 33) {
                        registerReceiver(receiver, filter, Context.RECEIVER_NOT_EXPORTED)
                    } else {
                        registerReceiver(receiver, filter)
                    }
                    clockReceiver = receiver
                }

                override fun onCancel(arguments: Any?) = stopClockReceiver()
            })
        }
        reminderChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, "medimanager/reminders",
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "refresh" -> {
                        sendBroadcast(reminderIntent(ReminderReceiver.REFRESH))
                        result.success(ReminderScheduler.canNotify(this))
                    }
                    "requestPermission" -> requestReminderPermission(result)
                    "settings" -> {
                        val settings = if (Build.VERSION.SDK_INT >= 26) {
                            Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                                .putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                        } else {
                            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:$packageName"))
                        }
                        startActivity(settings)
                        result.success(null)
                    }
                    "snooze" -> {
                        val reply = object : ResultReceiver(Handler(Looper.getMainLooper())) {
                            override fun onReceiveResult(code: Int, data: Bundle?) {
                                result.success(code == 1)
                            }
                        }
                        sendBroadcast(
                            reminderIntent(ReminderReceiver.IN_APP_SNOOZE)
                                .putExtra(ReminderReceiver.SCHEDULE, call.argument<Number>("schedule")?.toLong() ?: 0)
                                .putExtra(ReminderReceiver.DAY, call.argument<Number>("day")?.toLong() ?: Long.MAX_VALUE)
                                .putExtra(ReminderReceiver.EVENT, call.argument<Number>("event")?.toLong() ?: -1)
                                .putExtra(ReminderReceiver.RESULT, reply),
                        )
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    private fun reminderIntent(action: String) = Intent(this, ReminderReceiver::class.java).setAction(action)

    private fun requestReminderPermission(result: MethodChannel.Result) {
        ReminderScheduler.createChannel(this)
        if (Build.VERSION.SDK_INT < 33 ||
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED ||
            permissionResult != null
        ) {
            result.success(ReminderScheduler.canNotify(this))
            return
        }
        permissionResult = result
        requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 74)
    }

    override fun onRequestPermissionsResult(code: Int, permissions: Array<out String>, results: IntArray) {
        super.onRequestPermissionsResult(code, permissions, results)
        if (code == 74) {
            permissionResult?.success(ReminderScheduler.canNotify(this))
            permissionResult = null
            sendBroadcast(reminderIntent(ReminderReceiver.REFRESH))
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        clockChannel?.setStreamHandler(null)
        clockChannel = null
        stopClockReceiver()
        reminderChannel?.setMethodCallHandler(null)
        reminderChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private fun stopClockReceiver() {
        clockReceiver?.let { unregisterReceiver(it) }
        clockReceiver = null
    }
}
