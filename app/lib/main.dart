import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'general/ModuleRegistry.dart';
import 'models/Trip.dart';
import 'service/AppService.dart';
import 'providers/AppState.dart';
import 'pages/TripHome.dart';
import 'pages/NoTrip.dart';

void main() {
  ModuleRegistry.registerModules();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AppState>(create: (context) => AppState()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jufa',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
          future: AppService.initApp(Provider.of<AppState>(context, listen: false)),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Selector<AppState, Trip>(
                selector: (context, state) => state.getSelectedTrip(),
                shouldRebuild: (previous, next) => previous == null || next == null || previous.id != next.id,
                builder: (BuildContext context, Trip trip, _) {
                  if (trip != null) {
                    return TripHome(trip);
                  } else {
                    return NoTrip();
                  }
                },
              );
            } else {
              return LoadingScreen();
            }
          }),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).primaryColor,
      child: Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      ),
    );
  }
}
