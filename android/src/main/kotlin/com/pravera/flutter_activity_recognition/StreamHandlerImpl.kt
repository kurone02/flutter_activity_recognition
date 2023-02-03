package com.pravera.flutter_activity_recognition

import android.app.Activity
import android.content.Context
import com.pravera.flutter_activity_recognition.errors.ErrorCodes
import com.pravera.flutter_activity_recognition.service.ActivityRecognitionManager
import com.pravera.flutter_activity_recognition.service.SleepClassifyManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

/** StreamHandlerImpl */
class StreamHandlerImpl(private val context: Context): EventChannel.StreamHandler {
	private lateinit var eventChannelActivity: EventChannel
	private lateinit var activityRecognitionManager: ActivityRecognitionManager

	private lateinit var eventChannelSleep: EventChannel 

	private var activity: Activity? = null

	fun startListening(messenger: BinaryMessenger) {
		activityRecognitionManager = ActivityRecognitionManager()
		eventChannelActivity = EventChannel(messenger, "flutter_activity_recognition/updates")
		eventChannelActivity.setStreamHandler(this)
		eventChannelSleep = EventChannel(messenger, "flutter_activity_recognition/updates_sleep")
		eventChannelSleep.setStreamHandler(SleepStreamHandlerImpl(context))
	}

	fun stopListening() {
		if (::eventChannelActivity.isInitialized)
			eventChannelActivity.setStreamHandler(null)
		if (::eventChannelSleep.isInitialized)
			eventChannelSleep.setStreamHandler(null)
	}

	fun setActivity(activity: Activity?) {
		this.activity = activity
	}

	private fun handleError(events: EventChannel.EventSink?, errorCode: ErrorCodes) {
		events?.error(errorCode.toString(), null, null)
	}

	override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
		activityRecognitionManager.startService(
			context = context,
			onSuccess = { },
			onError = { handleError(events, it) },
			updatesListener = { events?.success(it) }
		)
	}

	override fun onCancel(arguments: Any?) {
		activityRecognitionManager.stopService(context)
	}
}

class SleepStreamHandlerImpl(private val context: Context): EventChannel.StreamHandler {
	private var sleepClassifyManager: SleepClassifyManager = SleepClassifyManager()

	private var activity: Activity? = null

	fun setActivity(activity: Activity?) {
		this.activity = activity
	}

	private fun handleError(events: EventChannel.EventSink?, errorCode: ErrorCodes) {
		events?.error(errorCode.toString(), null, null)
	}

	override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
		sleepClassifyManager.startService(
			context = context,
			onSuccess = { },
			onError = { handleError(events, it) },
			updatesListener = { events?.success(it) }
		)
	}

	override fun onCancel(arguments: Any?) {
		sleepClassifyManager.stopService(context)
	}
}
