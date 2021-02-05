import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/rich_image.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  ListingCard({this.listing});
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
              LatoText(listing.name, weight: FontWeight.bold),
              RailwayText(listing.storeName),
              RailwayText(
                "INR ${listing.priceMax.toStringAsFixed(2)} - INR ${listing.priceMin.toStringAsFixed(2)}",
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

class StoreCard extends StatelessWidget {
  final Store store;

  StoreCard({this.store});

  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: scale.vertical(20)),
        padding: EdgeInsets.symmetric(vertical: scale.vertical(40)),
        decoration: BoxDecoration(
            color: Colour.textfieldColor,
            borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: RichImage(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LatoText(store.name, weight: FontWeight.bold),
              // RailwayText("Jaiswal Trading Company"),
              RailwayText(
                store.rating.toString(),
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
