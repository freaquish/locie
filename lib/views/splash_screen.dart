import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/helper/screen_size.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      backgroundColor: Color(0xff1F0037),
      body: Center(
        child: Container(
          height: screen.vertical(45),
          width: screen.horizontal(42),
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/app_icon.png'),
          )),
        ),
      ),
    );
  }
}
