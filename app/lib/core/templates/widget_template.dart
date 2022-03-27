import 'dart:ui';

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
import '../providers/editing_providers.dart';
import '../providers/selected_area_provider.dart';
import '../themes/themes.dart';
import '../widgets/config_sheet.dart';
import '../widgets/widget_selector.dart';
import 'template_model.dart';
import 'widgets/layout_toggle.dart';
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
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  M get model => widget.model;

  final Map<String, WidgetAreaState> widgetAreas = {};

  WidgetSelectorController? widgetSelector;
  ConfigSheetController? configSheet;

  List<Widget> getPageSettings();

  Future<void> updateModel(M model) async {
    await context.read(tripsLogicProvider).updateTemplateModel(model);
  }

  @override
  void initState() {
    super.initState();
    context.read(transitionControllerProvider.notifier).state =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    context.read(wiggleControllerProvider.notifier).state =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void didChangeDependencies() {
    context.listen<EditState>(editProvider, (_, state) {
      if (state == EditState.layoutMode) {
        configSheet = ConfigSheet.show<M>(_navigatorKey.currentContext!);
      } else {
        configSheet?.close();
        configSheet = null;
      }
    });

    context.listen<String?>(selectedAreaProvider, (_, area) async {
      if (area != null) {
        if (widgetAreas[area]?.mounted ?? false) {
          var widgetArea = widgetAreas[area]!;
          widgetArea.callTyped(<E extends ModuleElement>() async {
            widgetSelector = await WidgetSelector.show<E>(this, widgetArea as WidgetAreaState<WidgetArea<E>, E>);
          });
        }
      } else {
        widgetSelector?.close();
        widgetSelector = null;
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    context.read(transitionControllerProvider.notifier).update((state) {
      state?.dispose();
      return null;
    });
    context.read(wiggleControllerProvider.notifier).update((state) {
      state?.dispose();
      return null;
    });
    configSheet?.close();
    widgetSelector?.close();
    super.dispose();
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
    var editState = context.watch(editProvider);
    return InheritedWidgetTemplate(
      state: this,
      child: MediaQuery(
        data: MediaQuery.of(context).addPadding(
            bottom: editState == EditState.layoutMode
                ? MediaQuery.of(context).size.height * 0.2
                : editState == EditState.widgetMode
                    ? widgetSelector?.state?.sheetHeight ?? 0
                    : 0),
        child: TripTheme(
          theme: TripThemeData.fromModel(trip.theme),
          child: Builder(builder: (context) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: FlexColorScheme.themedSystemNavigationBar(
                context,
                noAppBar: true,
              ),
              child: Stack(
                children: [
                  TemplateNavigator(
                    navigatorKey: _navigatorKey,
                    home: buildPages(context),
                  ),
                  Builder(
                    builder: (context) {
                      if (context.watch(isEditingProvider) && !context.watch(toggleVisibilityProvider)) {
                        return Positioned(
                          top: 45,
                          right: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  color: context.onSurfaceColor.withOpacity(0.1),
                                  padding: const EdgeInsets.all(5),
                                  child: const EditToggles(notifyVisibility: false),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
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
