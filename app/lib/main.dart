import 'package:flutter/material.dart';

import 'pages/NoTrip.dart';
import 'pages/TripHome.dart';
import 'service/AuthService.dart';

void main() {

  if (AuthService.getUser() == null) {
    AuthService.signIn("015225125923");
  }


  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  final bool tripExists = false;

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (tripExists) {
      home = TripHome();
    } else {
      home = TripAdd();
    }

    return MaterialApp(
      title: 'Jufa',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: home,
    );
  }
}
