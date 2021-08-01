import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helpers/optional.dart';

class AuthBloc extends Cubit<AuthState> {
  StreamSubscription<User?>? _userSubscription;

  AuthBloc() : super(AuthState.initial()) {
    _userSubscription = FirebaseAuth.instance.userChanges().listen((user) {
      updateUser(user);
    });
  }

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    await super.close();
  }

  Future<void> updateUser(User? user, {bool removeLink = false}) async {
    if (user != null && state.user?.uid != user.uid) {
      emit(state.copyWith(
        user: Optional(user),
        claims: await getClaimsForUser(user),
        invitationLink: removeLink ? Optional(null) : null,
      ));
    } else {
      emit(state.copyWith(
        user: Optional(user),
        invitationLink: removeLink ? Optional(null) : null,
      ));
    }
  }

  Future<UserClaims> getClaimsForUser(User user, {bool forceRefresh = false}) async {
    var result = await user.getIdTokenResult(forceRefresh);
    return UserClaims(
      isOrganizer: result.claims?["isOrganizer"] as bool? ?? false,
      isAdmin: result.claims?["isAdmin"] as bool? ?? false,
    );
  }

  Future<void> updateUserClaims(bool forceRefresh) async {
    if (state.user != null) {
      emit(state.copyWith(
        claims: await getClaimsForUser(state.user!, forceRefresh: forceRefresh),
      ));
    }
  }

  void handleInvitationLink(Uri uri) {
    emit(state.copyWith(invitationLink: Optional(uri)));
  }
}

class AuthState {
  final User? user;
  final UserClaims claims;

  final Uri? invitationLink;

  AuthState({
    this.user,
    this.claims = const UserClaims(),
    this.invitationLink,
  });

  factory AuthState.initial() {
    return AuthState(user: FirebaseAuth.instance.currentUser);
  }

  AuthState copyWith({
    Optional<User>? user,
    UserClaims? claims,
    Optional<Uri>? invitationLink,
  }) {
    return AuthState(
      user: user != null ? user.value : this.user,
      claims: claims ?? this.claims,
      invitationLink: invitationLink != null ? invitationLink.value : this.invitationLink,
    );
  }

  @override
  String toString() {
    return 'AuthState{user: $user, claims: $claims, invitationLink: $invitationLink}';
  }
}

class UserClaims {
  final bool isOrganizer;
  final bool isAdmin;

  const UserClaims({
    this.isOrganizer = false,
    this.isAdmin = false,
  });

  @override
  String toString() {
    return 'UserClaims{isOrganizer: $isOrganizer, isAdmin: $isAdmin}';
  }
}
