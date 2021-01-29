import 'package:locie/models/account.dart';
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
}
