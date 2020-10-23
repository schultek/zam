import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/DatabaseService.dart';
import '../models/Trip.dart';

import 'NoTrip.dart';
import 'TripHome.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Trip trip = Provider.of<DatabaseService>(context).trip;
    if (trip != null) {
      return TripHome(trip);
    } else {
      return NoTrip();
    }
  }
}
