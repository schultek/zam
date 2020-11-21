import 'package:flutter/material.dart';

import '../general/Module.dart';
import '../models/Trip.dart';

class TripHome extends StatefulWidget {
  final Trip trip;

  TripHome(this.trip);

  @override
  _TripHomeState createState() => _TripHomeState();
}

class _TripHomeState extends State<TripHome> {
  List<Widget> moduleCards;

  @override
  void initState() {
    ModuleData moduleData = ModuleData(trip: widget.trip);
    this.moduleCards = ModuleRegistry.getAllModules().expand((m) => m.getCards(moduleData)).map((card) => card.build()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.trip.name, style: Theme.of(context).textTheme.headline5),
            Container(height: 20),
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
                children: moduleCards,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
