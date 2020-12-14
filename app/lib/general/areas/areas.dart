library areas;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jufa/general/module/Module.dart';
import 'package:jufa/general/templates/templates.dart';
import 'package:jufa/general/widgets/widgets.dart';

import '../Extensions.dart';

part 'BodyWidgetArea.dart';

class InheritedWidgetArea extends InheritedWidget {
  final WidgetAreaState state;

  InheritedWidgetArea({
    Key key,
    @required this.state,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidgetArea oldWidget) => true;
}

abstract class WidgetArea<T extends ModuleWidget> extends StatefulWidget {
  final String id;
  WidgetArea(this.id);

  static WidgetAreaState<WidgetArea<T>, T> of<T extends ModuleWidget>(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<InheritedWidgetArea>().state;
    } else {
      return (context.getElementForInheritedWidgetOfExactType<InheritedWidgetArea>().widget as InheritedWidgetArea)
          .state;
    }
  }
}

abstract class WidgetAreaState<U extends WidgetArea<T>, T extends ModuleWidget> extends State<U>
    with TickerProviderStateMixin {
  bool _isInitialized = false;
  List<T> selectedWidgets;

  String get id => widget.id;

  final _areaKey = GlobalKey();
  Size _areaSize;

  Size get areaSize => _areaSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    _isInitialized = true;

    var templateState = WidgetTemplate.of(context, listen: false);
    this.selectedWidgets = templateState.getWidgetsForArea<T>(widget.id);

    this.initAreaState();
  }

  void initAreaState();

  @override
  void dispose() {
    super.dispose();
  }

  void updateAreaSize(_) {
    this._areaSize = (_areaKey.currentContext.findRenderObject() as RenderBox).size;
  }

  @override
  Widget build(BuildContext context) {
    var templateState = WidgetTemplate.of(context, listen: true);
    templateState.registerArea(this);

    var isSelected = templateState.selectedArea == this.id;
    var backgroundColor = Colors.blue.withOpacity(0.05);
    var borderColor = Colors.blue.withOpacity(0.5);

    WidgetsBinding.instance.addPostFrameCallback(updateAreaSize);

    return InheritedWidgetArea(
      state: this,
      child: GestureDetector(
        onTap: () {
          templateState.selectWidgetArea<T>(this);
        },
        child: Container(
          padding: getPadding(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? backgroundColor : Colors.transparent,
            border: Border.all(
              color: isSelected ? borderColor : Colors.transparent,
            ),
          ),
          child: Container(key: _areaKey, child: buildArea(context)),
        ),
      ),
    );
  }

  Widget buildArea(BuildContext context);

  Widget decorateItem(Widget widget, double opacity) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
          blurRadius: 8,
          spreadRadius: -2,
          color: Colors.black.withOpacity(opacity * 0.5),
        )
      ]),
      child: widget,
    );
  }

  EdgeInsetsGeometry getPadding() {
    return EdgeInsets.all(10);
  }

  BoxConstraints constrainWidget(T widget);

  void removeWidget(Key key) {
    setState(() {
      var widget = getWidgetFromKey(key);

      var templateState = WidgetTemplate.of(context, listen: false);
      templateState.onWidgetRemoved(this, widget);

      this.onWidgetRemoved(key);
    });
  }

  Offset get areaOffset => (_areaKey.currentContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero);

  T getWidgetFromKey(Key key);
  void onWidgetRemoved(Key key);

  bool onDrag(Key key);
  bool checkDropPosition(Offset offset, T item);
  void onDrop();
  void cancelDrop(Key key);
}
