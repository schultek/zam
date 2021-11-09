import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

//ignore: unused_import
import 'modules/modules.dart';
import 'providers/links/links_provider.dart';
import 'providers/trips/selected_trip_provider.dart';
import 'providers/trips/trips_provider.dart';
import 'screens/loading/loading_link_screen.dart';
import 'screens/loading/loading_screen.dart';
import 'screens/no_trip/no_trip_screen.dart';
import 'screens/signin/signin_screen.dart';
import 'screens/trip/trip_screen.dart';
import 'widgets/nested_will_pop_scope.dart';

void main() {
  runApp(const ProviderScope(child: InheritedConsumer(child: JufaApp())));
}

class JufaApp extends StatefulWidget {
  const JufaApp({Key? key}) : super(key: key);

  @override
  _JufaAppState createState() => _JufaAppState();
}

class _JufaAppState extends State<JufaApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jufa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, _) {
        return Consumer(
          builder: (context, ref, _) {
            var isLoadingTrips = ref.watch(isLoadingTripsProvider);
            var isLoadingLink = ref.watch(isLoadingLinkProvider);
            var isProcessingLink = ref.watch(isProcessingLinkProvider);
            var selectedTrip = ref.watch(selectedTripProvider);
            var link = ref.watch(linkProvider);

            return NestedWillPopScope(
              onWillPop: () async => !(await _navigatorKey.currentState?.maybePop() ?? true),
              child: Navigator(
                key: _navigatorKey,
                restorationScopeId: 'nav',
                pages: [
                  if (isProcessingLink)
                    LoadingLinkScreen.page()
                  else if (isLoadingTrips || isLoadingLink)
                    LoadingScreen.page()
                  else if (link != null)
                    SignInScreen.page(link)
                  else if (selectedTrip != null)
                    TripScreen.page(selectedTrip)
                  else
                    NoTripScreen.page(),
                ],
                onPopPage: (route, result) => route.didPop(result),
              ),
            );
          },
        );
      },
    );
  }
}
