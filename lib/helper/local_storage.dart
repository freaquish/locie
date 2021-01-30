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

  Future<void> setAccount(Account account) async {
    if (prefs == null) {
      await this.init();
    }
    prefs.setString("uid", account.uid);
    prefs.setString("avatar", account.avatar);
    prefs.setString("name", account.name);
    prefs.setBool("isStoreOwner", account.isStoreOwner);
    prefs.setString("phoneNumber", account.phoneNumber);
  }

  Future<void> getAccount() async {
    if (prefs == null) {
      await this.init();
    }
    Map<String, dynamic> data = Map<String, dynamic>();
    data["uid"] = prefs.getString("uid");
    data["avatar"] = prefs.getString("avatar");
    data["name"] = prefs.getString("name");
    data["is_store_owner"] = prefs.getBool("isStoreOwner");
    data["phone_number"] = prefs.getString("phoneNumber");
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
    if(prefs.containsKey("address_body")){
      store.address = Address(
        body: prefs.getString("address_body"),
        city: prefs.getString("address_city"),
        pinCode: prefs.getString("address_pin_code")
      );
    }
    store.image = prefs.getString('store_image');
    if (prefs.getString('categories') != null) {
      store.categories = [];
      prefs.getStringList('store_categories').forEach((v) {
        store.categories.add(v);
      });
    }
    store.description = prefs.getString('store_description');
    store.owner = prefs.getString('uid');
    store.gstin = prefs.getString('store_gstin');
    return store;
  }
}
