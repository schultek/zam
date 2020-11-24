library module;

import 'dart:math';

import 'package:jufa/models/Trip.dart';
import 'package:reflectable/reflectable.dart';
import 'package:flutter/material.dart';

import '../main.reflectable.dart';

// ignore: UNUSED_IMPORT
import 'package:jufa/modules/modules.dart';

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