import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/minions.dart';
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
  Future<List<Listing>> fetchStoreListing(String sid,
      [DocumentSnapshot documentSnapshot]) async {
    int limit = 10;
    QuerySnapshot snapshot;
    Query query;
    query = instance
        .collection("listings")
        .where("store", isEqualTo: sid)
        .orderBy("created", descending: true);
    if (documentSnapshot != null) {
      query = query.startAfterDocument(documentSnapshot);
    }
    snapshot = await query.limit(limit).get();
    return snapshot.docs.map((e) {
      Listing listing = Listing.fromJson(e.data());
      listing.snapshot = e;
      return listing;
    }).toList();
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

  Future<List<Review>> fetchReviews(String sid,
      [DocumentSnapshot documentSnapshot]) async {
    int limit = 5;
    Query query = instance
        .collection("reviews")
        .where("store", isEqualTo: sid)
        .orderBy("rating", descending: true);
    if (documentSnapshot != null) {
      query = query.startAfterDocument(documentSnapshot);
    }
    QuerySnapshot snapshot = await query.limit(limit).get();
    return snapshot.docs.map((e) {
      Review review = Review.fromJson(e.data());
      review.snapshot = e;
      return review;
    }).toList();
  }

  Future<Listing> fetchItem(String lid) async {
    // //(lid);
    DocumentSnapshot snapshot =
        await instance.collection("listings").doc(lid).get();
    if (!snapshot.exists) {
      return null;
    }
    return Listing.fromJson(snapshot.data());
  }

  Future<void> createReview(Review review) async {
    String reviewId = generateId(
        text: review.store +
            "_" +
            DateTime.now().microsecondsSinceEpoch.toString());
    review.id = reviewId;
    await instance.collection("reviews").doc(reviewId).set(review.toJson());
    await instance.collection("stores").doc(review.store).update({
      "rating": FieldValue.increment(review.rating),
      "no_of_reviews": FieldValue.increment(1)
    });
  }
}
