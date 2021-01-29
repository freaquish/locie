import 'package:flutter/material.dart';
import 'package:locie/helper/screen_size.dart';

class CircularLoading extends StatelessWidget {
  Scale scale;
  @override
  Widget build(BuildContext context) {
    scale = Scale(context);
    return Container(
      width: scale.horizontal(100),
      height: scale.vertical(1000),
      child: Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
