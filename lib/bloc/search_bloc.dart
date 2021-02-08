import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';
import 'package:locie/repo/search_repo.dart';

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

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchLoading());
  SearchRepository repository = SearchRepository();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    try {
      if (event is SearchDefaultStoresForHome) {
        yield SearchLoading();
        List<Store> stores = await repository.fetchTopStoresForHome();
        yield SearchResults(stores: stores);
      } else if (event is SearchItem) {
        yield SearchLoading();
        List<Listing> listings = await repository.searchListing(event.text);
        yield SearchResults(listings: listings);
      } else if (event is SearchStore) {
        yield SearchLoading();
        List<Store> stores = await repository.searchStore(event.text);
        yield SearchResults(stores: stores);
      }
    } catch (e) {
      print(e);
      yield CommonSearchError();
    }
  }
}
