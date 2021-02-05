import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';

class SearchRepository {
  LocalStorage localStorage;
  FirebaseFirestore instance;
  CollectionReference storeRef, listingRef;

  SearchRepository() {
    localStorage = LocalStorage();
    instance = FirebaseFirestore.instance;
    storeRef = instance.collection("stores");
    listingRef = instance.collection("listings");
  }

  /// Fetch top rated stores from database and timestamp
  Future<List<Store>> _fetchTopStoresForHome() async {
    QuerySnapshot snapshots = await storeRef
        .orderBy("rating", descending: true)
        .orderBy("created", descending: true)
        .orderBy("no_of_reviews", descending: false)
        .limit(5)
        .get();
    return snapshots.docs.map((e) => Store.fromJson(e.data())).toList();
  }

  Future<List<Store>> fetchTopStoresForHome() async {
    bool frozenStoresViable = await this.isStoresForHomeFrozen();
    if (frozenStoresViable) {
      return await localStorage.unFreezeStoresForHome();
    }
    List<Store> stores = await _fetchTopStoresForHome();
    await localStorage.freezeStoresForHome(stores);
    return stores;
  }

  Future<bool> isStoresForHomeFrozen() async {
    await localStorage.init();
    return localStorage.frozenStoresViable();
  }

  Future<List<Listing>> searchListing(String text,
      [DocumentSnapshot startAt]) async {
    Query query = listingRef.where("n_gram", arrayContainsAny: [
      text.toLowerCase().split(" ").join("")
    ]).orderBy("created", descending: true);
    if (startAt != null) {
      query = query.startAfterDocument(startAt);
    }
    QuerySnapshot snapshots = await query.get();
    return snapshots.docs.map((e) => Listing.fromJson(e.data())).toList();
  }

  Future<List<Store>> searchStore(String text) async {
    QuerySnapshot snapshots = await instance
        .collection("stores")
        .where("n_gram",
            arrayContainsAny: [text.toLowerCase().split(" ").join("")])
        .orderBy("rating", descending: true)
        .orderBy("no_of_reviews", descending: false)
        .get();
    return snapshots.docs.map((e) => Store.fromJson(e.data())).toList();
  }
}
