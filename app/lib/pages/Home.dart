import 'package:flutter/material.dart';

import 'NoTrip.dart';
import 'TripHome.dart';

class Home extends StatelessWidget {
  final bool tripExists = false;
  @override
  Widget build(BuildContext context) {
    if(tripExists) {
      return TripHome();
    } else {
      return NoTrip();
    }
  }
}