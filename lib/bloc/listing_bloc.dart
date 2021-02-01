import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/models/category.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/repo/listing_repo.dart';

class ListingState {}

class InitializingState extends ListingState {}

class ShowingListingPage extends ListingState {
  final Listing listing;
  final Category category;
  ShowingListingPage({this.listing, this.category});
}

class ShowingMetaDataPage extends ListingState {
  final Listing listing;
  ShowingMetaDataPage({this.listing});
}

class CreatingListing extends ListingState {}

class CreatedListing extends ListingState {}

class CreationErrorState extends ListingState {}

class ListingEvent {}

// This will be called after category is selected
class InitiateListingCreation extends ListingEvent {
  final Listing listing;
  final Category category;
  InitiateListingCreation(this.category, {this.listing});
}

class ProceedToMetaDataPage extends ListingEvent {
  final Listing listing;
  ProceedToMetaDataPage(this.listing);
}

class CreateListing extends ListingEvent {
  final Listing listing;
  CreateListing(this.listing);
}

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  ListingBloc() : super(InitializingState());
  ListingQuery listingQuery = ListingQuery();
  @override
  Stream<ListingState> mapEventToState(ListingEvent event) async* {
    try {
      if (event is InitiateListingCreation) {
        yield ShowingListingPage(
            category: event.category, listing: event.listing);
      } else if (event is ProceedToMetaDataPage) {
        yield ShowingMetaDataPage(listing: event.listing);
      } else if (event is CreateListing) {
        yield CreatingListing();
        listingQuery.createOrEditListing(event.listing);
        yield CreatedListing();
      }
    } catch (e) {
      yield CreationErrorState();
    }
  }
}
