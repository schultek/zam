import 'package:flutter/material.dart';
import 'package:jufa/general/Module.dart';
import 'package:jufa/general/ModuleRegistry.dart';
import 'package:jufa/service/AuthService.dart';

import '../models/Trip.dart';
import '../modules/userManagement/UserManagementModule.dart';


class TripHome extends StatelessWidget {
  final Trip trip;

  TripHome(this.trip);

  @override
  Widget build(BuildContext context) {

    ModuleData moduleData = ModuleData(trip: this.trip);
    List<ModuleCard> moduleCards = ModuleRegistry.getAllModules()
      .expand((m) => m.getCards(moduleData))
      .toList();

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(trip.name, style: Theme.of(context).textTheme.headline5),
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
        ),
      ),
    );
  }
}
