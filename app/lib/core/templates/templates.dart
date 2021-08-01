library templates;

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../bloc/trip_bloc.dart';
import '../areas/areas.dart';
import '../module/module.dart';
import '../reorderable/reorderable_manager.dart';
import '../themes/themes.dart';
import '../widgets/reorder_toggle.dart';
import '../widgets/template_navigator.dart';
import '../widgets/widget_selector.dart';

part 'grid_template.dart';
part 'swipe_template.dart';

@MappableClass(discriminatorKey: 'type')
abstract class TemplateModel {
  String type;
  TemplateModel(this.type);

  String get name;
  WidgetTemplate builder(ModuleData moduleData);
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
  final ModuleData moduleData;
  const WidgetTemplate(this.config, this.moduleData);

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

  late List<ModuleWidgetFactory> widgetFactories;

  final Map<String, WidgetAreaState> widgetAreas = {};
  String? _selectedArea;
  WidgetSelectorController? widgetSelector;

  Animation<double> get transition => _transitionController.view;
  Animation<double> get wiggle => _wiggleController.view;

  bool get isEditing => _isEditing;
  String? get selectedArea => _selectedArea;

  late ReorderableManager _reorderableManager;
  ReorderableManager get reorderable => _reorderableManager;

  @override
  void initState() {
    super.initState();

    _transitionController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _wiggleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    widgetFactories = ModuleRegistry.getModuleWidgetFactories(widget.moduleData);
    _reorderableManager = ReorderableManager(this);
  }

  @override
  void dispose() {
    _transitionController.dispose();
    _wiggleController.dispose();
    _reorderableManager.dispose();
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
    var selectedModules = context.trip!.modules[areaId];
    var selectedFactories = widgetFactories
        .where((f) => f.type == T && (selectedModules == null || selectedModules.contains(f.id)))
        .toList();
    if (selectedModules != null) {
      selectedFactories.sort((a, b) => selectedModules.indexOf(a.id) - selectedModules.indexOf(b.id));
    }
    return selectedFactories.map((f) => f.getWidget() as T).toList();
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
      widgetSelector!.state!.addWidget(null, widget);
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
