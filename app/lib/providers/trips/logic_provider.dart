import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../auth/user_provider.dart';
import 'selected_trip_provider.dart';

final tripsLogicProvider = Provider((ref) => TripsLogic(ref));

class TripsLogic {
  final ProviderReference ref;
  TripsLogic(this.ref);

  String? get _tripId => ref.read(selectedTripIdProvider);
  String? get _userId => ref.read(userIdProvider);

  Future<void> setUserName(String text) {
    return FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'users.$_userId.nickname': text,
    });
  }

  Future<void> uploadProfileImage(Uint8List bytes) async {
    var ref = FirebaseStorage.instance.ref('images/$_userId/profile.png');
    await ref.putData(bytes);
    var link = await ref.getDownloadURL();
    return FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'users.$_userId.profileUrl': link,
    });
  }

  Future<void> setTripPicture(Uint8List bytes) async {
    var ref = FirebaseStorage.instance.ref('images/$_tripId/picture.png');
    await ref.putData(bytes);
    var link = await ref.getDownloadURL();
    return FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'pictureUrl': link,
    });
  }

  Future<void> updateTrip(Map<String, dynamic> map) async {
    if (ref.read(tripUserProvider)?.role != UserRoles.Organizer) return;
    return FirebaseFirestore.instance.collection('trips').doc(_tripId).update(map);
  }

  Future<void> leaveSelectedTrip() async {
    await FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'users.$_userId': FieldValue.delete(),
    });
  }

  Future<void> setPushToken(String? token) async {
    await FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'users.$_userId.token': token,
    });
  }

  Future<void> deleteUser(String id) async {
    await FirebaseFirestore.instance.collection('trips').doc(_tripId).update({
      'users.$id': FieldValue.delete(),
    });
  }
}
