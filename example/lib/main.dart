import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final _activityStreamController = StreamController<Activity>();
  final _sleepStreamController = StreamController<Sleep>();
  StreamSubscription<Activity>? _activityStreamSubscription;
  StreamSubscription<Sleep>? _sleepStreamSubscription;

  void _onActivityReceive(Activity activity) {
    print('Activity Detected >> ${activity.toJson()}');
    _activityStreamController.sink.add(activity);
  }

  void _onSleepReceive(Sleep event) {
    print('Sleep event >> ${event.toJson()}');
    _sleepStreamController.sink.add(event);
  }

  void _handleError(dynamic error) {
    print('Catch Error >> $error');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final activityRecognition = FlutterActivityRecognition.instance;

      // Check if the user has granted permission. If not, request permission.
      PermissionRequestResult reqResult;
      reqResult = await activityRecognition.checkPermission();
      if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
        dev.log('Permission is permanently denied.');
        return;
      } else if (reqResult == PermissionRequestResult.DENIED) {
        reqResult = await activityRecognition.requestPermission();
        if (reqResult != PermissionRequestResult.GRANTED) {
          dev.log('Permission is denied.');
          return;
        }
      }

      // Subscribe to the activity stream.
      _activityStreamSubscription = activityRecognition.activityStream
          .handleError(_handleError)
          .listen(_onActivityReceive);

      // Subscribe to the sleep stream.
      _sleepStreamSubscription = activityRecognition.sleepStream
          .handleError(_handleError)
          .listen(_onSleepReceive);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              title: const Text('Flutter Activity Recognition'),
              centerTitle: true),
          body: _buildContentView()),
    );
  }

  @override
  void dispose() {
    _activityStreamController.close();
    _activityStreamSubscription?.cancel();
    _sleepStreamSubscription?.cancel();
    super.dispose();
  }

  Widget _buildContentView() {
    return StreamBuilder<Activity>(
        stream: _activityStreamController.stream,
        builder: (context, snapshot) {
          final updatedDateTime = DateTime.now();
          final content = snapshot.data?.toJson().toString() ?? '';

          return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                Text('•\t\tActivity (updated: $updatedDateTime)'),
                SizedBox(height: 10.0),
                Text(content)
              ]);
        });
  }
}
