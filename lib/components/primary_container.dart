import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locie/helper/screen_size.dart';

class PrimaryContainer extends StatelessWidget {
  const PrimaryContainer({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Container(
      width: screen.horizontal(100),
      height: screen.vertical(1000),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // Color(0xff323232),
            Colors.grey[900],
            Colors.black,
          ],
        ),
      ),
      child: widget,
    );
  }
}
