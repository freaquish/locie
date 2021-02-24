import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';

class Appbar {
  appbar(
      {Widget title,
      BuildContext context,
      Function onTap,
      List<Widget> actions}) {
    _goBack(parentContext) {
      if (onTap == null) {
        Navigator.pop(parentContext);
      } else {
        onTap();
      }
    }

    return AppBar(
      centerTitle: true,
      backgroundColor: Colour.bgColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 28.0,
        onPressed: () {
          _goBack(context);
        },
      ),
      actions: actions,
      title: title,
      elevation: 0,
    );
  }
}
