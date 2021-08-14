import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleAccountProvider =
    StateNotifierProvider<GoogleAccountNotifier, GoogleSignInAccount?>((ref) => GoogleAccountNotifier(ref));

final isSignedInWithGoogleProvider = Provider((ref) => ref.watch(googleAccountProvider) != null);

class GoogleAccountNotifier extends StateNotifier<GoogleSignInAccount?> {
  final ProviderReference ref;
  final GoogleSignIn signIn;

  late StreamSubscription<GoogleSignInAccount?> _userSubscription;

  GoogleAccountNotifier(this.ref)
      : signIn = GoogleSignIn(scopes: <String>[
          'profile',
          'https://www.googleapis.com/auth/photoslibrary',
          'https://www.googleapis.com/auth/photoslibrary.sharing'
        ]),
        super(null) {
    state = signIn.currentUser;
    print("user init $state");
    _userSubscription = signIn.onCurrentUserChanged.listen((user) {
      print("user $user");
      state = user;
    });
  }

  Future<bool> signInWithGoogle() async {
    state = await signIn.signIn();
    return state != null;
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
