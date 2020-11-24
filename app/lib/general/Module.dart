library module;

import 'dart:math';

import 'package:reflectable/reflectable.dart';
import 'package:flutter/material.dart';

import '../main.reflectable.dart';

// ignore: UNUSED_IMPORT
import '../modules/modules.dart';
import '../models/Trip.dart';

part 'ModuleRegistry.dart';
part 'ModuleCard.dart';
part 'ModuleRoute.dart';

class ModuleReflector extends Reflectable {
  const ModuleReflector()
      : super(newInstanceCapability, reflectedTypeCapability, typeCapability, typeRelationsCapability, subtypeQuantifyCapability);
}

@ModuleReflector()
abstract class Module {
  List<ModuleCard> getCards(ModuleData data);
}