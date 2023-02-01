package com.pravera.flutter_activity_recognition.models

import com.google.gson.annotations.SerializedName

data class ActivityData(
	@SerializedName("activityType") val activityType: String,
	@SerializedName("transitionType") val transitionType: String
)
