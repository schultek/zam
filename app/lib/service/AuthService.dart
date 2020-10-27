import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthService with ChangeNotifier {
  User user;
  String userRole;

  static AuthService instance;
  AuthService() {
    instance = this;
  }

  void updateUser(User user) {
    this.user = user;
    this.notifyListeners();
  }

  Future<void> updateUserRole() async {
    var result = await getUser().getIdTokenResult(true);
    userRole = result.claims["role"];
    this.notifyListeners();
  }

  Future<void> updateAll(User user) async {
    this.user = user;
    var result = await user.getIdTokenResult(true);
    userRole = result.claims["role"];
    this.notifyListeners();
  }

  static User getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<void> signIn(String phoneNumber, void Function(String verificationId) onSent, void Function() onCompleted) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          var userCredential;
          try {
            userCredential = await getUser().linkWithCredential(credential);
          } on FirebaseAuthException catch (exception) {
            print(exception.code);
            if (exception.code == "credential-already-in-use") {
              userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
            } else {
              throw exception;
            }
          }
          if (instance != null) {
            instance.updateUser(userCredential.user);
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
    var userCredential = await getUser().linkWithCredential(phoneAuthCredential);
    if (instance != null) {
      instance.updateUser(userCredential.user);
    }
  }

  static Future<UserCredential> createAnonymousUser() {
    return FirebaseAuth.instance.signInAnonymously();
  }

  static Future<User> getInitialUser() {
    return FirebaseAuth.instance.userChanges().first;
  }
}

class UserRoles {
  static const Organizer = "organizer";
  static const Leader = "leader";
  static const Participant = "participant";
}
