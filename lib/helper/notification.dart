import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SendNotification {
  final fcm = FirebaseMessaging();
  final db = FirebaseFirestore.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  SendNotification() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<List<String>> getToken({String userId}) async {
    List<String> listofTokens = [];
    final userToken =
        await db.collection('tokens').where("uid", isEqualTo: userId).get();
    listofTokens = userToken.docs.map((e) => e["token"].toString()).toList();
    return listofTokens;
  }

  Future<void> sendNotification({
    String sender,
    String message,
    String notificationType,
    String notificationTitle,
    List<String> tokens,
  }) async {
    final data = {
      "notification": {
        "body": "$message",
        "title": "$notificationTitle",
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "type": "$notificationType",
        "sender": "$sender",
      },
      "registration_ids": tokens,
      "collapse_key": "$sender",
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAH_N4ZZI:APA91bGaBbwrDF1p056D0JsRMWoYLrqhM8qCM484ea0TFpER99RfkFuwptlC2D06F8tWwr9ijyn3716ixPKBqOD7LmhJmJ6el6w8LAwobHb5aWDSnFY4YhwYUScjpkvuN6rD09TZBdfO',
    };
    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    try {
      final response = await Dio(options).post(postUrl, data: data);

      if (response.statusCode == 200) {
        debugPrint('message sent');
      } else {
        //('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      debugPrint(e);
      // debugPrint('exception $e');
    }
  }

  Future<void> shownotification({
    BuildContext context,
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload,
    String channelId = '1234',
    String channelTitle = 'Android Channel',
    String channelDescription = 'Default Android Channel for notifications',
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      playSound: true,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
