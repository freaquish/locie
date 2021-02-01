import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locie/helper/firestore_storage.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/minions.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';

class ListingQuery {
  LocalStorage localStorage = LocalStorage();
  FirebaseFirestore instance = FirebaseFirestore.instance;
  CollectionReference listingRef;

  ListingQuery() {
    listingRef = instance.collection("listings");
  }

  /**
   * Create Listing and n_gram of name, store name, and category name
   * Image upload is not compulsory and thus image file will be checked
   * id will be assigned using generateId function from `minions.dart`
   */
  Future<void> createOrEditListing(Listing listing) async {
    // CollectionReference listingRef = instance.collection("listings");
    await localStorage.init();
    Store store = await localStorage.getStore();
    if (listing.imageFile != null) {
      CloudStorage storage = CloudStorage();
      var task = storage.uploadFile(listing.imageFile);
      listing.image = await storage.getDownloadUrl(task);
      listing.imageFile = null;
    }
    listing.store = store.id;
    listing.nGram = nGram(listing.name);
    listing.nGram += nGram(store.name).sublist(3);
    listing.nGram += nGram(listing.parentName).sublist(3);
    if (listing.id == null) {
      var lid = generateId(text: 'item-${listing.name}-${store.name}');
      listing.id = lid;
    }
    listingRef.doc(listing.id).set(listing.toJson());
  }

  Future<void> removeListing(Listing listing) async {
    // CollectionReference listingRef = instance.collection("listings");
    listingRef.doc(listing.id).delete();
  }

  Future<List<Listing>> fetchListings({String sid}) async {
    // CollectionReference listingRef = instance.collection("listings");
    var id;
    if (sid == null) {
      await localStorage.init();
      id = localStorage.prefs.getString("sid");
    } else {
      id = sid;
    }
    QuerySnapshot snapshot =
        await listingRef.where("store", isEqualTo: id).get();
    return snapshot.docs.map((e) => Listing.fromJson(e.data())).toList();
  }
}
