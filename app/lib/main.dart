import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  runApp(const ProviderScope(child: JufaApp()));
}

class JufaApp extends StatefulWidget {
  const JufaApp();

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
          builder: (context, watch, _) {
            var isLoadingTrips = watch(isLoadingTripsProvider);
            var isLoadingLink = watch(isLoadingLinkProvider);
            var isProcessingLink = watch(isProcessingLinkProvider);
            var selectedTrip = watch(selectedTripProvider);
            var link = watch(linkProvider);

            return NestedWillPopScope(
              onWillPop: () async => !(await _navigatorKey.currentState?.maybePop() ?? true),
              child: Navigator(
                key: _navigatorKey,
                restorationScopeId: 'nav',
                pages: [
                  if (isLoadingTrips || isLoadingLink)
                    LoadingScreen.page()
                  else if (isProcessingLink)
                    LoadingLinkScreen.page()
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
