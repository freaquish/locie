import 'package:flutter/material.dart';
import 'package:locie/helper/firestore_auth.dart';
import 'package:locie/pages/phone_authentication.dart';
import 'package:locie/pages/verify_otp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PhoneAuthenticationWidget(),
    );
  }
}
