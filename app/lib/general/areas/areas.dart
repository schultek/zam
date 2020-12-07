library areas;

import 'package:flutter/material.dart';
import 'package:jufa/general/module/Module.dart';
import 'package:jufa/general/reorderable/reorderable.dart';
import 'package:jufa/general/templates/templates.dart';
import 'package:jufa/general/widgets/widgets.dart';

part 'BodyWidgetArea.dart';

class _InheritedWidgetArea extends InheritedWidget {
  final WidgetAreaState state;

  _InheritedWidgetArea({
    Key key,
    @required this.state,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant _InheritedWidgetArea oldWidget) => true;
}

abstract class WidgetArea<T extends ModuleWidget> extends StatefulWidget {
  final String id;
  WidgetArea(this.id);

  static WidgetAreaState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedWidgetArea>().state;
  }
}

abstract class WidgetAreaState<T extends ModuleWidget> extends State<WidgetArea<T>> with TickerProviderStateMixin, ReorderableService {
  bool _isInitialized = false;
  List<T> selectedWidgets;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    _isInitialized = true;

    var templateState = TripTemplate.of(context);
    this.selectedWidgets = templateState.getWidgetsForArea<T>(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedWidgetArea(
      state: this,
      child: ReorderableList(
        service: this,
        child: buildArea(context),
        decorateItem: (Widget widget, double opacity) {
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
        },
      ),
    );
  }

  Widget buildArea(BuildContext context);

  void removeItem(Key key);

  void addWidget(T widget) {

  }
}

/*


  List<Widget> _addModuleCard(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.only(bottom: 20, top: 0, left: 100, right: 100),
        child: Container(height: 1, color: Colors.black12),
      ),
      Padding(
        padding: EdgeInsets.only(left: 80, right: 80, bottom: 20),
        child: Center(child: FlatButton(
          color: Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            height: 80,
            child: Icon(Icons.add),
          ),
          onPressed: () async {
            var card = await AddModuleCardDialog.open(
                context, allModuleCards.where((card) => !selectedModuleCards.contains(card)).toList());
            if (card != null) {
              addCard(card);
            }
          },
        ),
        ),
      ),
    ];
  }
 */