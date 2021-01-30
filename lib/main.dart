import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:locie/views/Add%20Item/item_meta_data.dart';
import 'package:locie/views/Create%20Store/avatar_name.dart';

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
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ItemMetaDataWidget(),
    );
  }
}
