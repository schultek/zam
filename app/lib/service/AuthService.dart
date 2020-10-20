import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  static User getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static void signIn(String phoneNumber) async {

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);
          print("Juhu");
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, int resendToken) {
          print("SENT");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("TIMEOUT");
        }
    );


  }

}
