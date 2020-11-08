import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jufa/general/Module.dart';

import 'CookingPage.dart';
import 'ShoppingPage.dart';

class Supply extends Module {
  @override
  List<ModuleCard> getCards(ModuleData data) {
    return [
      ModuleCard(
        builder: (context) => GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Center(child: Text("Kochen")),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CookingPage()));
          },
        ),
      ),
      ModuleCard(
        builder: (context) => GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Center(child: Text("Kochen")),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShoppingPage()));
          },
        ),
      ),
    ];
  }

}

