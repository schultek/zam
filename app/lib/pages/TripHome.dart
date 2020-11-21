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
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(widget.trip.name, style: Theme.of(context).textTheme.headline5),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          crossAxisCount: 2,
          children: moduleCards,
        ),
      ],
    );
  }
}
