import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/models/models.dart';

import '../../../core/core.dart';
import 'admin_groups_provider.dart';
import 'admin_provider.dart';

final adminUsersProvider = FutureProvider<List<UserData>>((ref) async {
  try {
    var users = await ref.watch(adminApiProvider).getAllUsers();
    return users;
  } catch (e) {
    print(e);
    return [];
  }
});

final adminGroupsOfUserProvider = Provider.family<List<Group>, String>((ref, String id) {
  var groups = ref.watch(adminGroupsProvider.select((AsyncValue<List<Group>> groups) {
    return groups.value?.where((group) => group.users.containsKey(id)).toList() ?? [];
  }));
  return groups;
});

final adminFilteredUsersProvider = Provider((ref) {
  var users = ref.watch(adminUsersProvider).value ?? [];
  var filter = ref.watch(adminUserFilterProvider);

  bool isInGroup(UserData user, String groupId) {
    return ref.watch(adminGroupsProvider.select(
      (groups) => groups.value?.where((g) => g.id == groupId && g.users.containsKey(user.id)).isNotEmpty ?? false,
    ));
  }

  bool isOrganizerOfGroup(UserData user, String groupId) {
    return ref.watch(adminGroupsProvider.select((groups) =>
        groups.value?.where((g) => g.id == groupId && g.users[user.id]?.role == UserRoles.organizer).isNotEmpty ??
        false));
  }

  if (filter == null) {
    return users;
  } else {
    return users.where((user) {
      if (filter.isAdmin != null && user.claims.isAdmin != filter.isAdmin) return false;
      if (filter.isGroupCreator != null && user.claims.isGroupCreator != filter.isGroupCreator) return false;
      if (filter.isInGroup != null && !isInGroup(user, filter.isInGroup!)) return false;
      if (filter.isOrganizerOfGroup != null && !isOrganizerOfGroup(user, filter.isOrganizerOfGroup!)) return false;
      return true;
    });
  }
});

@MappableClass(generateMethods: GenerateMethods.copy)
class UserFilter {
  bool? isAdmin;
  bool? isGroupCreator;
  String? isInGroup;
  String? isOrganizerOfGroup;

  UserFilter({this.isAdmin, this.isGroupCreator, this.isInGroup, this.isOrganizerOfGroup});
}

final adminUserFilterProvider = StateProvider<UserFilter?>((ref) => null);

final adminUsersLogicProvider = Provider((ref) => UsersLogic(ref));

class UsersLogic {
  final Ref ref;

  UsersLogic(this.ref);

  Future<void> setClaims(String userId, UserClaims claims) async {
    await ref.read(adminApiProvider).setClaims(userId, claims);
    ref.refresh(adminUsersProvider);
  }
}
