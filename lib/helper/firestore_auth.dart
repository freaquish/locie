import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

class PhoneAuthentication {
  final String phoneNumber;
  final String otp;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('accounts');
  User user;
  PhoneAuthentication({@required this.phoneNumber, @required this.otp});

  void sendOTP(String phoneNumber, PhoneCodeSent codeSent,
      PhoneVerificationFailed verificationFailed) {
    if (!phoneNumber.contains('+')) phoneNumber = '+91' + phoneNumber;
    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 30),
        verificationCompleted: (PhoneAuthCredential credential) {
          signInWithPhoneNumber(credential);
        },
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: null);
  }

  Future<void> signInWithPhoneNumber(PhoneAuthCredential credential) async {
    await auth.signInWithCredential(credential).then((UserCredential value) {
      this.user = value.user;
    });
    //Save data to firebase firestore
    await firestore.doc(user.uid).set({
      'uid': user.uid,
      'isDataUpdate': false,
      'phoneNumber': phoneNumber,
    });
  }

  verificationFailed(FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {}
  }

  Future<void> codeSent(
      String verificationId, int resendToken, String otp) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    await signInWithPhoneNumber(phoneAuthCredential);
  }
}
