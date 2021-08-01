import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/trip_bloc.dart';
import 'core/module/module.dart';
import 'helpers/locator.dart';
import 'screens/loading/loading_screen.dart';
import 'screens/no_trip/no_trip_screen.dart';
import 'screens/signin/signin_screen.dart';
import 'screens/trip/trip_screen.dart';

// TODOS:
/*

TODOS:

Basic Template Theme (Light, basic)
Template Settings
Hide testing modules
Add Welcome Module


 */

void main() {
  setupLocator();
  ModuleRegistry.registerModules();
  runApp(const JufaApp());
}

class JufaApp extends StatefulWidget {
  const JufaApp();

  @override
  _JufaAppState createState() => _JufaAppState();
}

class _JufaAppState extends State<JufaApp> {
  bool isLoaded = false;

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    locator.allReady().whenComplete(() => setState(() => isLoaded = true));
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return MaterialApp(
        home: LoadingScreen(),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<AuthBloc>()),
        BlocProvider(create: (context) => locator<TripBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (currState, nextState) => currState.invitationLink != nextState.invitationLink,
            listener: (context, state) {
              if (state.invitationLink != null) {
                if (state.invitationLink!.path.endsWith('/organizer') ||
                    state.invitationLink!.path.endsWith('/admin')) {
                  _navigatorKey.currentState!.pushAndRemoveUntil(
                    SignInScreen.route(state.invitationLink!),
                    (route) => false,
                  );
                }
              } else {
                _handleTripState(locator<TripBloc>().state);
              }
            },
          ),
          BlocListener<TripBloc, TripState>(
            listenWhen: (currState, nextState) =>
                currState.selectedTripId != nextState.selectedTripId || (currState.trips == null),
            listener: (context, state) {
              if (locator<AuthBloc>().state.invitationLink != null) {
                return;
              }
              _handleTripState(state);
            },
          ),
        ],
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Jufa',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          home: LoadingScreen(),
        ),
      ),
    );
  }

  void _handleTripState(TripState state) {
    if (state.selectedTrip != null) {
      _navigatorKey.currentState!.pushAndRemoveUntil(
        TripScreen.route(state.selectedTrip!),
        (route) => false,
      );
    } else {
      _navigatorKey.currentState!.pushAndRemoveUntil(
        NoTripScreen.route(),
        (route) => false,
      );
    }
  }
}
