import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/utils/api_client.dart';
import '../api/utils/api_constants.dart';
import '../api/utils/token_manager.dart';
import '../navigation/cc_route_helper.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class PushNotificationService {
  static PushNotificationService? _instance;
  static PushNotificationService get instance {
    _instance ??= PushNotificationService._();
    return _instance!;
  }

  PushNotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';

  bool _initialized = false;
  String? _cachedFcmToken;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    // Set top-level background messaging handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize local notifications for foreground display
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null && details.payload!.isNotEmpty) {
          try {
            final data = jsonDecode(details.payload!) as Map<String, dynamic>;
            _handleNotificationTap(data);
          } catch (_) {}
        }
      },
    );

    // Create Notification Channel for Android
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: 'This channel is used for important medication notifications.',
        importance: Importance.max,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message);
    });

    // Tap message handler (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message.data);
    });

    // Tap message handler (app launched from terminated state)
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage.data);
    }

    // Listen to token refresh
    _fcm.onTokenRefresh.listen((newToken) {
      _cachedFcmToken = newToken;
      registerDeviceToken(newToken);
    });
  }

  Future<void> requestPermissionAndRegister() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      final token = await _fcm.getToken();
      if (token != null) {
        _cachedFcmToken = token;
        await registerDeviceToken(token);
      }
    }
  }

  Future<void> registerDeviceToken([String? token]) async {
    final fcmToken = token ?? _cachedFcmToken ?? await _fcm.getToken();
    if (fcmToken == null || fcmToken.isEmpty) return;
    _cachedFcmToken = fcmToken;

    final hasSession = await TokenManager.instance.hasStoredSession();
    if (!hasSession) return;

    try {
      final api = await ApiService.authenticated();
      await api.post(
        ApiConstants.deviceTokens,
        data: {
          'fcmToken': fcmToken,
          'platform': Platform.isAndroid ? 'android' : 'ios',
        },
      );
    } catch (_) {}
  }

  Future<void> unregisterDeviceToken() async {
    final token = _cachedFcmToken ?? await _fcm.getToken();
    if (token == null || token.isEmpty) return;

    try {
      final api = await ApiService.authenticated();
      await api.delete(
        ApiConstants.deviceTokens,
        data: {'fcmToken': token},
      );
    } catch (_) {}
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    final title = notification?.title ??
        message.data['title'] ??
        'Time to take your medication';
    final body = notification?.body ??
        message.data['body'] ??
        'Your scheduled dose is due now. Tap to confirm.';

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    final slotId = data['referenceId'] ?? data['slotId'];
    if (slotId == null || slotId.toString().isEmpty) return;

    _showDoseRespondDialog(slotId.toString());
  }

  void _showDoseRespondDialog(String slotId) {
    final context = CcRouteHelper.navigatorContext;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6FAF9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medication,
                    color: Color(0xFF055F58),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medication Reminder',
                        style: GoogleFonts.sora(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A2B35),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Time to take your scheduled dose',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: const Color(0xFF7A96A4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await _respondSlot(slotId, 'SKIPPED');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE4EEF2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.sora(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7A96A4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await _respondSlot(slotId, 'TAKEN');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF055F58),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Taken',
                      style: GoogleFonts.sora(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _respondSlot(String slotId, String action) async {
    try {
      final api = await ApiService.authenticated();
      await api.post(
        ApiConstants.slotRespond(slotId),
        data: {'action': action},
      );
      final context = CcRouteHelper.navigatorContext;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dose marked as ${action.toLowerCase()}'),
            backgroundColor: const Color(0xFF055F58),
          ),
        );
      }
    } catch (e) {
      final context = CcRouteHelper.navigatorContext;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to respond to dose: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
