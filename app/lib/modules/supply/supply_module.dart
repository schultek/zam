import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rive/rive.dart';

import '../../bloc/trip_bloc.dart';
import '../../core/module/module.dart';
import 'cooking/cooking_screen.dart';
import 'shopping/shopping_screen.dart';
import 'supply_repository.dart';

@Module()
class SupplyModule {
  @ModuleItem(id: "cooking")
  ContentSegment getCookingCard() {
    return ContentSegment(
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Positioned.fill(child: Container()), //CookingPot()),
            const Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(child: Text("Kochen")),
            )
          ],
        ),
      ),
      onNavigate: (context) => SupplyProvider(tripId: context.trip!.id, child: CookingScreen()),
    );
  }

  @ModuleItem(id: "shopping")
  ContentSegment getShoppingCard() {
    return ContentSegment(
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: const Center(child: Text("Einkaufen")),
      ),
      onNavigate: (context) => SupplyProvider(tripId: context.trip!.id, child: ShoppingPage()),
    );
  }
}

class CookingPot extends StatefulWidget {
  @override
  _CookingPotState createState() => _CookingPotState();
}

class _CookingPotState extends State<CookingPot> {
  static Future<Artboard> animationFuture = rootBundle.load('assets/animations/cookingpot.riv').then((data) async {
    var file = RiveFile.import(data);

    var artboard = file.mainArtboard;

    artboard.addController(SimpleAnimation("Stir"));
    artboard.addController(SimpleAnimation("Smoke"));

    artboard.originY = -0.12;

    return artboard;
  });

  static Artboard? artboard;

  @override
  void initState() {
    super.initState();
    if (artboard == null) {
      loadAnimation();
    }
  }

  Future<void> loadAnimation() async {
    artboard = await animationFuture;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (artboard != null) {
      return Rive(
        artboard: artboard!,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      );
    } else {
      return Container();
    }
  }
}
