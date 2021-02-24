import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';

class NotInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Scale screen = Scale(context);
    return Scaffold(
      backgroundColor: Color(0xff594694),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screen.horizontal(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screen.vertical(200),
              ),
              Container(
                height: screen.vertical(150),
                width: screen.horizontal(40),
                child: Image.asset(
                  "assets/images/no_internet.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: screen.vertical(100),
              ),
              RailwayText(
                'NO INTERNET CONNECTION',
                size: 18,
              ),
              SizedBox(
                height: screen.vertical(20),
              ),
              LatoText(
                'Check your internet connection\n                    and try again.',
                size: 14,
                fontColor: Colors.grey[300],
              ),
              SizedBox(
                height: screen.vertical(20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
