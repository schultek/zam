import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../auth/claims_provider.dart';
import '../auth/user_provider.dart';
import '../firebase/firestore_extensions.dart';
import '../helpers.dart';

final tripsProvider = StreamProvider<List<Trip>>((ref) async* {
  var user = await ref.watch(userProvider.future);

  var userId = user?.uid;
  var claims = ref.watch(claimsProvider);

  var query = claims.isAdmin
      ? FirebaseFirestore.instance.collection('trips')
      : FirebaseFirestore.instance.collection('trips').where(
          'users.$userId.role',
          whereIn: [
            UserRoles.participant,
            UserRoles.leader,
            UserRoles.organizer,
          ],
        );

  yield* query.snapshotsMapped<Trip>();
}).cached;
