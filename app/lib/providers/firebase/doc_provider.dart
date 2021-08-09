import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../trips/selected_trip_provider.dart';

final tripDocProvider =
    Provider((ref) => FirebaseFirestore.instance.collection("trips").doc(ref.watch(selectedTripIdProvider)));

final moduleDocProvider = Provider.family((ref, String id) => ref.watch(tripDocProvider).collection("modules").doc(id));
