import 'package:firebase_auth/firebase_auth.dart' show User;

class Account {
  final String uid;
  final String name;
  final String avatar;
  final bool isStoreOwner;
  final String phoneNumber;
  final DateTime lastLogin;

  Account(
      {this.uid,
      this.avatar,
      this.isStoreOwner,
      this.lastLogin,
      this.name,
      this.phoneNumber});

  User user;

  void setUser(User u) {
    this.user = u;
  }

  Account fromJson(dynamic json) {
    return Account();
  }
}
