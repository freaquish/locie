import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/listing_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/models/category.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/views/add_item/add_item.dart';
import 'package:locie/views/add_item/item_meta_data.dart';

class ListingOperationViewProvider extends StatelessWidget {
  final Category category;
  final Listing listing;
  const ListingOperationViewProvider({this.category, this.listing});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider<ListingBloc>(
        create: (context) => ListingBloc()
          ..add(InitiateListingCreation(category, listing: listing)),
        child: ListingOperationBuilder(),
      ),
    );
  }
}

class ListingOperationBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ListingBloc bloc = BlocProvider.of<ListingBloc>(context);
    return PrimaryContainer(
      widget: BlocBuilder<ListingBloc, ListingState>(
        cubit: bloc,
        builder: (context, state) {
          if (state is InitializingState) {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ShowingListingPage) {
            return AddItemWidget(
              listing: state.listing,
              category: state.category,
              bloc: bloc,
            );
          } else if (state is ShowingMetaDataPage) {
            return ItemMetaDataWidget(
              listing: state.listing,
              bloc: bloc,
            );
          }
        },
      ),
    );
  }
}
