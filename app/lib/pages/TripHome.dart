import 'package:flutter/material.dart';
import 'package:jufa/models/Trip.dart';

class TripHome extends StatelessWidget {
  final Trip trip;

  TripHome(this.trip);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(trip.name),
      ),
    );
  }
}
