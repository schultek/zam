import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/Trip.dart';
import 'service/AppService.dart';
import 'providers/AppState.dart';
import 'service/DatabaseService.dart';
import 'pages/TripHome.dart';
import 'pages/NoTrip.dart';

void main() {
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
              return Consumer<AppState>(builder: (BuildContext context, AppState state, _) {
                if (state.trips.isNotEmpty) {
                  return TripHome(state.trips.first, "");
                } else {
                  return NoTrip();
                }
              });
            } else {
              return Container();
            }
          }),
    );
  }
}
