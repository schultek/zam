import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../groups/selected_group_provider.dart';

export 'firestore_extensions.dart';

final groupDocProvider =
    Provider((ref) => FirebaseFirestore.instance.collection('groups').doc(ref.watch(selectedGroupIdProvider)));

final moduleDocProvider =
    Provider.family((ref, String id) => ref.watch(groupDocProvider).collection('modules').doc(id));
