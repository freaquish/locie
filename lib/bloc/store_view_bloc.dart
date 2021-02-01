import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/review.dart';
import 'package:locie/models/store.dart';

class StoreViewState {}

class LoadingState extends StoreViewState {}

class FetchedStore extends StoreViewState {
  final Store store;
  FetchedStore(this.store);
}

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
  final int startAt;
  FetchStoreProducts(this.sid, {this.startAt = 0});
}

class FetchStoreWorks extends StoreViewEvent {
  final String sid;
  final int startAt;
  FetchStoreWorks(this.sid, {this.startAt = 0});
}

class FetchStoreReviews extends StoreViewEvent {
  final String sid;
  final int startAt;
  FetchStoreReviews(this.sid, {this.startAt = 0});
}

class StoreViewBloc extends Bloc<StoreViewEvent, StoreViewState> {
  StoreViewBloc() : super(LoadingState());

  @override
  Stream<StoreViewState> mapEventToState(StoreViewEvent event) async* {
    yield LoadingState();
  }
}
