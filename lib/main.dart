import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/bloc/store_view_bloc.dart';
import 'package:locie/helper/dynamic_link_service.dart';
import 'package:locie/pages/navigation_track.dart';
import 'package:locie/pages/store_bloc_view.dart';
import 'package:locie/views/home_page.dart';

import 'package:locie/models/quotations.dart';
import 'package:locie/views/home_page.dart';

import 'package:locie/views/not_internet_widget.dart';
import 'package:locie/views/quotation/myQuotation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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

  @override
  void initState() {
    super.initState();
  }

  Future<NavigationEvent> firebaseSetUp() async {
    await Firebase.initializeApp();
    var event = await dynmaicLinksService.getDynamicEvent();
    print(event);
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
              event: LaunchItemView("1ee9b16a-62a4-5cd9-b086-4549248ba280"),
            );
          }
        },
      ),
    );
  }
}
