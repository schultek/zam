import 'package:collection/collection.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../modules/modules.dart';
import '../../providers/trips/logic_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../areas/widget_area.dart';
import '../elements/module_element.dart';
import '../themes/trip_theme_data.dart';
import '../themes/widgets/trip_theme.dart';
import '../widgets/config_sheet.dart';
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
  final T model;
  const WidgetTemplate(this.model, {Key? key}) : super(key: key);

  static WidgetTemplateState of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<InheritedWidgetTemplate>()!.state;
    } else {
      var element = context.getElementForInheritedWidgetOfExactType<InheritedWidgetTemplate>()!;
      return (element.widget as InheritedWidgetTemplate).state;
    }
  }
}

abstract class WidgetTemplateState<T extends WidgetTemplate<M>, M extends TemplateModel> extends State<T>
    with TickerProviderStateMixin {
  late AnimationController _transitionController;
  late AnimationController _wiggleController;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  M get model => widget.model;

  bool _isEditing = false;
  bool _isLayoutMode = false;

  final Map<String, WidgetAreaState> widgetAreas = {};
  String? _selectedArea;
  WidgetSelectorController? widgetSelector;
  ConfigSheetController? configSheet;

  Animation<double> get transition => _transitionController.view;
  Animation<double> get wiggle => _wiggleController.view;

  bool get isEditing => _isEditing;
  bool get isLayoutMode => _isLayoutMode;
  String? get selectedArea => _selectedArea;

  List<Widget> getPageSettings();

  Future<void> updateModel(M model) async {
    await context.read(tripsLogicProvider).updateTemplateModel(model);
  }

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
    widgetSelector?.close();
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
      _isLayoutMode = false;
    });
    _wiggleController.repeat();
    _transitionController.forward();
  }

  void toggleLayoutMode() {
    if (!_isEditing) return;
    if (_isLayoutMode) {
      _wiggleController.repeat();
      _transitionController.forward();
      configSheet?.close();
      setState(() {
        _isLayoutMode = false;
      });
    } else {
      _transitionController.reverse().whenComplete(() {
        _wiggleController.stop();
        setState(() {
          _isLayoutMode = true;
        });
      });
      _unselectArea();

      configSheet = ConfigSheet.show<M>(_navigatorKey.currentContext!);
    }
  }

  void _finishEdit() {
    _isEditing = false;
    if (!_isLayoutMode) {
      _transitionController.reverse().whenComplete(() {
        _wiggleController.stop();
        setState(() {});
      });
      _unselectArea();
    } else {
      configSheet?.close();
      _isLayoutMode = false;
    }
    setState(() {});
  }

  void removeWidgetsWithId(String id) {
    for (var area in widgetAreas.values) {
      area.removeWidgetWithId(id);
    }
  }

  Future<List<E>> getWidgetsForArea<E extends ModuleElement>(String areaId) async {
    var selectedModules = context.read(areaModulesProvider(areaId));
    var elements = await Future.wait(selectedModules.map((id) async => await registry.getWidget<E>(context, id)));
    return elements.whereNotNull().toList();
  }

  void selectWidgetArea<E extends ModuleElement>(WidgetAreaState<WidgetArea<E>, E>? area) {
    selectWidgetAreaById<E>(area?.id);
  }

  void selectWidgetAreaById<E extends ModuleElement>(String? id) async {
    if (!isEditing || isLayoutMode) return;
    if (_selectedArea == id) {
      return;
    } else if (_selectedArea != null) {
      _unselectArea();
    }

    if (id == null) return;

    _selectedArea = id;

    setState(() {});

    if (widgetAreas[selectedArea]?.mounted ?? false) {
      widgetSelector = await WidgetSelector.show<E>(this);
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

  void onWidgetRemoved<E extends ModuleElement>(WidgetAreaState<WidgetArea<E>, E> area, E widget) {
    if (widgetSelector != null && widgetSelector!.isForArea(area)) {
      if (widget.id.split('/').length < 2) {
        // Don't add specialized cards
        widgetSelector!.state!.addWidget(null, widget);
      }
    }
  }

  Widget buildPages(BuildContext context);

  @override
  Widget build(BuildContext context) {
    var trip = context.read(selectedTripProvider)!;
    return InheritedWidgetTemplate(
      state: this,
      child: MediaQuery(
        data: MediaQuery.of(context).addPadding(
            bottom: isEditing
                ? isLayoutMode
                    ? MediaQuery.of(context).size.height * 0.2
                    : widgetSelector?.state?.sheetHeight ?? 0
                : 0),
        child: TripTheme(
          theme: TripThemeData.fromModel(trip.theme),
          child: Builder(builder: (context) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: FlexColorScheme.themedSystemNavigationBar(
                context,
                noAppBar: true,
              ),
              child: TemplateNavigator(
                navigatorKey: _navigatorKey,
                home: buildPages(context),
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
