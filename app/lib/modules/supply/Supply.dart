import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jufa/general/widgets/widgets.dart';
import 'package:rive/rive.dart';

import '../../general/module/Module.dart';
import 'shopping/ShoppingPage.dart';
import 'cooking/CookingPage.dart';
import 'SupplyRepository.dart';

@Module()
class SupplyModule {

  ModuleData moduleData;
  SupplyModule(this.moduleData);

  @ModuleItem(id: "cooking")
  BodySegment getCookingCard() {
    return BodySegment(
      builder: (context) =>
          Container(
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
      onNavigate: (context) => SupplyProvider(tripId: moduleData.trip.id, child: CookingPage()),
    );
  }

  @ModuleItem(id: "shopping")
  BodySegment getShoppingCard() {
     return BodySegment(
        builder: (context) => Container(
          padding: EdgeInsets.all(10),
          child: Center(child: Text("Einkaufen")),
        ),
        onNavigate: (context) => SupplyProvider(tripId: moduleData.trip.id, child: ShoppingPage()),
      );
  }
}

class CookingPot extends StatefulWidget {
  @override
  _CookingPotState createState() => _CookingPotState();
}

class _CookingPotState extends State<CookingPot> {
  static Future<Artboard> animationFuture = rootBundle.load('lib/assets/animations/cookingpot.riv').then((data) async {
    var file = RiveFile();
    file.import(data);

    var artboard = file.mainArtboard;

    artboard.addController(SimpleAnimation("Stir"));
    artboard.addController(SimpleAnimation("Smoke"));

    artboard.originY = -0.12;

    return artboard;
  });

  static Artboard artboard;

  @override
  void initState() {
    super.initState();
    if (artboard == null) {
      loadAnimation();
    }
  }

  void loadAnimation() async {
    artboard = await animationFuture;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (artboard != null) {
      return Rive(
        artboard: artboard,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      );
    } else {
      return Container();
    }
  }
}
