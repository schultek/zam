library templates;

import 'package:flutter/material.dart';

import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_dart/math/mat2d.dart';

import 'package:jufa/general/areas/areas.dart';
import 'package:jufa/general/module/Module.dart';

part 'ReorderToggle.dart';
part 'BasicTemplate.dart';

class _InheritedTripTemplate extends InheritedWidget {
  final TripTemplateState state;

  _InheritedTripTemplate({
    Key key,
    @required this.state,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant _InheritedTripTemplate oldWidget) => true;
}

abstract class TripTemplate extends StatefulWidget {
  final String id;
  final ModuleData moduleData;
  TripTemplate(this.id, this.moduleData);

  Widget build(BuildContext context);

  @override
  State<StatefulWidget> createState() => TripTemplateState();

  static TripTemplateState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedTripTemplate>().state;
  }
}

class TripTemplateState extends State<TripTemplate> with TickerProviderStateMixin {
  AnimationController _transitionController;
  AnimationController _wiggleController;

  bool _isEditing = false;

  List<ModuleWidgetFactory> widgetFactories;

  PersistentBottomSheetController _bottomSheetController;

  WidgetAreaState selectedArea;

  Animation<double> get transition => _transitionController.view;
  Animation<double> get wiggle => _wiggleController.view;

  get isEditing => _isEditing;

  @override
  void initState() {
    super.initState();

    _transitionController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _wiggleController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    widgetFactories = ModuleRegistry.getModuleWidgetFactories(widget.moduleData);
  }

  @override
  void dispose() {
    _transitionController.dispose();
    _wiggleController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    if (this._isEditing) {
      _finishEdit();
    } else {
      _beginEdit();
    }
  }

  void _beginEdit() {
    setState(() {
      _isEditing = true;
    });
    _wiggleController.repeat();
    _transitionController.forward();

  }

  void _finishEdit() {
    _isEditing = false;
    _transitionController.reverse().whenComplete(() {
      _wiggleController.stop();
      //updateIndices();
      setState(() {});
    });

    if (_bottomSheetController != null) {
      _bottomSheetController.close();
      _bottomSheetController = null;
    }
  }

  List<T> getWidgetsForArea<T extends ModuleWidget>(String areaId) {
    //allModuleCards.where((card) => moduleData.trip.modules.contains(card.id)).toList()
    //  ..sort((a, b) => moduleData.trip.modules.indexOf(a.id) - moduleData.trip.modules.indexOf(b.id));
    return widgetFactories.where((f) => f.type == T).map((f) => f.getWidget() as T).toList();
  }

  void selectArea<T extends ModuleWidget>(WidgetAreaState<T> area) {
    this.selectedArea = area;
    List<T> widgets = widgetFactories.where((f) => f.type == T).map((f) => f.getWidget() as T).toList();

    _bottomSheetController = Scaffold.of(context).showBottomSheet(
      (context) => buildBottomSheetForModuleWidgets(context, widgets),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    );
  }

  void addWidgetToSelectedArea<T extends ModuleWidget>(T widget) {
    if (this.selectedArea != null) {
      this.selectedArea.addWidget(widget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedTripTemplate(state: this, child: widget.build(context));
  }

  Widget buildBottomSheetForModuleWidgets<T extends ModuleWidget>(BuildContext context, List<T> widgets) {
    return Container(
      height: 100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widgets.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: GestureDetector(
                  child: AbsorbPointer(child: widgets[index]),
                  onTap: ()=> addWidgetToSelectedArea(widgets[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}
