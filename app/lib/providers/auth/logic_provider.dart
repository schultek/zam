import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_udid/flutter_udid.dart';

final authLogicProvider = Provider((ref) => AuthLogic(ref));

class AuthLogic {
  final ProviderReference ref;
  AuthLogic(this.ref);

  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    int? resendToken,
    void Function(String, int?)? onSent,
    void Function(User)? onCompleted,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('VERIFY COMPLETED');
        var user = await signInUser(credential);
        onCompleted?.call(user);
      },
      verificationFailed: (FirebaseAuthException exception) {
        print('VERIFY ERROR');
        print(exception.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        onSent?.call(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('VERIFY TIMEOUT');
      },
    );
  }

  Future<User> verifyCode(String code, String verificationId) async {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
    return signInUser(phoneAuthCredential);
  }

  Future<User> signInUser(AuthCredential phoneAuthCredential) async {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    return userCredential.user!;
  }

  Future<void> signInAnonymously() async {
    String udid = await FlutterUdid.udid;
    String idHash = sha1.convert(utf8.encode(udid)).toString();
    var email = '$idHash@jufa20.web.app';
    var results = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (results.isEmpty) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: udid);
    } else {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: udid);
    }
  }
}
