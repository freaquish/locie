import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/get_it.dart';

class NoStoreExists extends StatelessWidget {
  void onBackClick(BuildContext context) {
    NavigationController.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBackClick(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colour.bgColor,
          leading: IconButton(
              icon: Icon(Icons.keyboard_backspace, color: Colors.white),
              onPressed: () {
                onBackClick(context);
              }),
        ),
        body: PrimaryContainer(
          widget: Center(
            child: LatoText(
              "No such store exists",
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
