import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../providers/groups/logic_provider.dart';
import '../../providers/groups/selected_group_provider.dart';
import '../areas/areas.dart';
import '../elements/elements.dart';
import '../providers/editing_providers.dart';
import '../providers/selected_area_provider.dart';
import '../themes/themes.dart';
import '../widgets/config_sheet.dart';
import '../widgets/widget_selector.dart';
import 'template_model.dart';
import 'widgets/layout_toggle.dart';
import 'widgets/template_navigator.dart';

class InheritedTemplate extends InheritedWidget {
  final TemplateState state;

  const InheritedTemplate({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedTemplate oldWidget) => true;
}

abstract class Template<T extends TemplateModel> extends StatefulWidget {
  final T model;
  const Template(this.model, {Key? key}) : super(key: key);

  static TemplateState of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<InheritedTemplate>()!.state;
    } else {
      var element = context.getElementForInheritedWidgetOfExactType<InheritedTemplate>()!;
      return (element.widget as InheritedTemplate).state;
    }
  }
}

abstract class TemplateState<T extends Template<M>, M extends TemplateModel> extends State<T>
    with TickerProviderStateMixin {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  M get model => widget.model;

  final Map<String, AreaState> widgetAreas = {};

  WidgetSelectorController? widgetSelector;
  ConfigSheetController? configSheet;

  List<Widget> getPageSettings();

  Future<void> updateModel(M model) async {
    await context.read(groupsLogicProvider).updateTemplateModel(model);
  }

  @override
  void initState() {
    super.initState();
    context.read(wiggleControllerProvider.notifier).state =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void didChangeDependencies() {
    context.listen<EditState>(editProvider, (_, state) {
      configSheet?.close();
      configSheet = null;

      if (state == EditState.layoutMode) {
        configSheet = ConfigSheet.show<M>(_navigatorKey.currentContext!);
      }
    });

    context.listen<String?>(selectedAreaProvider, (_, area) async {
      widgetSelector?.close();
      widgetSelector = null;

      if (area != null) {
        if (widgetAreas[area]?.mounted ?? false) {
          var widgetArea = widgetAreas[area]!;
          widgetArea.callTyped(<E extends ModuleElement>() async {
            widgetSelector = await WidgetSelector.show<E>(this, widgetArea as AreaState<Area<E>, E>);
            setState(() {});
          });
        }
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
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

  void registerArea(AreaState area) {
    widgetAreas[area.id] = area;
  }

  Widget buildPages(BuildContext context);

  @override
  Widget build(BuildContext context) {
    var group = context.read(selectedGroupProvider)!;
    var editState = context.watch(editProvider);
    return InheritedTemplate(
      state: this,
      child: MediaQuery(
        data: MediaQuery.of(context).addPadding(
            bottom: editState == EditState.layoutMode
                ? MediaQuery.of(context).size.height * 0.2
                : editState == EditState.widgetMode
                    ? widgetSelector?.state?.sheetHeight ?? 0
                    : 0),
        child: GroupTheme(
          theme: GroupThemeData.fromModel(group.theme),
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
                    home: VisibilityDetector(
                      key: const ValueKey('template-home'),
                      onVisibilityChanged: (visibilityInfo) {
                        context.read(templateVisibilityProvider.notifier).state = visibilityInfo.visibleFraction > 0.5;
                      },
                      child: buildPages(context),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      if (context.watch(isEditingProvider) &&
                          !context.watch(toggleVisibilityProvider) &&
                          context.watch(templateVisibilityProvider)) {
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
