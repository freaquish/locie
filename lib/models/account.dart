import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' show User;

class Account {
  String uid;
  String name;
  String avatar;
  bool isStoreOwner;
  String phoneNumber;
  DateTime lastLogin;
  List<String> tokens;
  File imageFile;

  Account(
      {this.uid,
      this.avatar = "",
      this.isStoreOwner = false,
      this.lastLogin,
      this.tokens,
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
    isStoreOwner = json['is_store_owner'];
    phoneNumber = json['phone_number'];
    tokens = json.containsKey("tokens")
        ? (json['tokens'] as List<dynamic>).map((e) => e.toString()).toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['name'] = name;
    data['avatar'] = avatar;
    data['is_store_owner'] = isStoreOwner;
    data['phone_number'] = phoneNumber;
    data['tokens'] = tokens == null ? [] : tokens;
    return data;
  }
}
