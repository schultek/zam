import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthService with ChangeNotifier {
  User user;
  String userRole;

  static AuthService instance;
  AuthService() {
    instance = this;
  }

  void updateUser() {
    user = FirebaseAuth.instance.currentUser;
    instance.notifyListeners();
  }

  Future<void> updateUserRole() async {
    var result = await getUser().getIdTokenResult(true);
    userRole = result.claims["role"];
    instance.notifyListeners();
  }

  Future<void> updateAll() async {
    user = FirebaseAuth.instance.currentUser;
    var result = await getUser().getIdTokenResult(true);
    userRole = result.claims["role"];
    instance.notifyListeners();
  }

  static User getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<void> signIn(String phoneNumber, void Function(String verificationId) onSent, void Function() onCompleted) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await getUser().linkWithCredential(credential);
          if (instance != null) {
            instance.updateUser();
          }
          onCompleted();
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, int resendToken) {
          onSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("TIMEOUT");
        });
  }

  static void verifyCode(String code, String verificationId) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
    await getUser().linkWithCredential(phoneAuthCredential);
    if (instance != null) {
      instance.updateUser();
    }
  }

  static Future<void> createAnonymousUser() async {
    await FirebaseAuth.instance.signInAnonymously();
  }
}

class UserRoles {
  static const Organizer = "organizer";
  static const Leader = "leader";
  static const Participant = "participant";
}
