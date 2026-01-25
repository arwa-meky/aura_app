import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'sms_service.dart';

const String isolateName = 'notification_cancel_port';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.actionId == 'cancel_alert') {
    print("🛑 Background Action: Cancel Clicked");

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.cancelAll();

    final SendPort? uiSendPort = IsolateNameServer.lookupPortByName(
      isolateName,
    );
    if (uiSendPort != null) {
      print("bridge found, sending cancel signal...");
      uiSendPort.send('cancel_alert');
    } else {
      print("bridge not found!");
    }
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<void> _cancelStreamController =
      StreamController.broadcast();
  Stream<void> get onCancelStream => _cancelStreamController.stream;

  Timer? _emergencyTimer;
  static const int _notificationId = 888;

  final ReceivePort _port = ReceivePort();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    IsolateNameServer.removePortNameMapping(isolateName);
    IsolateNameServer.registerPortWithName(_port.sendPort, isolateName);

    _port.listen((message) {
      if (message == 'cancel_alert') {
        print("🔔 Main App received cancel signal from Background!");
        stopEmergencySequence();
      }
    });
    _isInitialized = true;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.actionId == 'cancel_alert') {
          stopEmergencySequence();
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> startEmergencyCountdown({
    required String title,
    required String lat,
    required String lon,
  }) async {
    stopEmergencySequence();
    await _showInteractiveNotification(title);

    print("⏳ Countdown Started (10s)...");

    _emergencyTimer = Timer(const Duration(seconds: 10), () async {
      print("🚨 Timer Ended. Sending Help...");
      await SmsService.sendEmergencySMS(
        phoneNumber: "01064351868", // ⚠️رقمي
        message:
            "🚨 SOS! $title\nLoc: http://googleusercontent.com/maps.google.com/?q=$lat,$lon",
      );
      await SmsService.makeDirectCall("01064351868"); // ⚠️رقمي
      stopEmergencySequence();
    });
  }

  void stopEmergencySequence() {
    if (_emergencyTimer != null && _emergencyTimer!.isActive) {
      _emergencyTimer!.cancel();
    }
    flutterLocalNotificationsPlugin.cancelAll();
    _cancelStreamController.add(null);
    print("🛑 Sequence Stopped by User/System");
  }

  Future<void> _showInteractiveNotification(String title) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'emergency_channel_v4',
          'Emergency Alerts',
          channelDescription: 'SOS Countdown',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          ongoing: true,
          playSound: true,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'cancel_alert',
              'I AM OK (Cancel)',
              showsUserInterface: false,
              cancelNotification: true,
              titleColor: Color.fromARGB(255, 0, 180, 0),
            ),
          ],
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      _notificationId,
      title,
      "Calling help in 10 seconds...",
      platformDetails,
    );
  }
}
