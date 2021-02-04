import 'dart:convert';

import 'package:locie/models/account.dart';
import 'package:locie/models/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  SharedPreferences prefs;
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  LocalStorage() {
    this.init();
  }

  Future<void> freezeStoresForHome(List<Store> stores) async {
    if (prefs == null) {
      await init();
    }
    prefs.setString(
        "stores_for_home", jsonEncode(stores.map((e) => e.toJson()).toList()));
    prefs.setString("last_stores_fetch", DateTime.now().toIso8601String());
  }

  Future<bool> frozenStoresViable() async {
    return prefs.containsKey("stores_for_home") &&
        DateTime.now()
                .difference(
                    DateTime.parse(prefs.getString("last_stores_fetch")))
                .inDays <=
            1;
  }

  Future<List<Store>> unFreezeStoresForHome() async {
    return (jsonDecode(prefs.getString("stores_for_home"))
        .map((e) => Store.fromJson(e))).toList();
  }

  Future<void> setAccount(Account account) async {
    if (prefs == null) {
      await this.init();
    }
    prefs.setString("uid", account.uid);
    prefs.setString("avatar", account.avatar);
    prefs.setString("name", account.name);
    prefs.setBool("is_store_owner", account.isStoreOwner);
    prefs.setString("phone_number", account.phoneNumber);
  }

  Future<Account> getAccount() async {
    if (prefs == null) {
      await this.init();
    }
    Map<String, dynamic> data = Map<String, dynamic>();
    data["uid"] = prefs.getString("uid");
    data["avatar"] = prefs.getString("avatar");
    data["name"] = prefs.getString("name");
    data["is_store_owner"] = prefs.getBool("is_store_owner");
    data["phone_number"] = prefs.getString("phone_number");
    return Account.fromJson(data);
  }

  Future<void> setStore(Store store) async {
    if (prefs == null) {
      await this.init();
    }
    prefs.setString("sid", store.id);
    prefs.setString("store_name", store.name);
    prefs.setString("store_contact", store.contact);
    prefs.setString("store_image", store.image);
    prefs.setStringList("store_categories", store.categories);
    prefs.setString("store_description", store.description);
    prefs.setString("store_gstin", store.gstin);
    prefs.setString("store_logo", store.logo);
    if (store.address != null) {
      prefs.setString("address_body", store.address.body);
      prefs.setString("address_city", store.address.city);
      prefs.setString("address_pin_code", store.address.pinCode);
    }
  }

  Future<Store> getStore() async {
    if (prefs == null) {
      await this.init();
    }
    Store store = Store();
    store.id = prefs.getString('sid');
    store.name = prefs.getString('store_name');
    store.contact = prefs.getString('store_contact');
    if (prefs.containsKey("address_body")) {
      store.address = Address(
          body: prefs.getString("address_body"),
          city: prefs.getString("address_city"),
          pinCode: prefs.getString("address_pin_code"));
    }
    store.image = prefs.getString('store_image');
    if (prefs.getString('categories') != null) {
      store.categories = [];
      prefs.getStringList('store_categories').forEach((v) {
        store.categories.add(v);
      });
    }
    store.logo = prefs.getString("store_logo");
    store.description = prefs.getString('store_description');
    store.owner = prefs.getString('uid');
    store.gstin = prefs.getString('store_gstin');
    return store;
  }

  // Future<bool> isFetchingUnitViable() async {
  //   if (prefs.containsKey("last_unit_fetch")) {
  //     var lastUnitFetch = prefs.getString("last_unit_fetch");
  //     DateTime dateTime = DateTime.parse(lastUnitFetch);
  //     return (DateTime.now().difference(dateTime)).inDays >= 1;
  //   } else {
  //     return true;
  //   }
  // }

  // Future<void> insertLastUnitFetch() async {
  //   prefs.setString("last_unit_fetch", DateTime.now().toIso8601String());
  // }
}
