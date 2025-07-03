import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:load_pilot/models/load.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const windowsSettings = WindowsInitializationSettings(
      appName: 'LoadPilot',
      appUserModelId: 'com.centurytrucking.loadpilot',
      guid: '3F2504E0-4F89-11D3-9A0C-0305E82C3301',
    );

    const settings = InitializationSettings(
      android: androidSettings,
      windows: windowsSettings,
    );

    await _notifications.initialize(settings);
  }

  static Future<void> showPickupAlert(Load load) async {
    const android = AndroidNotificationDetails(
      'pickup_alerts',
      'Pickup Alerts',
      channelDescription: 'Notifications for upcoming pickups',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _notifications.show(
      load.key.hashCode,
      'Pickup coming up!',
      'Driver ${load.driverName} has pickup at ${load.pickupLocation} in < 1 h.',
      NotificationDetails(android: android),
    );
  }
}
