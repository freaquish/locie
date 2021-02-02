import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/helper/screen_size.dart';

class NotInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return Scaffold(
      backgroundColor: Color(0xff40286A),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: scale.horizontal(10)),
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  "assets/images/no_internet.png",
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
