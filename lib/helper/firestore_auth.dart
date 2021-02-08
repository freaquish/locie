import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locie/helper/firestore_storage.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/account.dart';
import 'package:pdf/widgets.dart';
// import 'package:firebase_core/firebase_core.dart';

abstract class PhoneAuthenticationExceptions extends Error {}

class LoginFailed extends PhoneAuthenticationExceptions {}

String encryptPassword(String password, String phoneNumber) {
  String salt = phoneNumber.substring(4);
  return Crypt.sha256(password, salt: salt).hash;
}

class PhoneAuthentication {
  String phoneNumber;
  String otp;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String verificationId;
  int resendToken;
  final firestore = FirebaseFirestore.instance.collection('accounts');
  User user;
  PhoneAuthentication({@required this.phoneNumber});

  void sendOTP(Function onComplete) {
    if (!phoneNumber.contains('+')) phoneNumber = '+91' + phoneNumber;
    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) {
          signInWithPhoneNumber(credential, onComplete: onComplete);
        },
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId = verificationId;
        });
  }

  Future<void> signInWithPhoneNumber(PhoneAuthCredential credential,
      {Function(String) onComplete}) async {
    await auth.signInWithCredential(credential).then((UserCredential value) {
      this.user = value.user;
      if (onComplete != null) {
        onComplete(user.uid);
      }
    });
  }

  static Future<Account> createAccount(Account account) async {
    // Injecting uid and phone number in account if null
    LocalStorage localStorage = LocalStorage();
    if (account.uid == null || account.phoneNumber == null) {
      await localStorage.init();
      account.uid = localStorage.prefs.getString("uid");
      account.phoneNumber = localStorage.prefs.getString("phone_number");
    }

    if (account.imageFile != null) {
      CloudStorage storage = CloudStorage();
      var task = storage.uploadFile(account.imageFile);
      account.avatar = await storage.getDownloadUrl(task);
      account.imageFile = null;
    }
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc(account.uid)
        .set(account.toJson());
    await localStorage.setAccount(account);
    return account;
  }

  static Future<void> updateToken(String token, String uid) async {
    LocalStorage localStorage = LocalStorage();
    await localStorage.init();
    await FirebaseFirestore.instance
        .collection("tokens")
        .doc(token)
        .set({"token": token, "uid": uid, "timestamp": DateTime.now()});
  }

  verificationFailed(FirebaseAuthException e) {
    print(e.message);
    // throw e;
  }

  Future<void> codeSent(String verificationId, int resendToken) async {
    this.verificationId = verificationId;
    this.resendToken = resendToken;
  }

  Future<void> verifyOtp(String otp) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    await signInWithPhoneNumber(phoneAuthCredential);
  }

  Future<User> getUser() async {
    return auth.currentUser;
  }
}
