import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _reportChannel =
      AndroidNotificationChannel(
        'report_channel',
        'Laporan Lalu Lintas',
        description: 'Notifikasi saat laporan berhasil disimpan.',
        importance: Importance.high,
      );

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );

    await _plugin.initialize(
      settings: settings,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_reportChannel);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> showReportSavedNotification({
    required List<String> categories,
    required String status,
  }) async {
    final String body = categories.isEmpty
        ? 'Status laporan Anda: $status'
        : 'Kategori: ${categories.join(', ')} - Status: $status';

    await _plugin.show(
      id: 1001,
      title: 'Laporan berhasil disimpan',
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'report_channel',
          'Laporan Lalu Lintas',
          channelDescription: 'Notifikasi saat laporan berhasil disimpan.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
