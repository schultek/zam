import 'package:flutter/material.dart';

import 'pages/TripAdd.dart';
import 'pages/TripHome.dart';

void main() {
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
