import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';

class SubmitButton extends StatelessWidget {

  final Function onPressed;
  final Color buttonColor, textColor;
  final String buttonName;

  SubmitButton({@required this.onPressed,@required this.buttonName, this.textColor = Colors.white, @required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    final scale = Scale(context);
    return FlatButton(
      onPressed: onPressed,
      color: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(scale.horizontal(2.8)),
        side: BorderSide.none,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: scale.horizontal(4), vertical: scale.horizontal(4)),
          child: LatoText(
            buttonName,
            fontColor: textColor,
          ),
        ),
      ),
    );
  }
}