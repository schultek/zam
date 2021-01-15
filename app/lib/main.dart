// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'general/module/module.dart';
import 'models/models.dart';
import 'providers/app_state.dart';
import 'screens/loading/loading_screen.dart';
import 'screens/no_trip/no_trip_screen.dart';
import 'screens/trip/trip_screen.dart';
import 'service/auth_service.dart';
import 'service/dynamic_link_service.dart';

void main() {
  ModuleRegistry.registerModules();
  runApp(ChangeNotifierProvider<AppState>(
    create: (context) => AppState(),
    builder: (context, _) {
      var state = Provider.of<AppState>(context, listen: false);
      return JufaApp(state);
    },
  ));
}

class JufaApp extends StatefulWidget {
  final AppState state;
  const JufaApp(this.state);

  @override
  _JufaAppState createState() => _JufaAppState();
}

class _JufaAppState extends State<JufaApp> {
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    initApp(widget.state).then((_) => setState(() => isLoaded = true));
  }

  Future<void> initApp(AppState state) async {
    await Firebase.initializeApp();

    User? user = await AuthService.getInitialUser();

    if (user == null) {
      var userCredentials = await AuthService.createAnonymousUser();
      user = userCredentials.user;
    }

    print(user.uid);

    await state.updateUser(user);
    state.initUserSubscription();

    await DynamicLinkService.handleDynamicLinks();
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
      body: Selector<AppState, Trip?>(
        selector: (context, state) => state.getSelectedTrip(),
        builder: (BuildContext context, Trip? trip, _) {
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
                    String link = await DynamicLinkService.createAdminLink();
                    Share.share("Über den folgenden Link wirst du Admin in der Jufa App: $link");
                  },
                ),
                SpeedDialChild(
                  backgroundColor: Colors.grey.shade600,
                  child: const Icon(Icons.add_link),
                  label: "Organisator-Link erstellen",
                  onTap: () async {
                    String link = await DynamicLinkService.createTripCreatorLink();
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
