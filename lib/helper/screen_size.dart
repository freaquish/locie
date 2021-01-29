import 'package:flutter/material.dart';

class Scale {
  final BuildContext context;
  const Scale(this.context);

  double vertical(double height) =>
      MediaQuery.of(context).size.height * height / 1000;

  double horizontal(double width) =>
      MediaQuery.of(context).size.width * width / 100;
}
