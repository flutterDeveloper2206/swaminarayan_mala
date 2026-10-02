import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../data/local/local_database.dart';
import '../../data/models/settings_model.dart';
import '../helpers/date_helper.dart';

typedef ReminderTapCallback = void Function(String? payload);

class ReminderService {
  ReminderService._();
  static final ReminderService instance = ReminderService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  ReminderTapCallback? onNotificationTap;
  bool _initialized = false;

  static const int _dailyId = 1001;
  static const int _morningId = 1002;
  static const int _afternoonId = 1003;
  static const int _eveningId = 1004;

  Future<void> init({ReminderTapCallback? onTap}) async {
    if (_initialized) return;
    onNotificationTap = onTap;
    try {
      tzdata.initializeTimeZones();
      try {
        final name = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(name));
      } catch (_) {
        tz.setLocalLocation(tz.getLocation('UTC'));
      }

      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      await _plugin.initialize(
        const InitializationSettings(android: android, iOS: ios),
        onDidReceiveNotificationResponse: (response) {
          onNotificationTap?.call(response.payload);
        },
      );
      _initialized = true;
    } catch (e) {
      debugPrint('ReminderService init: $e');
    }
  }

  Future<bool> requestPermission() async {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        final granted = await android.requestNotificationsPermission();
        return granted ?? false;
      }
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        final granted = await ios.requestPermissions(alert: true, badge: true, sound: true);
        return granted ?? false;
      }
      return true;
    } catch (e) {
      debugPrint('Reminder permission: $e');
      return false;
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> syncFromSettings(SettingsModel settings, {String? bodyOverride}) async {
    await cancelAll();
    if (!settings.reminder.enabled) return;

    final today = LocalDatabase.instance.getDayAggregate(DateHelper.todayKey());
    final body = bodyOverride ??
        (today.targetCompleted
            ? null
            : (today.totalCount > 0 && today.target > today.totalCount
                ? 'target'
                : 'default'));

    if (body == null && !settings.reminder.morningEnabled) {
      // Target already complete — skip default nagging reminder.
      if (!settings.reminder.afternoonEnabled && !settings.reminder.eveningEnabled) {
        return;
      }
    }

    await _scheduleDaily(
      id: _dailyId,
      hour: settings.reminder.hour,
      minute: settings.reminder.minute,
      title: 'Swaminarayan Maala',
      body: body == 'target'
          ? 'A little more Naam will complete today\'s target.'
          : 'Your sadhana awaits you today.',
      payload: 'jap|${settings.selectedMantraId}|${DateHelper.todayKey()}',
    );

    if (settings.reminder.morningEnabled) {
      await _scheduleDaily(
        id: _morningId,
        hour: 7,
        minute: 0,
        title: 'Swaminarayan Maala',
        body: 'Begin the day with Naam Jap.',
        payload: 'jap|${settings.selectedMantraId}|morning',
      );
    }
    if (settings.reminder.afternoonEnabled) {
      await _scheduleDaily(
        id: _afternoonId,
        hour: 13,
        minute: 0,
        title: 'Swaminarayan Maala',
        body: 'A few moments of Naam smaran.',
        payload: 'jap|${settings.selectedMantraId}|afternoon',
      );
    }
    if (settings.reminder.eveningEnabled) {
      await _scheduleDaily(
        id: _eveningId,
        hour: 19,
        minute: 0,
        title: 'Swaminarayan Maala',
        body: 'Complete the day with a little Jap.',
        payload: 'jap|${settings.selectedMantraId}|evening',
      );
    }
  }

  Future<void> _scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'japnaam_daily',
      'Daily Sadhana',
      channelDescription: 'Daily Naam Jap reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails();

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstance(hour, minute),
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
