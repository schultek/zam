import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/trip_bloc.dart';
import '../service/dynamic_link_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthBloc());
  locator.registerLazySingleton(() => TripBloc());

  locator.registerSingletonAsync(() => Firebase.initializeApp());
  locator.registerSingletonAsync(
    () async => DynamicLinkService()..setup(),
    dependsOn: [FirebaseApp],
  );
}
