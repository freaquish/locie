import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:locie/bloc/previous_examples_bloc.dart';
import 'package:locie/models/category.dart';
import 'package:locie/pages/category.dart';
import 'package:locie/pages/listing_widget.dart';
import 'package:locie/pages/previous_examples.dart';
import 'package:locie/views/Example/previous_example.dart';

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
    super.initState();
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
            return PreviousExampleProvider(
              event: null,
            );
          }
        },
      ),
    );
  }
}
