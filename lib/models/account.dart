import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' show User;

class Account {
  String uid;
  String name;
  // String password;
  String avatar;
  bool isStoreOwner;
  String phoneNumber;
  DateTime lastLogin;
  List<String> tokens;
  File imageFile;
  String sid, storeName, gstin;

  Account(
      {this.uid,
      this.avatar = "",
      this.isStoreOwner = false,
      this.lastLogin,
      this.tokens = const [],
      this.name,
      this.phoneNumber});

  User user;

  void setUser(User u) {
    this.user = u;
  }

  Account.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    avatar = json['avatar'];
    // password = json['password'];
    isStoreOwner = json['is_store_owner'];
    phoneNumber = json['phone_number'];
    tokens = json.containsKey("tokens")
        ? (json['tokens'] as List<dynamic>).map((e) => e.toString()).toList()
        : [];
    sid = json.containsKey("sid") ? json['sid'] : "";
    storeName = json.containsKey("store_name") ? json['store_name'] : "";
    gstin = json.containsKey("gstin") ? json['gstin'] : "";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['name'] = name;
    data['avatar'] = avatar;
    data['is_store_owner'] = isStoreOwner;
    data['phone_number'] = phoneNumber;
    data['tokens'] = tokens == null ? [] : tokens;
    data['sid'] = sid == null ? "" : sid;
    data['store_name'] = storeName == null ? "" : storeName;
    data['gstin'] = gstin == null ? "" : gstin;
    return data;
  }
}
