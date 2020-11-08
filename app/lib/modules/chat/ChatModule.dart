import 'package:flutter/material.dart';
import 'package:jufa/general/Module.dart';

class Chat extends Module {
  @override
  List<ModuleCard> getCards(ModuleData context) {
    return [
      ModuleCard(
        builder: (context) => Container(
          padding: EdgeInsets.all(10),
          child: Center(child: Text("Chat")),
        ),
      ),
    ];
  }
}
