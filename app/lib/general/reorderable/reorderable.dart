library reorderable;

import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:jufa/general/widgets/widgets.dart';
import 'package:tuple/tuple.dart';

part 'ReorderableItem.dart';
part 'ReorderableList.dart';
part 'ReorderableListener.dart';
part 'DragProxy.dart';

// Can be used to cancel reordering (i.e. when underlying data changed)
class CancellationToken {
  void cancelDragging() {
    for (final c in _callbacks) {
      c();
    }
  }
  final _callbacks = List<VoidCallback>();
}

enum ReorderableItemState {
  normal,
  placeholder,
  dragProxy,
  dragProxyFinished
}

abstract class ReorderableService {
  void onReorderDone(Key draggedItem) {}
  bool checkDragPosition({offset, Offset itemOffset, Size itemSize, Key itemKey, ReorderableListState listState});
}

