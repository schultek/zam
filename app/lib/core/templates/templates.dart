library templates;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../bloc/app_bloc.dart';
import '../areas/areas.dart';
import '../module/module.dart';
import '../reorderable/reorderable_manager.dart';
import '../themes/themes.dart';
import '../widgets/reorder_toggle.dart';
import '../widgets/widget_selector.dart';

part 'basic_template.dart';

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

abstract class WidgetTemplate extends StatefulWidget {
  final String id;
  final ModuleData moduleData;
  const WidgetTemplate(this.id, this.moduleData);

  Widget build(BuildContext context);

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
  String? _selectedArea, _lastSelectedArea;
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
    selectWidgetArea(widgetAreas[_lastSelectedArea]!);
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

  void selectWidgetArea<T extends ModuleElement>(WidgetAreaState<WidgetArea<T>, T> area) {
    if (!isEditing) return;
    if (_selectedArea == area.id) {
      return;
    } else if (_selectedArea != null) {
      _unselectArea();
    }

    print(area);

    _selectedArea = area.id;
    _lastSelectedArea = _selectedArea;
    widgetSelector = WidgetSelector.show<T>(this);

    setState(() {});
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
    _lastSelectedArea ??= area.id;
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
      child: widget.build(context),
    );
  }
}
