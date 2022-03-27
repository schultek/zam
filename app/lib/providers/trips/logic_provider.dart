import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../auth/claims_provider.dart';
import '../auth/user_provider.dart';
import 'selected_trip_provider.dart';

final tripsLogicProvider = Provider((ref) => TripsLogic(ref));

class TripsLogic {
  final Ref ref;
  TripsLogic(this.ref);

  String? get _tripId => ref.read(selectedTripIdProvider);
  String? get _userId => ref.read(userIdProvider);

  Future<void> setUserName(String text) {
    return FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'users.$_userId.nickname': text,
    });
  }

  Future<void> addUser(String name) {
    var userId = generateRandomId();
    return FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'users.$userId': {'nickname': name, 'role': UserRoles.participant},
    });
  }

  Future<void> uploadProfileImage(Uint8List bytes) async {
    var link = await uploadImage('users/$_userId/profile.png', bytes);
    return FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'users.$_userId.profileUrl': link,
    });
  }

  Future<void> setTripPicture(Uint8List bytes) async {
    var link = await uploadImage('picture.png', bytes);
    return FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'pictureUrl': link,
    });
  }

  Future<void> updateTrip(Map<String, dynamic> map) async {
    if (ref.read(tripUserProvider)?.role != UserRoles.organizer) return;
    return FirebaseFirestore.instance.collection('trips').doc(_tripId).update(map);
  }

  Future<void> leaveSelectedTrip() async {
    await FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'users.$_userId': FieldValue.delete(),
    });
  }

  Future<void> deleteSelectedTrip() async {
    if (ref.read(claimsProvider).isOrganizer) {
      await FirebaseFirestore.instance.collection('trips').doc(_tripId).delete();
    }
  }

  Future<void> setPushToken(String? token) async {
    var trip = ref.read(selectedTripProvider);
    if (trip?.users.containsKey(_userId) ?? false) {
      await FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
        'users.$_userId.token': token,
      });
    }
  }

  Future<void> deleteUser(String id) async {
    await FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'users.$id': FieldValue.delete(),
    });
  }

  Future<void> updateUserRole(String id, String role) async {
    await FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'users.$id.role': role,
    });
  }

  Future<void> updateTemplateModel(TemplateModel model) async {
    await FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'template': model.toMap(),
    });
  }

  Future<String> uploadImage(String path, Uint8List bytes) async {
    var ref = FirebaseStorage.instance.ref('images/$_tripId/$path');
    await ref.putData(bytes);
    var link = await ref.getDownloadURL();
    return link;
  }
}
