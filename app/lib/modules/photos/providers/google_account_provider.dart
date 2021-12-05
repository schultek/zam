import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignInProvider = Provider((ref) => GoogleSignIn(scopes: <String>[
      'profile',
      'https://www.googleapis.com/auth/photoslibrary.readonly',
    ]));

final googleAccountProvider =
    StateNotifierProvider<GoogleAccountNotifier, GoogleSignInAccount?>((ref) => GoogleAccountNotifier(ref));

final googleSignInFutureProvider = FutureProvider((ref) => ref.watch(googleSignInProvider).signInSilently());

final isSignedInWithGoogleProvider = FutureProvider((ref) =>
    ref.watch(googleSignInFutureProvider.future).then((acc) => (ref.watch(googleAccountProvider) ?? acc) != null));

class GoogleAccountNotifier extends StateNotifier<GoogleSignInAccount?> {
  final Ref ref;
  late StreamSubscription<GoogleSignInAccount?> _userSubscription;

  GoogleAccountNotifier(this.ref) : super(ref.read(googleSignInProvider).currentUser) {
    ref.watch(googleSignInFutureProvider);
    _userSubscription = ref.watch(googleSignInProvider).onCurrentUserChanged.listen((user) {
      state = user;
    });
  }

  Future<bool> signIn() async {
    state = await ref.read(googleSignInProvider).signIn();
    return state != null;
  }

  Future<bool> signOut() async {
    state = await ref.read(googleSignInProvider).signOut();
    return state != null;
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
