import 'package:flutter/material.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';

class StoreAboutWidget extends StatelessWidget {
  final String storeName = "Jaiswal Trading Company";
  final String description =
      'Shopping is an activity in which a customer browses the available goods or services presented by one or more retailers with the potential intent to purchase a suitable selection of them. A typology of shopper types has been developed by scholars which identifies one group of shoppers as recreational shoppers,[1] that is, those who enjoy shopping and view it as a leisure activity..';
  final String contactDetails = "8574047383";

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screen.horizontal(4), vertical: screen.vertical(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LatoText(
            storeName,
            size: 28,
            style: FontStyle.normal,
            weight: FontWeight.w900,
          ),
          SizedBox(
            height: screen.vertical(20),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              Icons.star,
              color: Colors.amberAccent[700],
              size: 21,
            ),
            SizedBox(
              width: screen.horizontal(2),
            ),
            LatoText('4.8 Rating', size: 18)
          ]),
          SizedBox(
            height: screen.vertical(20),
          ),
          RailwayText(
            description,
            size: 18,
          ),
          SizedBox(
            height: screen.vertical(25),
          ),
          LatoText(
            'Contact',
            size: 28,
            style: FontStyle.normal,
            weight: FontWeight.w900,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              Icons.comment,
              color: Colors.amberAccent[700],
              size: 28,
            ),
            SizedBox(
              width: screen.horizontal(2),
            ),
            LatoText(contactDetails, size: 20)
          ]),
        ],
      ),
    );
  }
}
