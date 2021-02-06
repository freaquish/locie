import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/listing_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/models/category.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/views/add_item/add_item.dart';
import 'package:locie/views/add_item/item_meta_data.dart';
import 'package:locie/views/error_widget.dart';
import 'package:locie/views/my_store/my_items.dart';

class ListingOperationViewProvider extends StatelessWidget {
  final Category category;
  final Listing listing;
  final ListingEvent event;
  final Function onComplete;
  const ListingOperationViewProvider(
      {this.category, this.listing, this.event, this.onComplete});
  @override
  Widget build(BuildContext context) {
    ListingEvent initialEvent = event == null
        ? InitiateListingCreation(category: category, listing: listing)
        : event;
    return Container(
      child: BlocProvider<ListingBloc>(
        create: (context) => ListingBloc()..add(initialEvent),
        child: ListingOperationBuilder(
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class ListingOperationBuilder extends StatelessWidget {
  final Function onComplete;
  ListingOperationBuilder({this.onComplete});
  @override
  Widget build(BuildContext context) {
    ListingBloc bloc = BlocProvider.of<ListingBloc>(context);
    return PrimaryContainer(
      widget: BlocBuilder<ListingBloc, ListingState>(
        cubit: bloc,
        builder: (context, state) {
          print(state);
          if (state is InitializingState || state is CreatingListing) {
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
          } else if (state is ShowingMyListings) {
            return MyListingsWidget(
              bloc: bloc,
              listings: state.listings,
            );
          } else if (state is CreatedListing) {
            NavigationBloc bloc = BlocProvider.of<NavigationBloc>(context);
            if (bloc.route.isEmpty) {
              bloc.push(NavigateToHome());
            } else {
              bloc.pop();
            }
            return Container();
          } else if (state is DeletedItem) {
            if (onComplete != null) {
              onComplete();
            }
            return Container();
          } else if (state is CreationErrorState) {
            return ErrorScreen();
          }
        },
      ),
    );
  }
}
