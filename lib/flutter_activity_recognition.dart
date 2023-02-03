import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_activity_recognition/models/activity.dart';
import 'package:flutter_activity_recognition/models/sleep.dart';
import 'package:flutter_activity_recognition/models/activity_transition.dart';
import 'package:flutter_activity_recognition/models/activity_type.dart';
import 'package:flutter_activity_recognition/models/permission_request_result.dart';

export 'package:flutter_activity_recognition/models/activity.dart';
export 'package:flutter_activity_recognition/models/sleep.dart';
export 'package:flutter_activity_recognition/models/activity_transition.dart';
export 'package:flutter_activity_recognition/models/activity_type.dart';
export 'package:flutter_activity_recognition/models/permission_request_result.dart';

/// A class that provides an activity recognition API.
class FlutterActivityRecognition {
  FlutterActivityRecognition._internal();

  /// Instance of [FlutterActivityRecognition].
  static final instance = FlutterActivityRecognition._internal();

  /// Method channel to communicate with the platform.
  final _methodChannel = MethodChannel('flutter_activity_recognition/method');

  /// Event channel to communicate with the platform.
  final _eventChannel = EventChannel('flutter_activity_recognition/updates');

  /// Event channel to communicate with the platform.
  final _eventChannelSleep =
      EventChannel('flutter_activity_recognition/updates_sleep');

  /// Gets the activity stream.
  Stream<Activity> get activityStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      final data = Map<String, dynamic>.from(jsonDecode(event));
      print(data);
      final type = getActivityTypeFromString(data['activityType']);
      final transitionType =
          getActivityTransitionFromString(data['transitionType']);
      final timeStamp = DateTime.now();
      return Activity(type, transitionType, timeStamp);
    });
  }

  /// Gets the Sleep stream.
  Stream<Sleep> get sleepStream {
    return _eventChannelSleep.receiveBroadcastStream().map((event) {
      final data = Map<String, dynamic>.from(jsonDecode(event));
      print(data);
      final int confidence = data['confidence'];
      final int light = data['light'];
      final int motion = data['motion'];
      final int timeStamp = data['timestamp'];
      return Sleep(confidence, light, motion, timeStamp);
    });
  }

  /// Check whether activity recognition permission is granted.
  Future<PermissionRequestResult> checkPermission() async {
    final permissionResult =
        await _methodChannel.invokeMethod('checkPermission');
    return getPermissionRequestResultFromString(permissionResult);
  }

  /// Request activity recognition permission.
  Future<PermissionRequestResult> requestPermission() async {
    final permissionResult = (Platform.isAndroid)
        ? await _methodChannel.invokeMethod('requestPermission')
        : await _methodChannel.invokeMethod('checkPermission');
    return getPermissionRequestResultFromString(permissionResult);
  }
}
