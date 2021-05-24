import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'bloc/app_bloc.dart';
import 'core/module/module.dart';
import 'helpers/locator.dart';
import 'screens/loading/loading_screen.dart';
import 'screens/no_trip/no_trip_screen.dart';
import 'screens/trip/trip_screen.dart';
import 'service/dynamic_link_service.dart';

void main() {
  setupLocator();
  ModuleRegistry.registerModules();

  runApp(BlocProvider(
    create: (context) => locator<AppBloc>(),
    child: const JufaApp(),
  ));
}

class JufaApp extends StatefulWidget {
  const JufaApp();

  @override
  _JufaAppState createState() => _JufaAppState();
}

class _JufaAppState extends State<JufaApp> {
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    locator.allReady().whenComplete(() => setState(() => isLoaded = true));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jufa',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(
        color: Colors.white,
        child: AnimatedSwitcher(
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 600),
          child: isLoaded ? AppScreen() : LoadingScreen(),
        ),
      ),
    );
  }
}

class AppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isAdmin = Provider.of<AppState>(context, listen: false).claims.isAdmin;

    return Scaffold(
      body: BlocBuilder<AppBloc, AppState>(
        buildWhen: (oldState, newState) => oldState.getSelectedTrip() != newState.getSelectedTrip(),
        builder: (BuildContext context, AppState state) {
          var trip = state.getSelectedTrip();
          if (trip != null) {
            return TripScreen(trip);
          } else {
            return NoTripScreen();
          }
        },
      ),
      floatingActionButton: isAdmin
          ? SpeedDial(
              backgroundColor: Colors.grey.shade600,
              children: [
                SpeedDialChild(
                  backgroundColor: Colors.grey.shade600,
                  child: const Icon(Icons.supervised_user_circle),
                  label: "Nutzer verwalten",
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminUserManager()));
                  },
                ),
                SpeedDialChild(
                  backgroundColor: Colors.grey.shade600,
                  child: const Icon(Icons.bolt),
                  label: "Admin-Link erstellen",
                  onTap: () async {
                    String link = await locator<DynamicLinkService>().createAdminLink();
                    Share.share("Über den folgenden Link wirst du Admin in der Jufa App: $link");
                  },
                ),
                SpeedDialChild(
                  backgroundColor: Colors.grey.shade600,
                  child: const Icon(Icons.add_link),
                  label: "Organisator-Link erstellen",
                  onTap: () async {
                    String link = await locator<DynamicLinkService>().createTripCreatorLink();
                    Share.share("Über den folgenden Link wirst du Organisator von Freizeiten in der Jufa App: $link");
                  },
                ),
              ],
              child: const Icon(Icons.admin_panel_settings, size: 20),
            )
          : Container(),
    );
  }
}

class AdminUserManager extends StatefulWidget {
  @override
  _AdminUserManagerState createState() => _AdminUserManagerState();
}

class _AdminUserManagerState extends State<AdminUserManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
