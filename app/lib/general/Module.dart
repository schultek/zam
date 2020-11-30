library module;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'dart:collection';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:ui' show lerpDouble;

import 'package:reflectable/reflectable.dart';
import '../main.reflectable.dart';

// ignore: UNUSED_IMPORT
import '../modules/modules.dart';
import '../models/Trip.dart';

part 'ModuleRegistry.dart';
part 'ModuleCard.dart';
part 'ModuleRoute.dart';
part 'ModuleGrid.dart';
part 'Reorderable.dart';

class ModuleReflector extends Reflectable {
  const ModuleReflector()
      : super(newInstanceCapability, reflectedTypeCapability, typeCapability, typeRelationsCapability, subtypeQuantifyCapability);
}

@ModuleReflector()
abstract class Module {
  List<ModuleCard> getCards(ModuleData data);
}