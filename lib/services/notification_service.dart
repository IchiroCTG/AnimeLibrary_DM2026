import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Encapsula la inicialización y el disparo de notificaciones locales.
///
/// Se usa como "salida visible" del Background Task: cuando el
/// [BackgroundSyncService] detecta cambios en el catálogo mientras la app
/// está cerrada o en segundo plano, esta clase es la responsable de
/// mostrarle algo al usuario en la bandeja del sistema.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'anime_sync_channel',
    'Sincronización de catálogo',
    description:
        'Avisa cuando hay novedades en el catálogo tras sincronizar en segundo plano',
    importance: Importance.defaultImportance,
  );

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(initSettings);

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(_channel);

    _initialized = true;
  }

  /// Pide permiso explícito de notificaciones (Android 13+ / iOS).
  Future<bool> requestPermissions() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    final androidGranted =
        await androidImpl?.requestNotificationsPermission() ?? true;
    final iosGranted = await iosImpl?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        true;

    return androidGranted && iosGranted;
  }

  Future<void> showNewContentNotification({
    required String title,
    required String body,
  }) async {
    if (!_initialized) await init();

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}
