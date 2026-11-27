import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

const _channelId = 'new_audio_channel';
const _channelName = 'Audio Baru';
const _channelDescription = 'Notifikasi saat ada audio Hadi baru';

// The plugin asks for permission during initialization unless every one of
// these is off; the app asks later, from its own explanation sheet.
const _darwinSettings = DarwinInitializationSettings(
  requestAlertPermission: false,
  requestBadgePermission: false,
  requestSoundPermission: false,
);

/// The plugin refuses to initialize on a platform that has no settings here.
const localNotificationInitSettings = InitializationSettings(
  android: AndroidInitializationSettings('@drawable/ic_stat_notify'),
  iOS: _darwinSettings,
  macOS: _darwinSettings,
);

/// The parts of [FlutterLocalNotificationsPlugin] the app uses, so they can be
/// faked.
abstract class LocalNotificationsClient {
  Future<void> createChannel();

  Future<void> initialize({required void Function(String? payload) onTap});

  /// Payload of the local notification whose tap launched the app, if any.
  /// Such a tap does not reach `onTap`.
  Future<String?> launchPayload();

  Future<void> show({
    required int id,
    required String payload,
    String? title,
    String? body,
  });
}

@LazySingleton(as: LocalNotificationsClient)
class PluginLocalNotificationsClient implements LocalNotificationsClient {
  late final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> createChannel() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.high,
          ),
        );
  }

  @override
  Future<void> initialize({
    required void Function(String? payload) onTap,
  }) async {
    await _plugin.initialize(
      settings: localNotificationInitSettings,
      onDidReceiveNotificationResponse: (response) => onTap(response.payload),
    );
  }

  @override
  Future<String?> launchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    return details.notificationResponse?.payload;
  }

  @override
  Future<void> show({
    required int id,
    required String payload,
    String? title,
    String? body,
  }) => _plugin.show(
    id: id,
    title: title,
    body: body,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(_channelId, _channelName),
    ),
    payload: payload,
  );
}
