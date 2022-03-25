import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_provider.dart';

final userProvider = StreamProvider<User?>((ref) => ref.watch(firebaseProvider).maybeWhen(
      data: (_) => FirebaseAuth.instance.userChanges(),
      orElse: () => const Stream.empty(),
    ));

final isSignedInProvider = Provider((ref) => ref.watch(userProvider).value != null);

final userIdProvider = Provider((ref) {
  var userId = ref.watch(userProvider).maybeWhen(data: (data) => data?.uid, orElse: () => null);
  FirebaseCrashlytics.instance.setUserIdentifier(userId ?? '');
  return userId;
});
