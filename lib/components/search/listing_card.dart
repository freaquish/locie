import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/rich_image.dart';
import 'package:locie/helper/screen_size.dart';

class ListingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: scale.vertical(20)),
        padding: EdgeInsets.symmetric(vertical: scale.vertical(20)),
        decoration: BoxDecoration(
            color: Colour.textfieldColor,
            borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: RichImage(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LatoText("PVC door", weight: FontWeight.bold),
              RailwayText("Jaiswal Trading Company"),
              RailwayText(
                "INR 40 - INR 38",
                size: 12,
                fontColor: Colors.amberAccent[700],
              )
            ],
          ),
          tileColor: Colour.textfieldColor,
        ),
      ),
    );
  }
}
