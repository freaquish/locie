import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';


class SendNotification {
  final fcm = FirebaseMessaging();
  final db = FirebaseFirestore.instance;

  getToken({String userId}) async {
    List listofTokens = [];
    final userToken = await db.collection('accounts').doc(userId).get();
    listofTokens = userToken['tokens'];
    return listofTokens;
  }

  Future<void> sendNotification({
    String sender,
    String message,
    String notificationType,
    String notificationTitle,
    dynamic tokens,
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
        print('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      debugPrint(e);
      // debugPrint('exception $e');
    }
  }
}


