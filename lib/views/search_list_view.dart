import 'package:flutter/material.dart';
import 'package:locie/components/search/listing_card.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';

class SearchListView extends StatelessWidget {
  final List<Store> stores;
  final List<Listing> listings;
  SearchListView({this.listings, this.stores});

  int getCount() {
    return listings != null ? listings.length : stores.length;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: getCount(),
      itemBuilder: (context, index) {
        if (listings != null) {
          return ListingCard(
            listing: listings[index],
          );
        }
        return StoreCard(
          store: stores[index],
        );
      },
    );
  }
}
