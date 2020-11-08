import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jufa/general/Module.dart';
import 'package:jufa/modules/profile/ProfileModule.dart';

class Supply extends Module {
  @override
  List<ModuleCard> getCards(ModuleData data) {
    return [
      ModuleCard(
        builder: (context) => GestureDetector(
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).primaryColor,
                boxShadow: [BoxShadow(blurRadius: 10)]),
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
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).primaryColor,
                boxShadow: [BoxShadow(blurRadius: 10)]),
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

