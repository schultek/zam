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
  List<Widget> moduleSlivers;

  @override
  void initState() {
    super.initState();
    ModuleData moduleData = ModuleData(trip: widget.trip);
    List<ModuleCard> moduleCards = ModuleRegistry.getAllModules().expand((m) => m.getCards(moduleData)).toList();

    moduleSlivers = [];

    List<Widget> currentRow = [];

    for (ModuleCard card in moduleCards) {
      if (card.size == ModuleCardSize.Wide) {
        moduleSlivers.add(SliverPadding(
          padding: EdgeInsets.only(bottom: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([card.build()]),
          ),
        ));
      } else if (card.size == ModuleCardSize.Square) {
        currentRow.add(card.build());
        if (currentRow.length == 2) {
          moduleSlivers.add(SliverPadding(
            padding: EdgeInsets.only(bottom: 20),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              children: currentRow,
            ),
          ));
          currentRow = [];
        }
      }
    }

    if (currentRow.length > 0) {
      moduleSlivers.add(SliverGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: currentRow,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).padding.top);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 20),
                child: Center(
                  child: Text(widget.trip.name, style: Theme.of(context).textTheme.headline5),
                ),
              ),
            ]),
          ),
          ...moduleSlivers
        ],
      ),
    );
  }
}
