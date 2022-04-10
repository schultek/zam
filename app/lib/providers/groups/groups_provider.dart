import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../auth/claims_provider.dart';
import '../auth/user_provider.dart';
import '../firebase/firestore_extensions.dart';
import '../helpers.dart';

final groupsProvider = StreamProvider<List<Group>>((ref) async* {
  var user = await ref.watch(userProvider.future);

  if (user == null) {
    yield [];
    return;
  }

  var userId = user.uid;
  var claims = ref.watch(claimsProvider);

  var query = claims.isAdmin
      ? FirebaseFirestore.instance.collection('groups')
      : FirebaseFirestore.instance.collection('groups').where(
          'users.$userId.role',
          whereIn: [
            UserRoles.participant,
            UserRoles.organizer,
          ],
        );

  yield* query.snapshotsMapped<Group>();
}).cached;

final joinedGroupsProvider = Provider<List<Group>>((ref) {
  var groups = ref.watch(groupsProvider).value ?? <Group>[];
  var userId = ref.watch(userIdProvider);
  return groups.where((g) => g.users.containsKey(userId)).toList();
});
