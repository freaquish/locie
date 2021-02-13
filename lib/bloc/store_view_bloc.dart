import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/category.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/review.dart';
import 'package:locie/models/store.dart';
import 'package:locie/repo/store_view_repo.dart';
import 'package:locie/singleton.dart';

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
  final List<Category> categroies;
  final String sid;
  final String current;

  FetchedStoreProducts(this.listings, this.sid,
      {this.isStoreMine = false, this.categroies = const [], this.current});
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
  final String parent;
  final String current;
  FetchStoreProducts(this.sid, {this.startAt, this.parent, this.current});
}

class JumpToLastProducts extends StoreViewEvent {
  final VoidCallback onEmptyCallback;
  JumpToLastProducts({this.onEmptyCallback});
}

class FetchStoreWorks extends StoreViewEvent {
  final String sid;
  FetchStoreWorks(
    this.sid,
  );
}

class CommonStoreViewError extends StoreViewState {}

class InjectStoreView extends StoreViewEvent {
  final StoreViewState state;
  InjectStoreView(this.state);
}

class FetchStoreReviews extends StoreViewEvent {
  final String sid;
  final DocumentSnapshot startAt;
  FetchStoreReviews(this.sid, {this.startAt});
}

class ComplexProductMap {
  final List<Listing> listings;
  final List<Category> categories;
  final String name;
  ComplexProductMap({this.listings, this.categories, this.name});

  Map<String, dynamic> toJson() {
    return {
      "listings": this.listings,
      "categories": this.categories,
      "name": this.name
    };
  }

  List<Listing> get getListings => listings;
  List<Category> get getCategories => categories;
}

class StoreProductsMap {
  Map<String, ComplexProductMap> _map;
  StoreProductsMap() {
    _map = Map<String, ComplexProductMap>();
  }

  void insert(String key,
      {List<Listing> listings, List<Category> categories, String name}) {
    _map[key] = ComplexProductMap(
        listings: listings, categories: categories, name: name);
  }

  ComplexProductMap get(String key) => _map[key];

  bool containsKey(String key) => _map.containsKey(key);

  bool get isEmpty => _map.isEmpty;
  ComplexProductMap get last => (_map.values.toList())[_map.length - 1];
  String get lastkey => (_map.keys.toList())[_map.length - 1];
  void pop() {
    if (_map.length > 0) {
      String key = (_map.keys.toList())[_map.length - 1];
      _map.remove(key);
    }
  }
}

class StoreViewBloc extends Bloc<StoreViewEvent, StoreViewState> {
  LocalStorage localStorage = LocalStorage();
  StoreViewRepo repo = StoreViewRepo();
  StoreViewGlobalStateSingleton singleton = StoreViewGlobalStateSingleton();
  final int cacheTime = 3;
  Store store;
  Store myStore;
  StoreProductsMap productsMap = StoreProductsMap();

  StoreViewBloc() : super(LoadingState());

  bool storeIsSame(String sid) {
    return myStore != null && sid == myStore.id;
  }

  @override
  Stream<StoreViewState> mapEventToState(StoreViewEvent event) async* {
    try {
      myStore = await localStorage.getStore();
      // store = await localStorage.getStore();
      if (event is FetchStore) {
        // This event will show complete widget
        yield LoadingState();

        // if (store == null) {
        store = await repo.fetchStore(event.sid);
        //print((store.categories);
        //   //print((store.toJson());
        // }

        yield ShowingStoreViewWidget(
            store: store, isEditable: storeIsSame(event.sid));
      } else if (event is FetchStoreProducts) {
        /**
         * Check if event.parent is not null, if it's null then check `default` in not null
         * if null then fetch all categories under `defaults` of store
         * similary check if `key` is present in product maps otherwise proceed to fetch it
         */
        // //print((store.categories);
        yield LoadingState();
        String mapKey = event.parent;
        List<String> parents = [];
        bool isDefault = false;
        if (event.parent == null) {
          mapKey = "default";
          if (store == null) {
            store = await repo.fetchStore(event.sid);
          }
          parents = store.categories;
          isDefault = true;
        } else {
          parents = [event.parent];
        }

        if (!productsMap.containsKey(mapKey)) {
          List<Listing> listings =
              await repo.fetchStoreListing(event.sid, parents);
          List<Category> categories = await repo.fetchStoreCategory(
              sid: event.sid, parents: parents, isDefault: isDefault);
          productsMap.insert(mapKey,
              listings: listings, categories: categories, name: event.current);
        }
        ComplexProductMap products = productsMap.get(mapKey);
        yield FetchedStoreProducts(products.listings, event.sid,
            current: event.current,
            categroies: products.categories,
            isStoreMine: storeIsSame(event.sid));
      } else if (event is JumpToLastProducts) {
        productsMap.pop();
        if (productsMap.isEmpty) {
          event.onEmptyCallback();
        } else {
          String currentKey = productsMap.lastkey;
          ComplexProductMap current = productsMap.get(currentKey);
          this
            ..add(FetchStoreProducts(store.id,
                current: current.name, parent: currentKey));
        }
      } else if (event is FetchStoreWorks) {
        yield LoadingState();
        PreviousExamples examples = await repo.fetchWorks(event.sid);
        //printexamples);
        yield FetchedStoreWorks(examples, isStoreMine: storeIsSame(event.sid));
      } else if (event is FetchStoreReviews) {
        yield FetchingList();
        List<Review> reviews =
            await repo.fetchReviews(event.sid, event.startAt);
        // //print((reviews);
        yield FetchedStoreReviews(reviews, isStoreMine: storeIsSame(event.sid));
      } else if (event is InjectStoreView) {
        yield event.state;
      } else if (event is FetchStoreView) {
        yield LoadingState();
        store = event.store;
        yield FetchedStore(event.store,
            isStoreMine: storeIsSame(event.store.id));
      }
    } catch (e) {
      // throw e;
      yield CommonStoreViewError();
    }
  }
}
