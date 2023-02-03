import 'dart:ffi';

/// A model representing the user's sleep event.
class Sleep {
  /// The confidence
  final int confidence;

  /// The surrounding light level (from 1 to 6)
  final int light;

  /// The device's motion (from 1 to 6)
  final int motion;

  /// The momment that the sleep sensor collect data
  final int timeStamp;

  /// Constructs an instance of [Sleep].
  const Sleep(this.confidence, this.light, this.motion, this.timeStamp);

  /// Returns the data fields of [Sleep] in JSON format.
  Map<String, dynamic> toJson() => {
        'confidence': confidence,
        'light': light,
        'motion': motion,
        'timeStamp': timeStamp,
      };

  @override
  bool operator ==(Object other) =>
      other is Sleep &&
      runtimeType == other.runtimeType &&
      confidence == other.confidence &&
      light == other.light &&
      motion == other.motion &&
      timeStamp == other.timeStamp;

  @override
  int get hashCode => timeStamp.hashCode ^ confidence.hashCode;
}
