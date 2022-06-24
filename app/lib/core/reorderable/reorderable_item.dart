import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../elements/module_element.dart';
import 'drag_provider.dart';
import 'items_provider.dart';

enum ReorderableState { normal, placeholder, dragging }

typedef DecorationBuilder = Widget Function(BuildContext context, Widget widget, double opacity);
typedef ReorderableBuilder = Widget Function(BuildContext context, ReorderableState state, Widget child);

class ReorderableItem extends StatefulWidget {
  const ReorderableItem({
    required this.itemKey,
    required this.builder,
    required this.decorationBuilder,
    required this.child,
    Key? key,
  }) : super(key: key);

  final ModuleElementKey itemKey;
  final Widget child;
  final ReorderableBuilder builder;
  final DecorationBuilder decorationBuilder;

  @override
  ReorderableItemState createState() => ReorderableItemState();
}

class ReorderableItemState extends State<ReorderableItem> {
  late ReorderableItemLogic logic;

  Key get key => widget.itemKey;

  @override
  void initState() {
    super.initState();
    logic = context.read(reorderableItemProvider);
    logic.register(this);
  }

  @override
  void didUpdateWidget(ReorderableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (context.read(isDraggingProvider(key))) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        context.read(dragWidgetProvider.state).state = widget.builder(context, ReorderableState.dragging, widget.child);
      });
    }
  }

  @override
  void dispose() {
    logic.unregister(this);
    super.dispose();
  }

  Widget buildChild(ReorderableState state) {
    return widget.builder(context, state, widget.child);
  }

  @override
  Widget build(BuildContext context) {
    logic.update(this);
    var isDragging = context.watch(isDraggingProvider(key));
    var animation = context.watch(itemAnimationProvider(key));
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform(
        transform: Matrix4.translationValues(animation.value.dx, animation.value.dy, 0.0),
        child: child,
      ),
      child: isDragging
          ? SizedBox.fromSize(
              size: context.read(dragSizeProvider.state).state,
              child: buildChild(ReorderableState.placeholder),
            )
          : buildChild(ReorderableState.normal),
    );
  }
}
