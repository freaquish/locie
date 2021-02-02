import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/review.dart';
import 'package:locie/models/store.dart';
import 'package:locie/repo/store_view_repo.dart';

class StoreViewState {}

class LoadingState extends StoreViewState {}

class FetchedStore extends StoreViewState {
  final Store store;
  FetchedStore(this.store);
}

class FetchingList extends StoreViewState {}

class FetchedStoreProducts extends StoreViewState {
  final List<Listing> listings;
  FetchedStoreProducts(this.listings);
}

class FetchedStoreWorks extends StoreViewState {
  final PreviousExamples examples;
  FetchedStoreWorks(this.examples);
}

class FetchedStoreReviews extends StoreViewState {
  final List<Review> reviews;
  FetchedStoreReviews(this.reviews);
}

class StoreViewEvent {}

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

  @override
  Stream<StoreViewState> mapEventToState(StoreViewEvent event) async* {
    // yield LoadingState();
    if (event is FetchStore) {
      yield LoadingState();
      Store store = await repo.fetchStore(event.sid);
      // print(store);
      yield FetchedStore(store);
    } else if (event is FetchStoreProducts) {
      yield FetchingList();
      List<Listing> listings =
          await repo.fetchStoreListing(event.sid, event.startAt);
      yield FetchedStoreProducts(listings);
    } else if (event is FetchStoreWorks) {
      yield LoadingState();
      PreviousExamples examples = await repo.fetchWorks(event.sid);
      print(examples);
      yield FetchedStoreWorks(examples);
    } else if (event is FetchStoreReviews) {
      yield FetchingList();
      List<Review> reviews = await repo.fetchReviews(event.sid, event.startAt);
      yield FetchedStoreReviews(reviews);
    } else if (event is InjectStoreView) {
      yield event.state;
    }
  }
}
