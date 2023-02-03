package com.pravera.flutter_activity_recognition.service

import android.content.Context
import android.content.Intent
import androidx.core.app.JobIntentService
import com.google.android.gms.location.ActivityTransitionResult
import com.google.android.gms.location.SleepClassifyEvent
import com.google.gson.Gson
import com.pravera.flutter_activity_recognition.Constants
import com.pravera.flutter_activity_recognition.errors.ErrorCodes
import com.pravera.flutter_activity_recognition.models.ActivityData
import com.pravera.flutter_activity_recognition.models.SleepData
import com.pravera.flutter_activity_recognition.utils.ActivityRecognitionUtils

import android.util.Log

class ActivityRecognitionIntentService: JobIntentService() {
	companion object {
		val jsonConverter: Gson = Gson()
		fun enqueueWork(context: Context, intent: Intent) {
			enqueueWork(context, ActivityRecognitionIntentService::class.java,
					Constants.ACTIVITY_RECOGNITION_INTENT_SERVICE_JOB_ID, intent)
		}
	}

	override fun onHandleWork(intent: Intent) {
		if (ActivityTransitionResult.hasResult(intent)) {
			val extractedResult = ActivityTransitionResult.extractResult(intent)
			for (event in extractedResult!!.getTransitionEvents()) {
				val activityType: Int = event.getActivityType()
				val transitionType: Int = event.getTransitionType()

				val activityData = ActivityData(
					ActivityRecognitionUtils.getActivityTypeFromValue(activityType),
					when(transitionType) {
						0 -> "ENTER"
						else -> "EXIT"
					}
				)
				var prefsKey: String
				var prefsValue: String
				try {
					prefsKey = Constants.ACTIVITY_DATA_PREFS_KEY
					prefsValue = jsonConverter.toJson(activityData)
				} catch (e: Exception) {
					prefsKey = Constants.ACTIVITY_ERROR_PREFS_KEY
					prefsValue = ErrorCodes.ACTIVITY_DATA_ENCODING_FAILED.toString()
				}

				val prefs = getSharedPreferences(
						Constants.ACTIVITY_RECOGNITION_RESULT_PREFS_NAME, Context.MODE_PRIVATE) ?: return
				with (prefs.edit()) {
					putString(prefsKey, prefsValue)
					commit()
				}
			}
			return
		}
		if (SleepClassifyEvent.hasEvents(intent)) {
			val extractedResult = SleepClassifyEvent.extractEvents(intent)
			for (event in extractedResult) {
				val confidence: Int = event.getConfidence()
				val light: Int = event.getLight()
				val motion: Int = event.getMotion()
				val timestamp: Long = event.getTimestampMillis()

				val sleepData = SleepData(
					confidence,
					light,
					motion,
					timestamp
				)

				var prefsKey: String
				var prefsValue: String
				try {
					prefsKey = Constants.SLEEP_DATA_PREFS_KEY
					prefsValue = jsonConverter.toJson(sleepData)
				} catch (e: Exception) {
					prefsKey = Constants.ACTIVITY_ERROR_PREFS_KEY
					prefsValue = ErrorCodes.ACTIVITY_DATA_ENCODING_FAILED.toString()
				}

				val prefs = getSharedPreferences(
						Constants.ACTIVITY_RECOGNITION_RESULT_PREFS_NAME, Context.MODE_PRIVATE) ?: return
				with (prefs.edit()) {
					putString(prefsKey, prefsValue)
					commit()
				}
			}

			return
		}
	}
}
