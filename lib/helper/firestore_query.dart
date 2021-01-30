import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:locie/helper/firestore_storage.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/minions.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/category.dart';
import 'package:locie/models/store.dart';
import 'package:locie/models/unit.dart';

abstract class AbstractFireStoreQuery {
  FirebaseFirestore firestore;

  // Feeds data such as owner, contacts and creates store on the server
  Future<Store> createStore(Store store, Account user);

  // Edits the store which is different from preferences in the android
  Future<Store> editStore(Store newStore);

  // Adds Defaukt Category to stores categories
  // called in createNewCategory and createItem,
  // only if store.categories does not contains category and category.isDefault
  Future<void> addDefaultCategoryToStore(Store store, Category category);

  // Fetches category from server, if current is null then fetch all default categories
  // else fetch all categories with parent == current &&  store == store
  // else if categories is not null then fetch all the categories with the given id
  Future<List<Category>> fetchCategories(
      {String current, String store, List<String> categories});

  // Creates the new category on server and returns the category for later use cases
  Future<Category> createNewCategory(Category category);

  // Fetches all the units from the server
  Future<List<Unit>> fetchUnits();

  // Fetch PreviousExamples of given store id
  Future<PreviousExamples> getExamples(String sid);

  // Add previous example to store
  Future<PreviousExample> insertExamples({String sid, PreviousExample example});
  // Remove previous example from stores previous eexample
  Future<void> removeExample({String sid, PreviousExample example});
}

class FireStoreQuery implements AbstractFireStoreQuery {
  @override
  FirebaseFirestore firestore;
  CloudStorage storage;

  FireStoreQuery() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> securityCheck() async {
    Firebase.initializeApp();
  }

  Future<DocumentSnapshot> getAccountSnapshot({User user, String uid}) async {
    var docId = user == null ? uid : user.uid;
    var queryResult = await firestore.collection('accounts').doc(docId).get();
    return queryResult;
  }

  bool accountExist(DocumentSnapshot snap) {
    return snap.exists;
  }

  @override
  Future<void> addDefaultCategoryToStore(Store store, Category category) {
    // TODO: implement addDefaultCategoryToStore
    throw UnimplementedError();
  }

  @override
  Future<Category> createNewCategory(Category category) {
    // TODO: implement createNewCategory
    throw UnimplementedError();
  }

  /*
   * Create Store function takes store and user as inout and 
   * creates store after uploading image and feeding all the requried data
   */

  @override
  Future<Store> createStore(Store store, Account user) async {
    store.owner = user.uid;

    store.contact = user.phoneNumber;
    store.created = DateTime.now();
    if (storage == null) {
      storage = CloudStorage();
    }
    var task = storage.uploadFile(store.imageFile);
    store.image = await storage.getDownloadUrl(task);
    store.imageFile = null;
    try {
      var location = await determinePosition();
      store.location =
          StoreLocation(lat: location.latitude, long: location.altitude);
    } catch (e) {}
    store.id = generateId(text: 'store_${user.phoneNumber}');
    CollectionReference storeReference = firestore.collection('stores');
    storeReference.doc(store.id).set(store.toJson());
    firestore
        .collection('accounts')
        .doc(user.uid)
        .update({"is_store_owner": true});
    user.isStoreOwner = true;
    LocalStorage localStorage = LocalStorage();
    localStorage.setStore(store);
    localStorage.setAccount(user);
    return store;
  }
  /**
   * This Function will handle these cases of query
   * 1. when current is provided and has to search all categories within and store
   * 2. categories is provided it will fetch categories in the list
   * 3. otherwise return null
   */

  @override
  Future<List<Category>> fetchCategories(
      {String current, String store, List<String> categories}) async {
    CollectionReference ref = firestore.collection('category');
    QuerySnapshot snapshot;
    if (current != null && store != null) {
      snapshot = await ref
          .where("parent", isEqualTo: current)
          .where("store", isEqualTo: store)
          .get();
    } else if (categories != null && categories.isNotEmpty) {
      snapshot = await ref.where("id", whereIn: categories).get();
    } else {
      snapshot = await ref.where("is_default", isEqualTo: true).get();
    }
    var docs = snapshot.docs;
    return docs.map((e) => Category.fromJson(e.data()));
  }

  @override
  Future<List<Unit>> fetchUnits() async {
    CollectionReference ref = firestore.collection('unit');
    var snapshot = await ref.get();
    return snapshot.docs.map((e) => Unit.fromJson(e.data()));
  }

  @override
  Future<PreviousExample> insertExamples(
      {String sid, PreviousExample example}) async {
    CollectionReference exampleReference =
        firestore.collection('previous_examples');
    exampleReference.doc(sid).update({
      "examples": FieldValue.arrayUnion([example.toJson()])
    });
    LocalStorage storage = LocalStorage();
    return example;
  }

  @override
  Future<Store> editStore(Store newStore) async {
    LocalStorage localStorage = LocalStorage();
    Store stateStore = await localStorage.getStore();
    Map<String, dynamic> changes = stateStore.compare(newStore);
    CollectionReference storeReference = firestore.collection('stores');
    storeReference.doc(stateStore.id).update(changes);
    localStorage.setStore(newStore);
    return newStore;
  }

  @override
  Future<PreviousExamples> getExamples(String sid) async {
    CollectionReference exampleReference =
        firestore.collection('previous_exmaples');
    DocumentSnapshot snapshot = await exampleReference.doc(sid).get();
    return PreviousExamples.fromJson(snapshot.data());
  }

  @override
  Future<void> removeExample({String sid, PreviousExample example}) async {
    CollectionReference exampleReference =
        firestore.collection('previous_exmaples');
    exampleReference.doc(sid).update({
      "examples": FieldValue.arrayRemove([example.toJson()])
    });
  }
}
