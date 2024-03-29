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

class CommonListingError extends ListingState {}

class CreatingListing extends ListingState {}

class ShowingMyListings extends ListingState {
  final List<Listing> listings;
  ShowingMyListings(this.listings);
}

class ShowingStoreListings extends ListingState {
  final String sid;
  final List<Listing> listings;
  ShowingStoreListings({this.sid, this.listings});
}

class DeletedItem extends ListingState {}

class CreatedListing extends ListingState {}

class CreationErrorState extends ListingState {}

class ListingEvent {}

// This will be called after category is selected
class InitiateListingCreation extends ListingEvent {
  final Listing listing;
  final Category category;
  InitiateListingCreation({this.category, this.listing});
}

class InitiateListingUpdate extends ListingEvent {
  final Listing listing;
  InitiateListingUpdate(this.listing);
}

class ProceedToMetaDataPage extends ListingEvent {
  final Listing listing;
  ProceedToMetaDataPage(this.listing);
}

class CreateListing extends ListingEvent {
  final Listing listing;
  CreateListing(this.listing);
}

class FetchItems extends ListingEvent {
  final String sid;
  FetchItems({this.sid});
}

class DeleteItem extends ListingEvent {
  final String sid;
  DeleteItem(this.sid);
}

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  ListingBloc() : super(InitializingState());
  ListingQuery listingQuery = ListingQuery();
  @override
  Stream<ListingState> mapEventToState(ListingEvent event) async* {
    try {
      if (event is InitiateListingCreation) {
        // //(event.listing.priceMax);
        yield ShowingListingPage(
            category: event.category, listing: event.listing);
      } else if (event is ProceedToMetaDataPage) {
        yield ShowingMetaDataPage(listing: event.listing);
      } else if (event is CreateListing) {
        yield CreatingListing();
        listingQuery.createOrEditListing(event.listing);
        yield CreatedListing();
      } else if (event is FetchItems) {
        List<Listing> listings =
            await listingQuery.fetchListings(sid: event.sid);
        // //printlistings);
        if (event.sid == null) {
          yield ShowingMyListings(listings);
        } else {
          yield ShowingStoreListings(sid: event.sid, listings: listings);
        }
      } else if (event is InitiateListingUpdate) {
        yield ShowingListingPage(listing: event.listing);
      } else if (event is DeleteItem) {
        yield InitializingState();
        await listingQuery.deleteItem(event.sid);
        yield DeletedItem();
      }
    } catch (e) {
      // //printe);
      yield CreationErrorState();
    }
  }
}
