import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AzanService {
  static final AzanService _instance = AzanService._internal();
  factory AzanService() => _instance;
  AzanService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings: initSettings);
    _initialized = true;
  }

  /// Schedule azan notifications for all 5 prayers today.
  /// [prayerTimes] is a map of prayer name → DateTime (local time).
  Future<void> scheduleAllPrayerAlarms({
    required Map<String, DateTime> prayerTimes,
    required bool azanEnabled,
    String soundAsset = 'azan1',
  }) async {
    await cancelAllAlarms();
    if (!azanEnabled) return;

    final prayers = {'fajr': 0, 'dhuhr': 1, 'asr': 2, 'maghrib': 3, 'isha': 4};

    for (final entry in prayers.entries) {
      final name = entry.key;
      final id = entry.value;
      final time = prayerTimes[name];
      if (time == null) continue;

      // Only schedule future prayers
      if (time.isBefore(DateTime.now())) continue;

      final tzTime = tz.TZDateTime.from(time, tz.local);

      if (Platform.isAndroid) {
        const androidDetails = AndroidNotificationDetails(
          'azan_channel',
          'Azan Notifications',
          channelDescription: 'Azan prayer time notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          channelShowBadge: true,
        );

        await _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.zonedSchedule(
              id: id,
              title: '${_capitalize(name)} Prayer Time',
              body: "It's time to pray! May Allah accept your salah.",
              scheduledDate: tzTime,
              notificationDetails: androidDetails,
              scheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            );
      } else if (Platform.isIOS) {
        const iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBadge: true,
        );

        await _notifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.zonedSchedule(
              id: id,
              title: '${_capitalize(name)} Prayer Time',
              body: "It's time to pray! May Allah accept your salah.",
              scheduledDate: tzTime,
              notificationDetails: iosDetails,
            );
      }
    }
  }

  Future<void> cancelAllAlarms() async {
    for (int i = 0; i < 5; i++) {
      await _notifications.cancel(id: i);
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
