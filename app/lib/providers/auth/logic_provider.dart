import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_udid/flutter_udid.dart';

import '../groups/selected_group_provider.dart';

final authLogicProvider = Provider((ref) => AuthLogic(ref));

class AuthLogic {
  final Ref ref;
  AuthLogic(this.ref);

  Future<void> verifyPhoneNumber(String phoneNumber,
      {int? resendToken,
      void Function(String, int?)? onSent,
      void Function(User)? onCompleted,
      void Function(FirebaseAuthException)? onFailed}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        var user = await signInUser(credential);
        onCompleted?.call(user);
      },
      verificationFailed: (FirebaseAuthException exception) {
        onFailed?.call(exception);
      },
      codeSent: (String verificationId, int? resendToken) {
        onSent?.call(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        onFailed?.call(FirebaseAuthException(code: 'auto-retrieval-timeout'));
      },
    );
  }

  Future<User> verifyCode(String code, String verificationId) async {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
    return signInUser(phoneAuthCredential);
  }

  Future<User> signInUser(AuthCredential phoneAuthCredential) async {
    UserCredential userCredential;

    if (FirebaseAuth.instance.currentUser != null) {
      userCredential = await FirebaseAuth.instance.currentUser!.linkWithCredential(phoneAuthCredential);
    } else {
      userCredential = await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    }

    FirebaseAnalytics.instance.logLogin(loginMethod: 'phone');

    return userCredential.user!;
  }

  Future<void> signInAnonymously() async {
    String udid = await FlutterUdid.udid;
    String idHash = sha1.convert(utf8.encode(udid)).toString();
    print('URI: $udid ($idHash)');
    var email = '$idHash@jufa20.web.app';
    var results = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (results.isEmpty) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: udid);
    } else {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: udid);
    }

    FirebaseAnalytics.instance.logLogin(loginMethod: 'anonymous');
  }

  Future<void> signOut() async {
    ref.read(selectedGroupIdProvider.notifier).state = null;
    await FirebaseAuth.instance.signOut();
  }
}
