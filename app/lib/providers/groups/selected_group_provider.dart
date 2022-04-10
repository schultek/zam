import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../auth/claims_provider.dart';
import '../auth/user_provider.dart';
import '../general/preferences_provider.dart';
import 'groups_provider.dart';

final selectedGroupIdProvider = StateNotifierProvider<GroupIdNotifier, String?>((ref) {
  var prefs = ref.watch(sharedPreferencesProvider).value;
  var initialState = prefs?.getString('selected_group_id');

  return GroupIdNotifier(ref, initialState);
});

class GroupIdNotifier extends StateNotifier<String?> {
  final Ref ref;

  GroupIdNotifier(this.ref, String? initialState) : super(initialState);

  SharedPreferences? get prefs => ref.read(sharedPreferencesProvider).value;

  @override
  set state(String? value) {
    if (value != null) {
      prefs?.setString('selected_group_id', value);
    } else {
      prefs?.remove('selected_group_id');
    }
    super.state = value;
  }
}

final selectedGroupProvider = Provider<Group?>((ref) {
  var selectedGroupId = ref.watch(selectedGroupIdProvider);

  var groups = ref.watch(groupsProvider);
  var group = groups.value?.where((t) => t.id == selectedGroupId).firstOrNull;

  return group;
});

final groupUserProvider = Provider<GroupUser?>((ref) {
  var userId = ref.watch(userIdProvider);
  if (userId == null) return null;

  var selectedGroup = ref.watch(selectedGroupProvider);
  if (selectedGroup == null) return null;

  return selectedGroup.users[userId];
});

final isOrganizerProvider =
    Provider((ref) => ref.watch(isAdminProvider) || (ref.watch(groupUserProvider)?.isOrganizer ?? false));

final groupUserByIdProvider = Provider.family((ref, String id) => ref.watch(selectedGroupProvider)?.users[id]);
final nicknameProvider = Provider.family((ref, String id) => ref.watch(groupUserByIdProvider(id))?.nickname);
