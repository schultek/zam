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
  List<ModuleCard> moduleCards;
  ModuleGrid moduleGrid;

  @override
  void initState() {
    super.initState();
    ModuleData moduleData = ModuleData(trip: widget.trip);
    moduleCards = ModuleRegistry.getAllModules().expand((m) => m.getCards(moduleData)).toList();
    moduleGrid = ModuleGrid(moduleCards);
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> moduleSlivers = moduleGrid.buildSlivers();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ReorderableList(
        grid: moduleGrid,
        onReorder: (Key draggedItem, Key newPosition) {
          setState(() {
            moduleGrid.onReorder(draggedItem, newPosition);
          });
          return true;
        },
        decoratePlaceholder: (widget, opacity) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(
                blurRadius: 8,
                color: Colors.black.withOpacity(opacity*0.5),
              )]
            ),
            child: widget,
          );
        },
        onReorderDone: this._onReorderDone,
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
      ),
    );
  }

  void _onReorderDone(Key draggedItem) {
    print("Reordering finished");
  }
}
