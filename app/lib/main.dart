import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

import 'general/Module.dart';
import 'models/Trip.dart';
import 'service/AppService.dart';
import 'providers/AppState.dart';
import 'pages/TripHome.dart';
import 'pages/NoTrip.dart';
import 'service/DynamicLinkService.dart';

void main() {
  ModuleRegistry.registerModules();
  runApp(ChangeNotifierProvider<AppState>(
    create: (context) => AppState(),
    builder: (context, _) {
      var state = Provider.of<AppState>(context, listen: false);
      return MyApp(state);
    },
  ));
}

class MyApp extends StatefulWidget {
  final AppState state;
  MyApp(this.state);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    AppService.initApp(this.widget.state).then((_) => setState(() => isLoaded = true));
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
          duration: Duration(milliseconds: 600),
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
      body: Selector<AppState, Trip>(
        selector: (context, state) => state.getSelectedTrip(),
        builder: (BuildContext context, Trip trip, _) {
          if (trip != null) {
            return TripHome(trip);
          } else {
            return NoTrip();
          }
        },
      ),
      floatingActionButton: isAdmin
          ? SpeedDial(
              child: Icon(Icons.admin_panel_settings, size: 20),
              backgroundColor: Colors.grey.shade600,
              children: [
                SpeedDialChild(
                    backgroundColor: Colors.grey.shade600,
                    child: Icon(Icons.supervised_user_circle),
                    label: "Nutzer verwalten",
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminUserManager()));
                    }),
                SpeedDialChild(
                    backgroundColor: Colors.grey.shade600,
                    child: Icon(Icons.bolt),
                    label: "Admin-Link erstellen",
                    onTap: () async {
                      String link = await DynamicLinkService.createAdminLink();
                      Share.share("Über den folgenden Link wirst du Admin in der Jufa App: $link");
                    }),
                SpeedDialChild(
                    backgroundColor: Colors.grey.shade600,
                    child: Icon(Icons.add_link),
                    label: "Organisator-Link erstellen",
                    onTap: () async {
                      String link = await DynamicLinkService.createTripCreatorLink();
                      Share.share("Über den folgenden Link wirst du Organisator von Freizeiten in der Jufa App: $link");
                    }),
              ],
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

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text("", style: Theme.of(context).textTheme.headline5),
            ),
          ),
          AnimationLimiter(
            child: GridView.count(
              primary: false,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              children: List.generate(6, (int index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  delay: const Duration(milliseconds: 100),
                  columnCount: 2,
                  child: ScaleAnimation(
                    scale: 0.7,
                    child: FadeInAnimation(
                      child: Shimmer.fromColors(
                        baseColor: Colors.black,
                        highlightColor: Colors.black54,
                        child: Material(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: Colors.black12,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
