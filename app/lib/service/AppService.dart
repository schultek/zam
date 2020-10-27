import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jufa/providers/AppState.dart';

import '../models/Trip.dart';

import 'AuthService.dart';
import 'DatabaseService.dart';
import 'DynamicLinkService.dart';

class AppService {
  static Future<User> initApp(AppState state) async {
    await Firebase.initializeApp();

    User user = await AuthService.getInitialUser();

    if (user == null) {
      var userCredentials = await AuthService.createAnonymousUser();
      user = userCredentials.user;
    }

    await state.updateUserAndUserPermissions(user);

    List<Trip> trips = await DatabaseService.getTripsForUser(user);
    state.updateTrips(trips);

    DynamicLinkService.handleDynamicLinks();

    return user;
  }
}
