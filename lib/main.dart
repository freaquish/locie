import 'dart:async';

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
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  DynamicLinksService dynmaicLinksService = DynamicLinksService();
  NavigationEvent event = NavigateToHome();
  Timer _timerLink;
  SendNotification notification;

  @override
  void initState() {
    // firebaseSetUp();
    // Firebase.initializeApp();

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  final FirebaseMessaging fcm = FirebaseMessaging();

  Future<bool> firebaseSetUp(BuildContext context) async {
    await Firebase.initializeApp();
    handleLinkInAppLifeCycle(context);
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
    return true;
  }

  void handleLinkInAppLifeCycle(BuildContext context) {
    _timerLink = new Timer(const Duration(milliseconds: 1000), () {
      dynmaicLinksService.handleDynamicLink(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      handleLinkInAppLifeCycle(context);
    } else if (state == AppLifecycleState.inactive) {
      handleLinkInAppLifeCycle(context);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // firebaseSetUp(context);
    return Scaffold(
      body: FutureBuilder(
        future: firebaseSetUp(context),
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
