import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locie/helper/firestore_storage.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/minions.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';

class ListingQuery {
  LocalStorage localStorage = LocalStorage();
  FirebaseFirestore instance = FirebaseFirestore.instance;

  /**
   * Create Listing and n_gram of name, store name, and category name
   * Image upload is not compulsory and thus image file will be checked
   * id will be assigned using generateId function from `minions.dart`
   */
  Future<void> createOrEditListing(Listing listing) async {
    CollectionReference listingRef = instance.collection("listings");
    await localStorage.init();
    Store store = await localStorage.getStore();

    if (listing.imageFile != null) {
      CloudStorage storage = CloudStorage();
      var task = storage.uploadFile(listing.imageFile);
      listing.image = await storage.getDownloadUrl(task);
      listing.imageFile = null;
    }
    listing.nGram = nGram(listing.name);
    listing.nGram += nGram(store.name);
    listing.nGram += nGram(listing.parentName);
    if (listing.id == null) {
      var lid = generateId(text: 'item-${listing.name}-${store.name}');
      listing.id = lid;
    }
    listingRef.doc(listing.id).set(listing.toJson());
  }
}
