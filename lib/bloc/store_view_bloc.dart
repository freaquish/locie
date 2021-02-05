import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/review.dart';
import 'package:locie/models/store.dart';
import 'package:locie/repo/store_view_repo.dart';
import 'package:locie/singleton.dart';
import 'package:locie/views/Store_view/product_view.dart';

class StoreViewState {}

class LoadingState extends StoreViewState {}

class FetchedStore extends StoreViewState {
  final Store store;
  final bool isStoreMine;
  FetchedStore(this.store, {this.isStoreMine = false});
}

class FetchingList extends StoreViewState {}

class FetchedStoreProducts extends StoreViewState {
  final List<Listing> listings;
  final bool isStoreMine;
  FetchedStoreProducts(this.listings, {this.isStoreMine = false});
}

class ShowingStoreViewWidget extends StoreViewState {
  final Store store;
  final bool isEditable;
  ShowingStoreViewWidget({this.store, this.isEditable});
}

class FetchedStoreWorks extends StoreViewState {
  final PreviousExamples examples;
  final bool isStoreMine;
  FetchedStoreWorks(this.examples, {this.isStoreMine = false});
}

class FetchedStoreReviews extends StoreViewState {
  final List<Review> reviews;
  final bool isStoreMine;
  FetchedStoreReviews(this.reviews, {this.isStoreMine = false});
}

class NotItemFoundInStore extends StoreViewState {}

class StoreViewEvent {}

class FetchStoreView extends StoreViewEvent {
  final Store store;
  FetchStoreView(this.store);
}

class FetchStore extends StoreViewEvent {
  final String sid;
  FetchStore(this.sid);
}

class FetchStoreProducts extends StoreViewEvent {
  final String sid;
  final DocumentSnapshot startAt;
  FetchStoreProducts(this.sid, {this.startAt});
}

class FetchStoreWorks extends StoreViewEvent {
  final String sid;
  FetchStoreWorks(
    this.sid,
  );
}

class InjectStoreView extends StoreViewEvent {
  final StoreViewState state;
  InjectStoreView(this.state);
}

class FetchStoreReviews extends StoreViewEvent {
  final String sid;
  final DocumentSnapshot startAt;
  FetchStoreReviews(this.sid, {this.startAt});
}

class StoreViewBloc extends Bloc<StoreViewEvent, StoreViewState> {
  StoreViewBloc() : super(LoadingState());
  LocalStorage localStorage = LocalStorage();
  StoreViewRepo repo = StoreViewRepo();
  StoreViewGlobalStateSingleton singleton = StoreViewGlobalStateSingleton();
  final int cacheTime = 3;
  Store store;

  bool storeIsSame(String sid) {
    return store != null && sid == store.id;
  }

  @override
  Stream<StoreViewState> mapEventToState(StoreViewEvent event) async* {
    // yield LoadingState();
    // await localStorage.init();
    store = await localStorage.getStore();
    if (event is FetchStore) {
      // This event will show complete widget
      yield LoadingState();
      Store store;
      store = await repo.fetchStore(event.sid);

      yield ShowingStoreViewWidget(
          store: store, isEditable: storeIsSame(event.sid));
    } else if (event is FetchStoreProducts) {
      yield LoadingState();
      List<Listing> listings =
          await repo.fetchStoreListing(event.sid, event.startAt);
      yield FetchedStoreProducts(listings, isStoreMine: storeIsSame(event.sid));
    } else if (event is FetchStoreWorks) {
      yield LoadingState();
      PreviousExamples examples = await repo.fetchWorks(event.sid);
      //printexamples);
      yield FetchedStoreWorks(examples, isStoreMine: storeIsSame(event.sid));
    } else if (event is FetchStoreReviews) {
      yield FetchingList();
      List<Review> reviews = await repo.fetchReviews(event.sid, event.startAt);
      yield FetchedStoreReviews(reviews, isStoreMine: storeIsSame(event.sid));
    } else if (event is InjectStoreView) {
      yield event.state;
    } else if (event is FetchStoreView) {
      yield LoadingState();
      yield FetchedStore(event.store, isStoreMine: storeIsSame(event.store.id));
    }
  }
}
