import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<void> signIn(String phoneNumber, void Function(String) onSent, void Function(User) onCompleted) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("VERIFY COMPLETED");
        var user = await signInUser(credential);
        onCompleted(user);
      },
      verificationFailed: (FirebaseAuthException exception) {
        print("VERIFY ERROR");
        print(exception.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        onSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("VERIFY TIMEOUT");
      },
    );
  }

  static Future<User> verifyCode(String code, String verificationId) async {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
    return signInUser(phoneAuthCredential);
  }

  static Future<User> signInUser(AuthCredential phoneAuthCredential) async {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    return userCredential.user!;
  }
}
