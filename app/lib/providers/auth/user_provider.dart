import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_provider.dart';

final userProvider = StreamProvider<User?>((ref) => ref.watch(firebaseProvider).maybeWhen(
      data: (_) => FirebaseAuth.instance.userChanges(),
      orElse: () => const Stream.empty(),
    ));

final userIdProvider =
    Provider((ref) => ref.watch(userProvider).maybeWhen(data: (data) => data?.uid, orElse: () => null));
