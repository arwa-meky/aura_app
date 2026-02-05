import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String type,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    bool allowGeneral = prefs.getBool('notify_general') ?? true;
    if (!allowGeneral) return;

    if (type == 'updates') {
      if ((prefs.getBool('notify_updates') ?? false) == false) return;
    }
    if (type == 'service') {
      if ((prefs.getBool('notify_service') ?? true) == false) return;
    }
    if (type == 'tips') {
      if ((prefs.getBool('notify_tips') ?? false) == false) return;
    }

    bool allowSound = prefs.getBool('notify_sound') ?? true;
    bool allowVibrate = prefs.getBool('notify_vibrate') ?? true;

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'aura_channel_id',
      'Aura Notifications',
      channelDescription: 'Notifications for Aura Health App',
      importance: Importance.max,
      priority: Priority.high,

      playSound: allowSound,
      enableVibration: allowVibrate,

      sound: allowSound
          ? RawResourceAndroidNotificationSound('alert_tone')
          : null,
    );

    NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(id, title, body, details);
  }
}
