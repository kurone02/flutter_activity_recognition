/// Defines the confidence of activity.
enum ActivityTransition {
  /// Enter the activity
  ENTER,

  /// Exit the activity
  EXIT,
}

/// Returns the activity confidence from [value].
ActivityTransition getActivityTransitionFromString(String? value) {
  return ActivityTransition.values.firstWhere(
      (e) => e.toString() == 'ActivityTransition.$value',
      orElse: () => ActivityTransition.ENTER);
}
