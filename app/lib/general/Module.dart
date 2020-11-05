
import 'package:jufa/models/Trip.dart';
import 'package:reflectable/reflectable.dart';
import 'package:flutter/material.dart';

// ignore: UNUSED_IMPORT
import 'package:jufa/modules/modules.dart';

class ModuleReflector extends Reflectable {
  const ModuleReflector(): super(newInstanceCapability, reflectedTypeCapability, typeCapability, typeRelationsCapability, subtypeQuantifyCapability);
}

@ModuleReflector()
abstract class Module {
  List<ModuleCard> getCards(ModuleData data);
}



class ModuleData {
  Trip trip;

  ModuleData({this.trip});
}


class ModuleCard extends StatelessWidget {

  final Widget Function(BuildContext context) builder;

  ModuleCard({this.builder});

  @override
  Widget build(BuildContext context) {
    return this.builder(context);
  }
}