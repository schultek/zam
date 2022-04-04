library models;

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

export '../../main.mapper.g.dart';
export 'group.dart';

@CustomMapper()
class ColorMapper extends SimpleMapper<Color> {
  @override
  Color decode(dynamic value) {
    return Color(int.parse('ff${value.substring(1)}', radix: 16));
  }

  @override
  dynamic encode(Color self) {
    return "#${(self.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}";
  }
}
