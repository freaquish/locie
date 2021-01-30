import 'package:flutter/material.dart';

class Appbar {
  appbar({Widget title, BuildContext context, Function onTap}) {
    _goBack(parentContext) {
      if (onTap == null) {
        Navigator.pop(parentContext);
      } else {
        onTap();
      }
    }

    return AppBar(
      centerTitle: true,
      backgroundColor: Color(0xff1f1e2c),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 28.0,
        onPressed: () {
          _goBack(context);
        },
      ),
      title: title,
      elevation: 0,
    );
  }
}
