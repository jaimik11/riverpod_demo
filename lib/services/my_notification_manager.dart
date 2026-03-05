import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:c2c/enums/upload_type.dart';
import 'package:c2c/enums/user_type.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/router/route_observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../di/app_providers.dart';
import '../enums/notification_type.dart';
import '../router/app_pages.dart';
import '../utils/logger_util.dart';

/// Enum for App States


class MyNotificationManager {
  MyNotificationManager._();

  factory MyNotificationManager() => _instance;
  static final MyNotificationManager _instance = MyNotificationManager._();

  NotificationSettings? _settings;
  RemoteMessage? _remoteMessage;
  late AndroidNotificationChannel _channel;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationType? notificationType;

  Future<void> init() async {
    await _requestNotificationPermission();
    _initializeLocalNotifications();
    _setupFirebaseListeners();
  }

  /// Request notification permissions
  Future<void> _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    _settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    try {
      if (_settings?.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
          AppConstants.firebaseToken = newToken;
          print("FCM Token refreshed: $newToken");
        });
        String? token = await messaging.getToken();
        if (token != null) {
          AppConstants.firebaseToken = token;
          logger.i('FCM Token: $token');
        } else {
          logger.i("token != null");
        }
      } else {
        logger.w('User denied notification permissions.');
        String? token = await messaging.getToken();
        if (token != null) {
          AppConstants.firebaseToken = token;
          logger.i('FCM Token without notification permission: $token');
        }
      }
    } catch (e) {
     print("ERROR FOR TOKEN -- $e");
    }
  }

  /// Initialize local notification plugin
  void _initializeLocalNotifications() async {
    _channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        logger.i(
          "Notification tapped onDidReceiveNotificationResponse: ${_remoteMessage?.data}",
        );
        if (_remoteMessage != null) {
          _handleNotificationClick(_remoteMessage!);
        }
      },
    );

    if (!kIsWeb) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// Setup Firebase Messaging listeners
  void _setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i("onMessage message: ${message.toMap()}");
      _remoteMessage = message;
      AppConstants.showNotificationDot.value = true;
      notificationType = _getNotificationType(message.data['type']);
      _handleForegroundNotification(message);
    });

    // Background tap (when app is open but in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.i("onMessageOpenedApp message: ${message.toMap()}");
      notificationType = _getNotificationType(message.data['type']);
      _handleNotificationClick(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        logger.i("getInitialMessage message: ${message.toMap()}");
        print("getInitialMessage message: ${message.toMap()}");
        notificationType = _getNotificationType(message.data['type']);
        AppConstants.pendingNotificationData = message.data;
      }
    });
  }

  /// Handle notification in foreground
  void _handleForegroundNotification(RemoteMessage message) {
    logger.i("Foreground notification: ${jsonEncode(message.data)}");
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      _showNotification(notification, message.data);
      _handleForegroundNotifications(message);
    }
  }

  /// Show local notification
  void _showNotification(
    RemoteNotification notification,
    Map<String, dynamic> data,
  ) {
    if (Platform.isAndroid) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            styleInformation: BigTextStyleInformation(notification.body ?? ""),
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            subtitle: notification.body,
            presentSound: true,
          ),
        ),
      );
    }
  }


    /// Handle notification click
    void _handleForegroundNotifications(RemoteMessage message) {
      final type = notificationType ?? _getNotificationType(message.data['type']);

      logger.i("Notification clicked: type=$notificationType");

      print("Notification clicked: type=$notificationType");

      switch (type) {
        case NotificationType.idVerified:
        /// IMPLEMENT REDIRECTION HERE
          break;
        default:
        // TODO: Handle this case.
          throw UnimplementedError();
      }
    }


  /// Handle notification click
  void _handleNotificationClick(RemoteMessage message) {
    final type = notificationType ?? _getNotificationType(message.data['type']);

    logger.i("Notification clicked: type=$notificationType");

    print("Notification clicked: type=$notificationType");

    switch (type) {
      case NotificationType.idVerified:
        /// IMPLEMENT REDIRECTION HERE
        break;
      default:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }



  /// Get notification type from data
  NotificationType _getNotificationType(String? type) {
    switch (type) {
      case 'id_verified':
        return NotificationType.idVerified;
      default:
        return NotificationType.unknown;
    }
  }
}
