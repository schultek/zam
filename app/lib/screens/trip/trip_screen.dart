import 'package:flutter/material.dart';

import '../../core/module/module.dart';
import '../../models/models.dart';

class TripScreen extends StatelessWidget {
  final Trip trip;
  const TripScreen(this.trip);

  @override
  Widget build(BuildContext context) {
    return trip.template.builder(ModuleData(trip: trip));
  }

  static Route route(Trip trip) {
    return MaterialPageRoute(builder: (context) => TripScreen(trip));
  }
}
