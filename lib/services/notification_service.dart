import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

/// Singleton service for daily study reminder notifications.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _keyEnabled = 'reminder_enabled';
  static const String _keyHour = 'reminder_hour';
  static const String _keyMinute = 'reminder_minute';
  static const int _notificationId = 42;
  static const String _channelId = 'study_reminder';
  static const String _channelName = 'Recordatorio de estudio';
  static const String _channelDescription =
      'Notificación diaria para recordarte estudiar';

  // ── Reminder messages (rotated daily) ──────────────────────────────────────
  static const List<String> _messages = [
    '¿Ya practicaste hoy? 📚 Mantén tu racha de estudio.',
    '¡Tu examen de manejo te espera! 🚗 Practica 5 minutos.',
    '¡No pierdas tu racha! 🔥 Haz un examen de práctica.',
    'Un repaso al día mantiene la multa alejada 😄',
    '¡Tú puedes! 💪 Revisa las preguntas difíciles hoy.',
    '5 minutos de estudio = más cerca de tu licencia 🎯',
    '¿Listo para aprobar? Practica ahora y asegura tu éxito 🏆',
  ];

  /// Initialize the notification plugin and timezone data.
  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
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

    await _plugin.initialize(initSettings);

    // Reschedule on app start if enabled
    if (await isReminderEnabled()) {
      final hour = await getReminderHour();
      final minute = await getReminderMinute();
      await scheduleDailyReminder(hour, minute);
    }
  }

  /// Request notification permissions (needed for Android 13+ and iOS).
  Future<bool> requestPermissions() async {
    // Android
    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      if (granted != true) return false;
      await androidPlugin.requestExactAlarmsPermission();
    }

    // iOS
    final iosPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (granted != true) return false;
    }

    return true;
  }

  /// Schedule a daily notification at the given [hour] and [minute].
  Future<void> scheduleDailyReminder(int hour, int minute) async {
    await cancelReminder();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Pick a message based on day of year for rotation
    final messageIndex = scheduledDate.day % _messages.length;

    await _plugin.zonedSchedule(
      _notificationId,
      '¡Hora de estudiar! 🚗',
      _messages[messageIndex],
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: const BigTextStyleInformation(''),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // Persist settings
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, true);
    await prefs.setInt(_keyHour, hour);
    await prefs.setInt(_keyMinute, minute);
  }

  /// Cancel the daily reminder.
  Future<void> cancelReminder() async {
    await _plugin.cancel(_notificationId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, false);
  }

  // ── Settings getters ──────────────────────────────────────────────────────

  Future<bool> isReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyEnabled) ?? false;
  }

  Future<int> getReminderHour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyHour) ?? 20; // Default 8:00 PM
  }

  Future<int> getReminderMinute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMinute) ?? 0;
  }
}
