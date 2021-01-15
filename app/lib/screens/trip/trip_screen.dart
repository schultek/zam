import 'package:flutter/material.dart';

import '../../general/module/module.dart';
import '../../general/templates/templates.dart';
import '../../models/models.dart';

class TripScreen extends StatelessWidget {
  final Trip trip;
  const TripScreen(this.trip);

  @override
  Widget build(BuildContext context) {
    return BasicTemplate(ModuleData(trip: trip));
  }
}
