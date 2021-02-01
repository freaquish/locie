import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/review.dart';
import 'package:locie/models/store.dart';

class StoreViewRepo {
  FirebaseFirestore instance;
  LocalStorage localStorage;

  StoreViewRepo() {
    instance = FirebaseFirestore.instance;
    localStorage = LocalStorage();
  }

  //Returns store with null id if none exist
  Future<Store> fetchStore(String sid) async {
    QuerySnapshot snapshot =
        await instance.collection("stores").where("id", isEqualTo: sid).get();
    List<Store> stores =
        snapshot.docs.map((e) => Store.fromJson(e.data())).toList();
    if (stores.isNotEmpty) {
      return stores[0];
    } else {
      return Store();
    }
  }

  // Returns PE with null sid if none exists
  Future<List<Listing>> fetchStoreListing(String sid) async {
    QuerySnapshot snapshot = await instance
        .collection("listings")
        .where("store", isEqualTo: sid)
        .get();
    return snapshot.docs.map((e) => Listing.fromJson(e.data())).toList();
  }

  Future<PreviousExamples> fetchWorks(String sid) async {
    QuerySnapshot snapshot =
        await instance.collection("works").where("sid", isEqualTo: sid).get();
    List<PreviousExamples> examples =
        snapshot.docs.map((e) => PreviousExamples.fromJson(e.data())).toList();
    if (examples.length > 0) {
      return examples[0];
    } else {
      return PreviousExamples();
    }
  }

  Future<List<Review>> fetchReviews(String sid) async {
    QuerySnapshot snapshot = await instance
        .collection("reviews")
        .where("store", isEqualTo: sid)
        .get();
    return snapshot.docs.map((e) => Review.fromJson(e.data())).toList();
  }
}
