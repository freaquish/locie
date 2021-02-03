import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/store_view_bloc.dart';
import 'package:locie/components/loading_container/work_container.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/review.dart';
import 'package:locie/models/store.dart';
import 'package:locie/views/Store_view/about_store.dart';
import 'package:locie/views/Store_view/product.dart';
import 'package:locie/views/Store_view/work.dart';

class StoreViewGlobalStateSingleton {
  StoreViewGlobalStateSingleton._internal();

  static final StoreViewGlobalStateSingleton _instance =
      StoreViewGlobalStateSingleton._internal();

  factory StoreViewGlobalStateSingleton() {
    return _instance;
  }

  List<Listing> _listings;
  List<Review> _reviews;
  PreviousExamples _examples;
  Store _store;

  final int listingLimit = 10;
  final int reviewLimit = 5;

  bool get isListingNull => _listings == null;
  bool get isReviewNull => _reviews == null;
  bool get isStoreNull => _store == null;
  bool get isExamplesNull => _examples == null;
  bool get isNextListingFetchViable =>
      !this.isListingNull &&
      (_listings.length > 0 && _listings.length % listingLimit == 0);
  bool get isNextReviewFetchViable =>
      !this.isReviewNull &&
      (_reviews.length > 0 && _reviews.length % reviewLimit == 0);

  List<Listing> get listings => _listings;
  List<Review> get reviews => _reviews;
  Store get store => _store;
  PreviousExamples get examples => _examples;

  DocumentSnapshot get lastListingSnap =>
      _listings[_listings.length - 1].snapshot;

  DocumentSnapshot get lastReviewSnap => _reviews[_reviews.length - 1].snapshot;

  set listings(List<Listing> lst) => _listings = lst;
  set reviews(List<Review> rvs) => _reviews = rvs;
  set store(Store str) => _store = str;
  set examples(PreviousExamples exmpls) => _examples = exmpls;

  void appendListing(Listing lst) => _listings.add(lst);
  void concatListings(List<Listing> lsts) => _listings += lsts;
  void appendReview(Review rvw) => _reviews.add(rvw);
  void concatReviews(List<Review> rvws) => _reviews += rvws;
}

class StoreViewProvider extends StatelessWidget {
  final StoreViewEvent event;
  final StoreViewBloc bloc;
  StoreViewGlobalStateSingleton singleton;
  StoreViewProvider(this.event, {this.singleton, this.bloc});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider<StoreViewBloc>(
        create: (context) => bloc..add(event),
        child: StoreViewBuilder(
          singleton: singleton,
        ),
      ),
    );
  }
}

class StoreViewBuilder extends StatelessWidget {
  StoreViewGlobalStateSingleton singleton;
  StoreViewBuilder({this.singleton});
  @override
  Widget build(BuildContext context) {
    StoreViewBloc bloc = BlocProvider.of<StoreViewBloc>(context);
    return PrimaryContainer(
      widget: BlocBuilder<StoreViewBloc, StoreViewState>(
        cubit: bloc,
        builder: (context, state) {
          //printstate);
          if (state is LoadingState) {
            return WorkLoadingContainer();
          } else if (state is FetchedStore) {
            singleton.store = state.store;
            return StoreAboutWidget(singleton.store);
          } else if (state is FetchedStoreWorks) {
            singleton.examples = state.examples;
            return StoreWorksWidget(singleton.examples);
          } else if (state is FetchedStoreProducts) {
            return StoreProductWidget(state.listings);
          }
        },
      ),
    );
  }
}
