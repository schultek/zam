import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/NoTrip.dart';
import 'pages/TripHome.dart';
import 'service/AuthService.dart';

void main() async {
  runApp(MyApp());

  await Firebase.initializeApp();

  if (AuthService.getUser() == null) {
    AuthService.signIn("+49 1578 7693846");
  }
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
