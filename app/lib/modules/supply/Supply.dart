import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

import '../../general/Module.dart';
import 'CookingPage.dart';
import 'ShoppingPage.dart';
import 'SupplyRepository.dart';

class Supply extends Module {
  @override
  List<ModuleCard> getCards(ModuleData data) {
    return [
      ModuleCard(
        builder: (context) => GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Stack(
              children: [
                Positioned.fill(child: CookingPot()),
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(child: Text("Kochen", style: TextStyle(color: Colors.black45))),
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SupplyProvider(tripId: data.trip.id, child: CookingPage())));
          },
        ),
      ),
      ModuleCard(
        builder: (context) => GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Center(child: Text("Einkaufen")),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SupplyProvider(tripId: data.trip.id, child: ShoppingPage())));
          },
        ),
      ),
    ];
  }

}

class CookingPot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Artboard>(
      future: rootBundle.load('lib/assets/animations/cookingpot.riv').then((data) async {
        var file = RiveFile();
        file.import(data);

        var artboard = file.mainArtboard;

        artboard.addController(SimpleAnimation("Stir"));
        artboard.addController(SimpleAnimation("Smoke"));

        artboard.originY = -0.12;

        return artboard;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Rive(
            artboard: snapshot.data,
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          );
        } else {
          return Container();
        }
      },
    );
  }
}

