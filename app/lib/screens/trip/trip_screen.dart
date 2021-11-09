import 'package:flutter/material.dart';

import '../../models/models.dart';

class TripScreen extends StatelessWidget {
  final Trip trip;
  const TripScreen(this.trip, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => trip.template.builder();

  static Route route(Trip trip) {
    return MaterialPageRoute(builder: (context) => TripScreen(trip));
  }

  static MaterialPage page(Trip trip) {
    return MaterialPage(child: TripScreen(trip));
  }
}
