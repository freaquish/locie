import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Scaffold(
      backgroundColor: Colour.bgColor,
      //appBar: Appbar().appbar(),
      body: Column(
        children: [
          LatoText(
            'Contact',
            size: 32,
          ),
          SizedBox(
            height: screen.horizontal(30),
          ),
          LatoText(
            '+916392886167',
            size: 16,
          )
        ],
      ),
    );
  }
}
