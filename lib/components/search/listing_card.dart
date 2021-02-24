import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/rich_image.dart';
import 'package:locie/constants.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';
import 'package:locie/pages/store_bloc_view.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  ListingCard({this.listing});

  void onTap(BuildContext context) {
    BlocProvider.of<NavigationBloc>(context).push(LaunchItemView(listing.id));
  }

  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return InkWell(
      onTap: () {
        onTap(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: scale.vertical(20)),
        padding: EdgeInsets.symmetric(vertical: scale.vertical(20)),
        decoration: BoxDecoration(
            color: Colour.textfieldColor,
            borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: Container(
            width: scale.horizontal(16),
            child: RichImage(
              image: listing.image,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LatoText(listing.name, weight: FontWeight.bold),
              RailwayText(listing.storeName),
              RailwayText(
                "$rupeeSign ${listing.priceMax.toStringAsFixed(2)}/${listing.unit} - $rupeeSign ${listing.priceMin.toStringAsFixed(2)}/${listing.unit}",
                size: 14,
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

  void onTap(BuildContext context) {
    BlocProvider.of<NavigationBloc>(context)
        .push(MaterialProviderRoute<StoreWidgetProvider>(
            route: StoreWidgetProvider(
      sid: store.id,
    )));
  }

  ratingIcon(dynamic rating) {
    if (rating >= 0 && rating <= 1.0) {
      return Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
        size: 17,
      );
    } else if (rating >= 1 && rating <= 2) {
      return Icon(
        Icons.sentiment_dissatisfied,
        color: Colors.redAccent,
        size: 17,
      );
    } else if (rating >= 3 && rating <= 4) {
      return Icon(
        Icons.sentiment_neutral,
        color: Colors.amber,
        size: 17,
      );
    } else if (rating >= 4 && rating <= 5) {
      return Icon(
        Icons.sentiment_satisfied,
        color: Colors.lightGreen,
        size: 17,
      );
    } else {
      return Icon(
        Icons.sentiment_very_satisfied,
        color: Colors.green,
        size: 17,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return InkWell(
      onTap: () {
        onTap(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: scale.vertical(20)),
        padding: EdgeInsets.symmetric(vertical: scale.vertical(40)),
        decoration: BoxDecoration(
            color: Colour.textfieldColor,
            borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: Container(
            width: scale.horizontal(16),
            child: RichImage(
              image: store.image,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LatoText(
                store.name,
                weight: FontWeight.bold,
                size: 16,
              ),
              // RailwayText("Jaiswal Trading Company"),
              SizedBox(
                height: scale.vertical(10),
              ),
              Wrap(
                spacing: 14,
                children: [
                  ratingIcon(store.rating),
                  LatoText(
                    double.parse(store.rating.toString()).toStringAsFixed(2),
                    size: 12,
                    fontColor: Colors.amberAccent[700],
                  ),
                ],
              )
            ],
          ),
          tileColor: Colour.textfieldColor,
        ),
      ),
    );
  }
}
