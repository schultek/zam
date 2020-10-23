import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/Trip.dart';

import 'AuthService.dart';
import 'DatabaseService.dart';
import 'DynamicLinkService.dart';

class AppService {
  static Future<User> initApp() async {
    await Firebase.initializeApp();

    User user = await AuthService.getInitialUser();

    if (user == null) {
      var userCredentials = await AuthService.createAnonymousUser();
      user = userCredentials.user;
    }

    List<Trip> tripsForUser = await DatabaseService.getTripsForUser(user);
    print(tripsForUser);

    DynamicLinkService.handleDynamicLinks();

    return user;
  }
}
