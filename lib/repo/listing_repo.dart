import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locie/helper/firestore_storage.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/minions.dart';
import 'package:locie/helper/notification.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/quotations.dart';
import 'package:locie/models/store.dart';

class ListingQuery {
  LocalStorage localStorage = LocalStorage();
  FirebaseFirestore instance = FirebaseFirestore.instance;
  CollectionReference listingRef;
  final SendNotification notification = SendNotification();

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
    //(listing.imageFile);
    await localStorage.init();
    Store store = await localStorage.getStore();
    if (listing.imageFile != null) {
      CloudStorage storage = CloudStorage();
      var task = storage.uploadFile(listing.imageFile);
      listing.image = await storage.getDownloadUrl(task);
      listing.imageFile = null;
    }
    listing.store = store.id;
    listing.storeName = store.name;
    listing.nGram = nGram(listing.name);
    listing.nGram += trigramNGram(store.name);
    //
    if (listing.id == null) {
      var lid = generateId(text: 'item-${listing.name}-${store.name}');
      listing.id = lid;
      listing.nGram += trigramNGram(listing.parentName);
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

  Future<void> createQuotation(Quotation quotation) async {
    quotation.id = generateId(
        text: quotation.storeName +
            DateTime.now().microsecondsSinceEpoch.toString());
    Account account = await localStorage.getAccount();
    quotation.user = account.uid;
    quotation.userName = account.name;
    quotation.userContact = account.phoneNumber;
    await instance
        .collection("quotations")
        .doc(quotation.id)
        .set(quotation.toJson());
    DocumentSnapshot snapshot =
        await instance.collection("stores").doc(quotation.store).get();
    if (snapshot.exists) {
      Store store = Store.fromJson(snapshot.data());
      dynamic token = await notification.getToken(userId: store.owner);
      await notification.sendNotification(
        sender: quotation.user,
        message:
            '${quotation.userName} sent you Enquiry for product ${quotation.listingName}',
        tokens: token,
        notificationTitle: 'Enquiry',
        notificationType: 'Quotation',
      );
    }
    // ait
  }

  Future<List<Quotation>> fetchQuotations({bool sent = false}) async {
    CollectionReference ref = instance.collection("quotations");
    Query query;
    if (sent) {
      Store store = await localStorage.getStore();
      query = ref.where("store", isEqualTo: store.id);
    } else {
      Account account = await localStorage.getAccount();
      query = ref.where("user", isEqualTo: account.uid);
    }
    QuerySnapshot snapshots = await query.get();
    return snapshots.docs.map((e) => Quotation.fromJson(e.data())).toList();
  }

  Future<void> deleteItem(String sid) async {
    await instance.collection("listings").doc(sid).delete();
  }
}
