import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../auth/claims_provider.dart';
import '../auth/user_provider.dart';

final tripsProvider = StreamProvider<List<Trip>>((ref) {
  var user = ref.watch(userProvider);
  return user.when(
    data: (data) {
      var userId = data?.uid;
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

      return query.snapshotsMapped();
    },
    loading: () => const Stream.empty(),
    error: (_, __) => Stream.value([]),
  );
});

final isLoadingTripsProvider =
    Provider((ref) => ref.watch(tripsProvider).maybeWhen(loading: () => true, orElse: () => false));
