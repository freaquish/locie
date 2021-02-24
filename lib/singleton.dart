import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/review.dart';
import 'package:locie/models/store.dart';

class StoreCache<T> {
  final T cache;
  final DateTime time;
  StoreCache({this.cache, this.time});
}

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

  List<Listing> searchedListings;
  List<Store> searchedStores;
  String searchedString;

  Map<String, StoreCache<Store>> storeCache = {};
  Map<String, StoreCache<PreviousExamples>> worksCache = {};

  void clear() {
    _listings = [];
    _reviews = [];
    _examples = null;
    _store = null;
  }

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
  void joinReview(Review rvw) {
    _reviews = [rvw] + _reviews;
  }

  void concatReviews(List<Review> rvws) => _reviews += rvws;
}
