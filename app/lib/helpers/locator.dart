import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import '../bloc/app_bloc.dart';
import '../service/auth_service.dart';
import '../service/dynamic_link_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingletonAsync(() => Firebase.initializeApp());

  locator.registerSingletonAsync(() async {
    User? user = await AuthService.getInitialUser();

    if (user == null) {
      var userCredentials = await AuthService.createAnonymousUser();
      user = userCredentials.user;
    }

    print('LOADED USER: ${user!.uid}');

    var appBloc = AppBloc(user);
    await appBloc.stream.first;

    return appBloc;
  }, dependsOn: [FirebaseApp]);

  locator.registerSingletonAsync(
    () async => DynamicLinkService()..setup(),
    dependsOn: [AppBloc],
  );
}
