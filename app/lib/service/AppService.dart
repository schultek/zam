import 'package:firebase_core/firebase_core.dart';

import 'AuthService.dart';
import 'DynamicLinkService.dart';

class AppService {
  static Future<void> initApp() async {
    await Firebase.initializeApp();

    if (AuthService.getUser() == null) {
      await AuthService.createAnonymousUser();
    }

    String organizerLink = await DynamicLinkService.createOrganizerLink();
    print(organizerLink);

    DynamicLinkService.handleDynamicLinks();
  }
}
