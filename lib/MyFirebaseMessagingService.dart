import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_demo/notification_badge.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'TicketListPage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'api/firebase_api.dart';
import 'package:overlay_support/overlay_support.dart';
import 'firebase_options.dart';
import 'PushNotification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyFirebaseMessagingService {
  //static FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> registerNotification() async {
    //await _firebaseMessaging.requestPermission();
    late int _totalNotifications;
    late final FirebaseMessaging _messaging;
    PushNotification? _notificationInfo;
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessingBackgroudHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Handling a background messages: ${message.notification}");
      print("311");
      String title = message.data['title'];
      String body = message.data['body'];
      PushNotification notification = PushNotification(
        title: title ?? message.notification?.title,
        body: body ?? message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      // if(_notificationInfo != null){
      showSimpleNotification(
        Text(title),
        leading: NotificationBadge(totalNotifications: 2),
        subtitle: Text(body),
        background: Colors.cyan.shade700,
        duration: Duration(seconds: 2),
      );
      //}
    });
  }

  static Future _firebaseMessingBackgroudHandler(RemoteMessage message) async {
    print("Handling a background messages: ${message.notification}");
    print("311");
    await Firebase.initializeApp();

    String? title = message.data['title'];
    String? body = message.data['body'];
  }
}
