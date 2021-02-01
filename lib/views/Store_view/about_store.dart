import 'package:flutter/material.dart';
import 'package:locie/components/font_text.dart';

class StoreAboutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [LatoText("Jaiswal Trading Company")],
      ),
    );
  }
}

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

class StoreWorksWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [LatoText("Jaiswal Works Trading Company")],
      ),
    );
  }
}

class StoreReviewsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [LatoText("Jaiswal Reviews Trading Company")],
      ),
    );
  }
}
