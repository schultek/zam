import 'package:flutter/material.dart';
import 'package:jufa/general/templates/templates.dart';

import '../../general/module/Module.dart';
import '../../models/Trip.dart';

class TripHome extends StatelessWidget {
  final Trip trip;

  TripHome(this.trip);

  @override
  Widget build(BuildContext context) {
    return BasicTemplate(ModuleData(trip: trip));
  }
}
