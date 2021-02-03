import 'package:flutter/material.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/store.dart';

class StoreAboutWidget extends StatelessWidget {
  final Store store;
  StoreAboutWidget(this.store);

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
            store.name,
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
            LatoText('${store.rating.toStringAsFixed(1)} Rating', size: 18)
          ]),
          SizedBox(
            height: screen.vertical(20),
          ),
          RailwayText(
            store.description,
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
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/whatsapp_icon.png'))),
            ),
            SizedBox(
              width: screen.horizontal(2),
            ),
            LatoText(store.contact, size: 20)
          ]),
        ],
      ),
    );
  }
}
