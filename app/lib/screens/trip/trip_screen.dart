import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/trips/selected_trip_provider.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var trip = context.watch(selectedTripProvider)!;
    return trip.template.builder();
  }
}
