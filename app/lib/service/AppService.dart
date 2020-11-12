import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../providers/AppState.dart';

import 'AuthService.dart';
import 'DynamicLinkService.dart';

class AppService {
  static Future<void> initApp(AppState state) async {
    await Firebase.initializeApp();

    User user = await AuthService.getInitialUser();

    if (user == null) {
      var userCredentials = await AuthService.createAnonymousUser();
      user = userCredentials.user;
    }

    await state.updateUser(user);
    state.initUserSubscription();

    DynamicLinkService.handleDynamicLinks();
  }
}
