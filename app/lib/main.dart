import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import 'core/core.dart';
//ignore: unused_import
import 'core/widgets/trip_selector_page.dart';
import 'providers/auth/user_provider.dart';
import 'providers/general/loading_provider.dart';
import 'providers/links/links_provider.dart';
import 'providers/trips/selected_trip_provider.dart';
import 'screens/loading/loading_link_screen.dart';
import 'screens/loading/loading_screen.dart';
import 'screens/signin/signin_screen.dart';
import 'screens/trip/trip_screen.dart';

void main() {
  runApp(const ProviderScope(child: InheritedConsumer(child: JufaApp())));
}

class JufaApp extends StatefulWidget {
  const JufaApp({Key? key}) : super(key: key);

  @override
  _JufaAppState createState() => _JufaAppState();
}

class _JufaAppState extends State<JufaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jufa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: GlobalKey(),
      home: buildHome(context),
    );
  }

  Widget buildHome(BuildContext context) {
    var isLoading = context.watch(isLoadingProvider);
    if (isLoading) {
      return const LoadingScreen();
    }

    var isProcessingLink = context.watch(isProcessingLinkProvider);
    if (isProcessingLink) {
      return const LoadingLinkScreen();
    }

    var isSignedIn = context.watch(isSignedInProvider);
    if (!isSignedIn) {
      return const SignInScreen();
    }

    var selectedTrip = context.watch(selectedTripProvider);
    if (selectedTrip != null) {
      return TripScreen(selectedTrip, key: ValueKey(selectedTrip.id));
    }

    return TripTheme(theme: TripThemeData(FlexScheme.material, true), child: const TripSelectorPage());
  }
}
