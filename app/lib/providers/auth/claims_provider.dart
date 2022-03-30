import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_provider.dart';

final claimsProvider = StateNotifierProvider<ClaimsNotifier, UserClaims>((ref) => ClaimsNotifier(ref));

class ClaimsNotifier extends StateNotifier<UserClaims> {
  late final StreamSubscription<User?> _userSubscription;

  final Ref ref;

  ClaimsNotifier(this.ref) : super(const UserClaims()) {
    _onUserChanged(ref.read(userProvider).maybeWhen(data: (d) => d, orElse: () => null));
    _userSubscription = ref
        .watch(userProvider.stream)
        .distinct((previous, current) => previous?.uid == current?.uid)
        .listen(_onUserChanged);
  }

  Future<void> _onUserChanged(User? user, {bool forceRefresh = false}) async {
    if (user == null) {
      state = const UserClaims();
    } else {
      var result = await user.getIdTokenResult(forceRefresh);
      state = UserClaims(
        isGroupCreator: result.claims?['isGroupCreator'] as bool? ?? false,
        isAdmin: result.claims?['isAdmin'] as bool? ?? false,
      );
    }
  }

  Future<void> refresh() async {
    await _onUserChanged(ref.read(userProvider).maybeWhen(data: (d) => d, orElse: () => null), forceRefresh: true);
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}

class UserClaims {
  final bool isGroupCreator;
  final bool isAdmin;

  const UserClaims({
    this.isGroupCreator = false,
    this.isAdmin = false,
  });

  @override
  String toString() {
    return 'UserClaims{isGroupCreator: $isGroupCreator, isAdmin: $isAdmin}';
  }
}
