import 'package:flutter/material.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/get_it.dart';
import 'package:locie/helper/screen_size.dart';

class ContactPage extends StatelessWidget {
  void onBackClick(BuildContext context) {
    NavigationController.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return WillPopScope(
      onWillPop: () async {
        onBackClick(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colour.bgColor,
        appBar: Appbar().appbar(
            context: context,
            title: LatoText('Contact'),
            onTap: () {
              onBackClick(context);
            }),
        body: Padding(
          padding: EdgeInsets.only(
              top: screen.vertical(50), left: screen.horizontal(4)),
          child: Column(
            children: [
              LatoText(
                'Contact Us',
                size: 32,
              ),
              SizedBox(
                height: screen.vertical(30),
              ),
              LatoText(
                '+916392886167',
                size: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
