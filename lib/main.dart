import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/helper/dynamic_link_service.dart';

import 'package:locie/pages/navigation_track.dart';

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

  @override
  void initState() {
    firebaseSetUp();
    // Firebase.initializeApp();
    fcm.configure(
        onMessage: (Map<String, dynamic> message) async {},
        onResume: (Map<String, dynamic> message) async {},
        onLaunch: (Map<String, dynamic> message) async {});
    super.initState();
  }

  final FirebaseMessaging fcm = FirebaseMessaging();

  Future<void> firebaseSetUp() async {
    await Firebase.initializeApp();
    event = await dynmaicLinksService.getDynamicEvent();
  }

  @override
  Widget build(BuildContext context) {
    // firebaseSetUp(context);
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
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
