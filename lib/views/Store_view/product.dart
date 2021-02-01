import 'package:flutter/material.dart';
import 'package:locie/components/font_text.dart';

class StoreProductWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [LatoText("Jaiswal Product Trading Company")],
      ),
    );
  }
}