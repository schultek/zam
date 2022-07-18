import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../core/editing/editing_providers.dart';
import '../../core/editing/widgets/ju_logo.dart';
import '../../helpers/capture_widget.dart';
import '../../helpers/extensions.dart';
import '../auth/claims_provider.dart';
import '../auth/user_provider.dart';
import 'selected_group_provider.dart';

final groupsLogicProvider = Provider((ref) => GroupsLogic(ref));

class GroupsLogic {
  final Ref ref;
  GroupsLogic(this.ref);

  String? get _groupId => ref.read(selectedGroupIdProvider);
  String? get _userId => ref.read(userIdProvider);

  Future<void> setUserName(String text) {
    return FirebaseFirestore.instance.collection('groups').doc(_groupId).update({
      'users.$_userId.nickname': text,
    });
  }

  Future<void> addUser(String name) {
    var userId = generateRandomId(10);
    return FirebaseFirestore.instance.collection('groups').doc(_groupId).update({
      'users.$userId': {'nickname': name, 'role': UserRoles.participant},
    });
  }

  Future<void> uploadProfileImage(Uint8List bytes) async {
    var link = await uploadFile('users/$_userId/profile.png', bytes);
    return FirebaseFirestore.instance.collection('groups').doc(_groupId).update({
      'users.$_userId.profileUrl': link,
    });
  }

  Future<String> setGroupPicture(Uint8List bytes) async {
    var link = await uploadFile('picture.png', bytes);
    await FirebaseFirestore.instance.collection('groups').doc(_groupId).update({
      'pictureUrl': link,
    });
    return link;
  }

  Future<void> deleteGroupPicture() async {
    await deleteFile('picture.png');
    return FirebaseFirestore.instance.collection('groups').doc(_groupId).update({
      'pictureUrl': FieldValue.delete(),
    });
  }

  Future<void> updateGroup(Map<String, dynamic> map, [String? groupId]) async {
    if (!ref.read(isOrganizerProvider)) return;
    return FirebaseFirestore.instance.collection('groups').doc(groupId ?? _groupId).update(map);
  }

  Future<void> leaveSelectedGroup() async {
    var groupId = _groupId;
    ref.read(selectedGroupIdProvider.notifier).state = null;
    ref.read(editProvider.notifier).endEditing();
    await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'users.$_userId': FieldValue.delete(),
    });
  }

  Future<void> deleteSelectedGroup() async {
    if (ref.read(isGroupCreatorProvider)) {
      var groupId = _groupId;
      ref.read(selectedGroupIdProvider.notifier).state = null;
      ref.read(editProvider.notifier).endEditing();
      await FirebaseFirestore.instance.collection('groups').doc(groupId).delete();
    }
  }

  Future<void> setPushToken(String? token) async {
    var group = ref.read(selectedGroupProvider);
    if (group?.users.containsKey(_userId) ?? false) {
      await FirebaseFirestore.instance.collection('groups').doc(_groupId).update({
        'users.$_userId.token': token,
      });
    }
  }

  Future<void> deleteUser(String id) async {
    await FirebaseFirestore.instance.collection('groups').doc(_groupId).update({
      'users.$id': FieldValue.delete(),
    });
  }

  Future<void> updateUserRole(String id, String role) async {
    await FirebaseFirestore.instance.collection('groups').doc(_groupId).update({
      'users.$id.role': role,
    });
  }

  Future<void> updateTemplateModel(TemplateModel model) async {
    await FirebaseFirestore.instance.collection('groups').doc(_groupId).update({
      'template': model.toMap(),
    });
  }

  Future<String> uploadFile(String path, Uint8List bytes) async {
    var ref = FirebaseStorage.instance.ref('groups/$_groupId/$path');
    await ref.putData(bytes);
    var link = await ref.getDownloadURL();
    return link;
  }

  Future<void> deleteFile(String path) {
    var ref = FirebaseStorage.instance.ref('groups/$_groupId/$path');
    return ref.delete();
  }

  Future<void> updateLogo(Group group) async {
    if (group.id != _groupId) return;
    if (group.pictureUrl == null) {
      var bytes = await CaptureWidget.offStage(
        JuLogo(size: 100, name: group.name, theme: group.theme),
      );
      var link = await uploadFile('picture.png', bytes);
      await FirebaseFirestore.instance.collection('groups').doc(_groupId).update({
        'logoUrl': link,
      });
    } else {
      await FirebaseFirestore.instance.collection('groups').doc(_groupId).update({
        'logoUrl': group.pictureUrl,
      });
    }
  }

  Future<LandingPageConfig> createLandingPage(Group group) async {
    var slug = Uri.encodeComponent(CaseStyle.snakeCase //
        .transform(group.name)
        .replaceAll('ä', 'ae')
        .replaceAll('ö', 'oe')
        .replaceAll('ü', 'ue'));

    var prefix = '';
    while (true) {
      var doc = FirebaseFirestore.instance.collection('pages').doc(slug + prefix);
      if ((await doc.get()).exists) {
        prefix = '_${generateRandomId(4)}';
      } else {
        await doc.set({'group': group.id});
        return LandingPageConfig(slug: slug + prefix);
      }
    }
  }
}
