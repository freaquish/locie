import 'dart:convert';

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
  LocalStorage localStorage = LocalStorage();

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
  Future<void> addDefaultCategoryToStore(Store store, Category category) async {
    CollectionReference storeReference = firestore.collection("stores");
    var nGrams = nGram(category.name);
    await storeReference.doc(store.id).update({
      "categories": FieldValue.arrayUnion([category.id]),
      "n_gram": FieldValue.arrayUnion(nGrams)
    });
  }

  @override
  Future<Category> createNewCategory(Category category) async {
    if (category.imageFile != null) {
      CloudStorage storage = CloudStorage();
      var task = storage.uploadFile(category.imageFile);
      category.image = await storage.getDownloadUrl(task);
      category.imageFile = null;
    }
    CollectionReference categoryReference = firestore.collection('category');
    // var localstorage = LocalStorage();
    await localStorage.init();
    Store store = await localStorage.getStore();
    var cid = generateId(text: 'category-${category.name}-${store.name}');
    category.id = cid;
    var json = category.toJson();
    json["n_gram"] = nGram(category.name);
    await categoryReference.doc(cid).set(json);
    await firestore.collection('stores').doc(store.id).update({
      "n_gram": FieldValue.arrayUnion(trigramNGram(category.name)),
      "categories": FieldValue.arrayUnion([category.defaultParent])
    });

    return category;
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
    if (store.imageFile != null) {
      var task = storage.uploadFile(store.imageFile);
      store.image = await storage.getDownloadUrl(task);
      store.imageFile = null;
    }
    try {
      var location = await determinePosition();
      store.location =
          StoreLocation(lat: location.latitude, long: location.altitude);
    } catch (e) {}
    store.id = generateId(text: 'store_${user.phoneNumber}');
    CollectionReference storeReference = firestore.collection('stores');
    Map<String, dynamic> json = store.toJson();
    json['n_gram'] = nGram(store.name).sublist(2);

    storeReference.doc(store.id).set(json);
    firestore
        .collection('accounts')
        .doc(user.uid)
        .update({"is_store_owner": true});
    firestore
        .collection("works")
        .doc(store.id)
        .set({"sid": store.id, "examples": []});
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
      ////'1 ${current != null && store != null}');
      snapshot = await ref
          .where("parent", isEqualTo: current)
          .where("store", isEqualTo: store)
          .get();
    } else if (categories != null && categories.isNotEmpty) {
      ////'21 ${categories != null && categories.isNotEmpty}');
      snapshot = await ref.where("id", whereIn: categories).get();
    } else {
      ////'3');
      snapshot = await ref.where("is_default", isEqualTo: true).get();
    }
    var docs = snapshot.docs;
    docs.forEach((element) {
      //printelement.data());
    });
    return docs.map((e) => Category.fromJson(e.data())).toList();
  }

  @override
  Future<List<Unit>> fetchUnits() async {
    if (localStorage == null) {
      localStorage = LocalStorage();
      await localStorage.init();
    }
    if (localStorage.prefs.containsKey("last_unit_fetch") &&
        DateTime.now()
                .difference(DateTime.parse(
                    localStorage.prefs.getString("last_unit_fetch")))
                .inDays <=
            1) {
      var decoded = jsonDecode(localStorage.prefs.getString("units")) as List;
      return decoded.map((e) => Unit.fromJson(e)).toList();
    } else {
      CollectionReference ref = firestore.collection('units');
      var snapshot = await ref.get();
      List<QueryDocumentSnapshot> snaps = snapshot.docs;
      localStorage.prefs
          .setString("units", jsonEncode(snaps.map((e) => e.data()).toList()));
      localStorage.prefs
          .setString("last_unit_fetch", DateTime.now().toIso8601String());
      return snaps.map((e) {
        return Unit.fromJson(e.data());
      }).toList();
    }
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
    // LocalStorage localStorage = LocalStorage();
    Store stateStore = await localStorage.getStore();
    if (newStore.nGram != null && !newStore.nGram.contains(newStore.name)) {
      List<String> oldNameNgram = nGram(stateStore.name);
      List<String> newNGram =
          newStore.nGram == null ? stateStore.nGram : newStore.nGram;
      oldNameNgram.forEach((element) {
        newNGram.remove(element);
      });
      newNGram += nGram(newStore.name);
    }
    Map<String, dynamic> changes = stateStore.compare(newStore);
    CollectionReference storeReference = firestore.collection('stores');
    if (newStore.name != stateStore.name) {
      changes['n_gram'] = FieldValue.arrayUnion(nGram(newStore.name));
    }
    await storeReference.doc(stateStore.id).update(changes);
    await localStorage.setStore(newStore);
    if (stateStore.name != newStore.name) {
      WriteBatch batch = firestore.batch();
      QuerySnapshot listingSnapshots = await firestore
          .collection("listings")
          .where("store", isEqualTo: newStore.id)
          .get();
      listingSnapshots.docs.forEach((element) {
        batch.update(element.reference, {
          "n_gram": FieldValue.arrayUnion(trigramNGram(newStore.name)),
          "store_name": newStore.name
        });
      });
      batch.commit();
    }
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

  Future<Store> fetchStore(String uid) async {
    QuerySnapshot snapshots = await firestore
        .collection("stores")
        .where("owner", isEqualTo: uid)
        .get();
    if (snapshots.docs.isEmpty) {
      return null;
    }
    return snapshots.docs.map((e) => Store.fromJson(e.data())).toList()[0];
  }

  Future<Account> fetchSystemAccount(String uid) async {
    DocumentSnapshot snapshot =
        await firestore.collection("accounts").doc(uid).get();
    if (!snapshot.exists) {
      return null;
    }
    return Account.fromJson(snapshot.data());
  }
}
