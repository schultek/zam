import 'package:collection/collection.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../modules/modules.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../areas/widget_area.dart';
import '../elements/module_element.dart';
import '../module/module_context.dart';
import '../themes/material_theme.dart';
import '../themes/widgets/trip_theme.dart';
import '../widgets/widget_selector.dart';
import 'template_model.dart';
import 'widgets/template_navigator.dart';

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
  const WidgetTemplate(this.config, {Key? key}) : super(key: key);

  Widget build(BuildContext context, WidgetTemplateState state);

  void onEdit(WidgetTemplateState state) {}
  void init([WidgetTemplate<T>? oldWidget]) {}
  void dispose() {}

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
    widget.init();
  }

  @override
  void didUpdateWidget(WidgetTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.dispose();
    widget.init(oldWidget);
  }

  @override
  void dispose() {
    _transitionController.dispose();
    _wiggleController.dispose();
    widget.dispose();
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

  Future<List<T>> getWidgetsForArea<T extends ModuleElement>(String areaId) async {
    var selectedModules = context.read(areaModulesProvider(areaId));
    var elements =
        await Future.wait(selectedModules.map((id) async => await registry.getWidget<T>(ModuleContext(context, id))));
    return elements.whereNotNull().toList();
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
      if (widget.id.split('/').length < 2) {
        // Don't add specialized cards
        widgetSelector!.state!.addWidget(null, widget);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var trip = context.read(selectedTripProvider)!;
    return InheritedWidgetTemplate(
      state: this,
      child: MediaQuery(
        data: MediaQuery.of(context).addPadding(bottom: widgetSelector?.state?.sheetHeight),
        child: TripTheme(
          theme: MaterialTheme(FlexScheme.values[trip.theme.schemeIndex], trip.theme.dark),
          child: Builder(builder: (context) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: FlexColorScheme.themedSystemNavigationBar(
                context,
                noAppBar: true,
              ),
              child: TemplateNavigator(
                home: widget.build(context, this),
              ),
            );
          }),
        ),
      ),
    );
  }
}

extension on MediaQueryData {
  MediaQueryData addPadding({double? bottom}) {
    return copyWith(padding: padding.copyWith(bottom: bottom != null ? padding.bottom + bottom : null));
  }
}
