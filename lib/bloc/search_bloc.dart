import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';
import 'package:locie/repo/search_repo.dart';
import 'package:locie/singleton.dart';

class SearchState {}

class SearchLoading extends SearchState {}

class CommonSearchError extends SearchState {}

class SearchResults extends SearchState {
  final List<Store> stores;
  final List<Listing> listings;
  SearchResults({this.listings, this.stores});
}

class SearchEvent {}

class SearchDefaultStoresForHome extends SearchEvent {}

class SearchItem extends SearchEvent {
  final String text;
  SearchItem(this.text);
}

class SearchStore extends SearchEvent {
  final String text;
  SearchStore(this.text);
}

class ShowSearchResults extends SearchEvent {
  final List<Store> stores;
  final List<Listing> listings;
  ShowSearchResults({this.listings, this.stores});
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchLoading());
  SearchRepository repository = SearchRepository();
  StoreViewGlobalStateSingleton singleton = StoreViewGlobalStateSingleton();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    try {
      if (event is SearchDefaultStoresForHome) {
        yield SearchLoading();
        if ((singleton.searchedString != null &&
                singleton.searchedString.length > 0) &&
            (singleton.searchedListings != null ||
                singleton.searchedStores != null)) {
          // yield SearchResults(
          //     listings: singleton.searchedListings,
          //     stores: singleton.searchedStores);
          this
            ..add(ShowSearchResults(
                listings: singleton.searchedListings,
                stores: singleton.searchedStores));
        } else {
          List<Store> stores = await repository.fetchTopStoresForHome();
          singleton.searchedStores = stores;
          yield SearchResults(stores: singleton.searchedStores);
        }
      } else if (event is SearchItem) {
        yield SearchLoading();
        if (event.text.length > 0) {
          List<Listing> listings = await repository.searchListing(event.text);
          singleton.searchedListings = listings;
        }
        // yield SearchResults(listings: singleton.searchedListings);
        this..add(ShowSearchResults(listings: singleton.searchedListings));
      } else if (event is SearchStore) {
        yield SearchLoading();
        if (event.text.length > 0) {
          List<Store> stores = await repository.searchStore(event.text);
          singleton.searchedStores = stores;
        }
        // yield SearchResults(stores: singleton.searchedStores);
        this..add(ShowSearchResults(stores: singleton.searchedStores));
      } else if (event is ShowSearchResults) {
        if ((event.stores == null || event.stores.isEmpty) &&
            (event.listings == null || event.listings.isEmpty)) {
          this..add(SearchDefaultStoresForHome());
        } else {
          yield SearchResults(stores: event.stores, listings: event.listings);
        }
      }
    } catch (e) {
      yield CommonSearchError();
    }
  }
}
