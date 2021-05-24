import 'package:flutter/material.dart';

import '../templates/templates.dart';
import 'reorderable_manager.dart';

enum ReorderableState { normal, placeholder, dragging }

class ReorderableItem extends StatefulWidget {
  const ReorderableItem({
    required Key key,
    required this.builder,
    required this.decorationBuilder,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final Widget Function(BuildContext context, ReorderableState state, Widget child) builder;
  final Widget Function(Widget widget, double opacity) decorationBuilder;

  @override
  ReorderableItemState createState() => ReorderableItemState();
}

class ReorderableItemState extends State<ReorderableItem> {
  ReorderableManager? _manager;

  Key get key => widget.key!;

  @override
  Widget build(BuildContext context) {
    _manager = WidgetTemplate.of(context, listen: false).reorderable;
    _manager!.registerItem(this);

    Widget child;
    if (_manager!.dragging == key) {
      child = SizedBox.fromSize(
        size: _manager!.dragSize,
        child: widget.builder(context, ReorderableState.placeholder, widget.child),
      );
    } else {
      child = widget.builder(context, ReorderableState.normal, widget.child);
    }

    Offset translation = _manager!.itemTranslation(key);
    return Transform(
      transform: Matrix4.translationValues(translation.dx, translation.dy, 0.0),
      child: child,
    );
  }

  @override
  void didUpdateWidget(ReorderableItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    _manager = WidgetTemplate.of(context, listen: false).reorderable;
    if (_manager!.dragging == key) {
      _manager!.draggedItemWidgetUpdated();
    }
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    _manager?.unregisterItem(this);
    _manager = null;
    super.deactivate();
  }
}
