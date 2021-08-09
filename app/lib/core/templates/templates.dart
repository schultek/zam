library templates;

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/trips/logic_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../areas/areas.dart';
import '../module/module.dart';
import '../module/module.g.dart';
import '../themes/themes.dart';
import '../widgets/reorder_toggle.dart';
import '../widgets/template_navigator.dart';
import '../widgets/widget_selector.dart';

part 'grid/grid_template.dart';
part 'swipe/swipe_template.dart';
part 'swipe/swipe_template_settings.dart';

@MappableClass(discriminatorKey: 'type')
abstract class TemplateModel {
  String type;
  TemplateModel(this.type);

  String get name;
  WidgetTemplate builder();
}

class InheritedWidgetTemplate extends InheritedWidget {
  final WidgetTemplateState state;

  const InheritedWidgetTemplate({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidgetTemplate oldWidget) => true;
}

abstract class WidgetTemplate<T extends TemplateModel> extends StatefulWidget {
  final T config;
  const WidgetTemplate(this.config);

  Widget build(BuildContext context, WidgetTemplateState state);

  void onEdit(WidgetTemplateState state) {}

  @override
  State<StatefulWidget> createState() => WidgetTemplateState();

  static WidgetTemplateState of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<InheritedWidgetTemplate>()!.state;
    } else {
      var element = context.getElementForInheritedWidgetOfExactType<InheritedWidgetTemplate>()!;
      return (element.widget as InheritedWidgetTemplate).state;
    }
  }
}

class WidgetTemplateState extends State<WidgetTemplate> with TickerProviderStateMixin {
  late AnimationController _transitionController;
  late AnimationController _wiggleController;

  bool _isEditing = false;

  final Map<String, WidgetAreaState> widgetAreas = {};
  String? _selectedArea;
  WidgetSelectorController? widgetSelector;

  Animation<double> get transition => _transitionController.view;
  Animation<double> get wiggle => _wiggleController.view;

  bool get isEditing => _isEditing;
  String? get selectedArea => _selectedArea;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _wiggleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _transitionController.dispose();
    _wiggleController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    if (_isEditing) {
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
    widget.onEdit(this);
  }

  void _finishEdit() {
    _isEditing = false;
    _transitionController.reverse().whenComplete(() {
      _wiggleController.stop();
      //updateIndices();
      setState(() {});
    });

    _unselectArea();
  }

  List<T> getWidgetsForArea<T extends ModuleElement>(String areaId) {
    var selectedModules = context.read(areaModulesProvider(areaId));
    return selectedModules
        .map((id) => registry.getWidget(context, id))
        .where((e) => e != null && e is T)
        .cast<T>()
        .toList();
  }

  void selectWidgetArea<T extends ModuleElement>(WidgetAreaState<WidgetArea<T>, T>? area) {
    selectWidgetAreaById<T>(area?.id);
  }

  void selectWidgetAreaById<T extends ModuleElement>(String? id) {
    if (!isEditing) return;
    if (_selectedArea == id) {
      return;
    } else if (_selectedArea != null) {
      _unselectArea();
    }

    if (id == null) return;

    _selectedArea = id;

    setState(() {});

    if (widgetAreas[selectedArea]?.mounted ?? false) {
      widgetSelector = WidgetSelector.show<T>(this);
    }
  }

  void _unselectArea() {
    _selectedArea = null;

    if (widgetSelector != null) {
      widgetSelector!.close();
      widgetSelector = null;
    }

    setState(() {});
  }

  void registerArea(WidgetAreaState area) {
    widgetAreas[area.id] = area;
  }

  void onWidgetRemoved<T extends ModuleElement>(WidgetAreaState<WidgetArea<T>, T> area, T widget) {
    if (widgetSelector != null && widgetSelector!.isForArea(area)) {
      if (widget.id.split('/').length < 3) {
        // Don't add specialized widgets
        widgetSelector!.state!.addWidget(null, widget);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetTemplate(
      state: this,
      child: widget.build(context, this),
    );
  }
}
