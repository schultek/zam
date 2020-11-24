import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  static User getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<void> signIn(String phoneNumber, void Function(String verificationId) onSent, void Function(User user) onCompleted) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          var user = await linkOrSignInUser(credential);
          onCompleted(user);
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

  static Future<User> verifyCode(String code, String verificationId) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
    return await linkOrSignInUser(phoneAuthCredential);
  }

  static Future<User> linkOrSignInUser(PhoneAuthCredential phoneAuthCredential) async {
    var userCredential;
    try {
      userCredential = await getUser().linkWithCredential(phoneAuthCredential);
    } on FirebaseAuthException catch (exception) {
      print(exception.code);
      if (exception.code == "credential-already-in-use") {
        userCredential = await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      } else {
        throw exception;
      }
    }
    return userCredential.user;
  }

  static Future<UserCredential> createAnonymousUser() {
    return FirebaseAuth.instance.signInAnonymously();
  }

  static Future<User> getInitialUser() {
    return FirebaseAuth.instance.userChanges().first;
  }
}


