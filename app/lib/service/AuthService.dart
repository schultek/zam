import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  static User getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<void> signIn(String phoneNumber, void Function(String verificationId) onSent, void Function() onCompleted) async {

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
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
        }
    );


  }

  static Stream<User> getUserStream() {
    return FirebaseAuth.instance.authStateChanges();
  }

  static void verifyCode(String code, String verificationId) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
    await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
  }
}
