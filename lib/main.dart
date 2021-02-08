import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/helper/dynamic_link_service.dart';
import 'package:locie/helper/notification.dart';

import 'package:locie/pages/navigation_track.dart';
import 'package:locie/views/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DynamicLinksService dynmaicLinksService = DynamicLinksService();
  NavigationEvent event = NavigateToHome();
  SendNotification notification;

  @override
  void initState() {
    firebaseSetUp();
    // Firebase.initializeApp();

    super.initState();
  }

  final FirebaseMessaging fcm = FirebaseMessaging();

  Future<void> firebaseSetUp() async {
    await Firebase.initializeApp();
    event = await dynmaicLinksService.getDynamicEvent();
    notification = SendNotification();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (value) {});
    fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          notification.shownotification(
              context: context,
              notificationId: 1234,
              notificationTitle: message['notification']['title'],
              notificationContent: message['notification']['body']);
        },
        onResume: (Map<String, dynamic> message) async {},
        onLaunch: (Map<String, dynamic> message) async {});
  }

  @override
  Widget build(BuildContext context) {
    // firebaseSetUp(context);
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SplashScreen();
          } else {
            return NavigationProvider(
              event: event,
            );
          }
        },
      ),
    );
  }
}
