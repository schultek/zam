import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../../providers/helpers.dart';
import '../../../providers/providers.dart';

@MappableClass(generateMethods: GenerateMethods.copy)
class GroupFilter {
  String? hasUser;
  String? hasOrganizer;

  GroupFilter({this.hasUser, this.hasOrganizer});
}

final adminGroupsProvider = StreamProvider<List<Group>>((ref) async* {
  var user = await ref.watch(userProvider.future);

  if (user == null) {
    yield [];
    return;
  }

  var query = FirebaseFirestore.instance.collection('groups');
  yield* query.snapshotsMapped<Group>();
}).cached;

final adminFilteredGroupsProvider = Provider<List<Group>>((ref) {
  var groups = ref.watch(adminGroupsProvider).value ?? [];
  var filter = ref.watch(adminGroupFilterProvider);
  if (filter == null) {
    return groups;
  } else {
    return groups.where((group) {
      if (filter.hasUser != null && !group.users.containsKey(filter.hasUser)) return false;
      if (filter.hasOrganizer != null && group.users[filter.hasOrganizer]?.role != UserRoles.organizer) return false;
      return true;
    }).toList();
  }
});

final adminGroupFilterProvider = StateProvider<GroupFilter?>((ref) => null);
