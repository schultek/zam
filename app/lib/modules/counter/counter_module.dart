library counter_module;

import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../../core/widgets/input_list_tile.dart';
import '../module.dart';

export '../module.dart';

part 'elements/counter_element.dart';

class CounterModule extends ModuleBuilder {
  CounterModule() : super('counter');

  @override
  String getName(BuildContext context) => context.tr.counter;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'counter': CounterElement(),
      };
}
