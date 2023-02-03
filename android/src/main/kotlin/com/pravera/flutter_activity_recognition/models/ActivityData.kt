package com.pravera.flutter_activity_recognition.models

import com.google.gson.annotations.SerializedName

data class ActivityData(
	@SerializedName("activityType") val activityType: String,
	@SerializedName("transitionType") val transitionType: String
)

data class SleepData (
	@SerializedName("confidence") val confidence: Int,
	@SerializedName("light") val light: Int,
	@SerializedName("motion") val motion: Int,
	@SerializedName("timestamp") val timestamp: Long
)