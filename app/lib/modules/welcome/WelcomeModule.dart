import 'package:flutter/material.dart';

import '../../general/module/Module.dart';

class WelcomeModule extends Module {
  @override
  List<ModuleCard> getCards(ModuleData context) {
    return [
      ModuleCard("welcome",
        size: CardSize.Wide,
        builder: (context) => Container(
          padding: EdgeInsets.all(10),
          child: Center(child: Text("Welcome")),
        ),
      ),
    ];
  }
}
