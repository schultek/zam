import 'package:flutter/material.dart';

import '../../core/core.dart';

class TripScreen extends StatelessWidget {
  final Trip trip;
  const TripScreen(this.trip, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => trip.template.builder();
}
