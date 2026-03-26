import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/user_session.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<bool> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    try {
      await _plugin.initialize(settings);
      await _requestPermissions();
      _initialized = true;
    } catch (_) {
      _initialized = false;
    }
    return _initialized;
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidSpecific = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidSpecific?.requestNotificationsPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosSpecific = _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      await iosSpecific?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> showLoginSuccess(UserSession session) async {
    if (!_initialized) return;
    const androidDetails = AndroidNotificationDetails(
      'auth_flow_channel',
      'Authentication Updates',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'auth_flow',
    );
    const iosDetails = DarwinNotificationDetails();
    const platformDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      1001,
      'Welcome, ${session.displayName}',
      'Signed in via ${session.provider.label}',
      platformDetails,
    );
  }
}
