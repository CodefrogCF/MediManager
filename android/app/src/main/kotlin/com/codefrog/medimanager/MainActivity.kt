package com.codefrog.medimanager

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private var clockChannel: EventChannel? = null
    private var clockReceiver: BroadcastReceiver? = null

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
                    }
                    val receiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context, intent: Intent) {
                            events.success(null)
                        }
                    }
                    registerReceiver(receiver, filter)
                    clockReceiver = receiver
                }

                override fun onCancel(arguments: Any?) = stopClockReceiver()
            })
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        clockChannel?.setStreamHandler(null)
        clockChannel = null
        stopClockReceiver()
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private fun stopClockReceiver() {
        clockReceiver?.let { unregisterReceiver(it) }
        clockReceiver = null
    }
}
