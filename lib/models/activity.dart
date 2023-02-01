import 'package:flutter_activity_recognition/models/activity_transition.dart';
import 'package:flutter_activity_recognition/models/activity_type.dart';

/// A model representing the user's activity.
class Activity {
  /// The type of activity recognized.
  final ActivityType type;

  /// The transition of activity recognized.
  final ActivityTransition transition;

  final DateTime timeStamp;

  /// Constructs an instance of [Activity].
  const Activity(this.type, this.transition, this.timeStamp);

  /// Returns the data fields of [Activity] in JSON format.
  Map<String, dynamic> toJson() => {
        'type': type,
        'transition': transition,
        'timeStamp': timeStamp,
      };

  /// Gets an activity of type UNKNOWN.
  static Activity get unknown =>
      Activity(ActivityType.UNKNOWN, ActivityTransition.ENTER, DateTime.now());

  @override
  bool operator ==(Object other) =>
      other is Activity &&
      runtimeType == other.runtimeType &&
      type == other.type &&
      transition == other.transition;

  @override
  int get hashCode => type.hashCode ^ transition.hashCode;
}
