import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:headsup_barbershop/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (message.notification != null) {
    await prefs.setString(
        'lastMessageTitle', message.notification!.title ?? '');
    await prefs.setString('lastMessageBody', message.notification!.body ?? '');
  }
}

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initializeFirebaseMessaging(BuildContext context) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcmToken', fcmToken);
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (context.mounted) {
          _showMessageInApp(context, message);
        }
      });

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        if (context.mounted) {
          _navigateBasedOnMessage(context, initialMessage);
        }
      }

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (context.mounted) _navigateBasedOnMessage(context, message);
      });

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcmToken', newToken);
      });
    }
  }

  static void _showMessageInApp(BuildContext context, RemoteMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: navy,
        title: Text(message.notification?.title ?? '',
            style: const TextStyle(color: textPrimary)),
        content: Text(message.notification?.body ?? '',
            style: const TextStyle(color: textSecondary)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: orange)),
          ),
        ],
      ),
    );
  }

  static void _navigateBasedOnMessage(
      BuildContext context, RemoteMessage message) {
    final routeName = message.data['route'];
    if (routeName != null && routeName.isNotEmpty) {
      Navigator.of(context).pushNamed(routeName);
    }
  }
}
