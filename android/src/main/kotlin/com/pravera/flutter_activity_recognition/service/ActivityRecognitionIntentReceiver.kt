package com.pravera.flutter_activity_recognition.service

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.google.android.gms.location.ActivityTransitionResult
import com.google.android.gms.location.SleepSegmentEvent
import com.google.android.gms.location.SleepClassifyEvent

class ActivityRecognitionIntentReceiver: BroadcastReceiver() {
	override fun onReceive(context: Context, intent: Intent) {
		if (ActivityTransitionResult.hasResult(intent)) {
			intent.setClass(context, ActivityRecognitionIntentService::class.java)
			ActivityRecognitionIntentService.enqueueWork(context, intent)
			return
		}

		if (SleepClassifyEvent.hasEvents(intent)) {
			intent.setClass(context, ActivityRecognitionIntentService::class.java)
			ActivityRecognitionIntentService.enqueueWork(context, intent)
			return
		}
	}
}
