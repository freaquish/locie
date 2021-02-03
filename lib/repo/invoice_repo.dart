import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locie/helper/firestore_storage.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/invoice.dart';
import 'package:locie/models/store.dart';

import 'package:pdf/pdf.dart';

class InvoiceRepo {
  FirebaseFirestore instance;
  LocalStorage localStorage;
  CollectionReference ref;
  CloudStorage cloudStorage;

  InvoiceRepo() {
    localStorage = LocalStorage();
    instance = FirebaseFirestore.instance;
    cloudStorage = CloudStorage();
    ref = instance.collection("invoices");
  }

  Future<void> addLogo(File image) async {
    CollectionReference storeRef = instance.collection("stores");
    await localStorage.init();
    var sid = localStorage.prefs.getString("sid");
    var task = cloudStorage.uploadFile(image);
    String url = await cloudStorage.getDownloadUrl(task);
    storeRef.doc(sid).update({"logo": url});
    localStorage.prefs.setString("store_logo", url);
  }

  String timeId(DateTime time) {
    return time.microsecondsSinceEpoch.toString();
  }

  Future<void> createInvoice(Invoice invoice) async {
    await localStorage.init();
    Store store = await localStorage.getStore();
    var now = DateTime.now();
    invoice.generator = store.id;
    invoice.generatorName = store.name;
    invoice.generatorPhoneNumber = store.contact;
    invoice.id = store.name + "_" + timeId(now);
    invoice.timestamp = now;
    invoice.meta = Meta(
        address: store.address.toString(),
        logo: store.logo,
        contact: store.contact,
        gstin: store.gstin);
    Map<String, dynamic> json = invoice.toJson();
    await instance.collection("invoices").doc(invoice.id).set(json);
  }

  Future<Account> searchAccount(String phoneNumber) async {
    QuerySnapshot snapshot = await instance
        .collection("accounts")
        .where("phone_number", isEqualTo: phoneNumber)
        .get();
    // print(snapshot.docs.length);
    if (snapshot.docs.length == 0) {
      return null;
    }
    List<Account> accountSnaps =
        snapshot.docs.map((e) => Account.fromJson(e.data())).toList();
    // print(accountSnaps);
    return accountSnaps[0];
  }
}
