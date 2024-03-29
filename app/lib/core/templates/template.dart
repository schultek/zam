import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/groups/logic_provider.dart';
import '../../providers/groups/selected_group_provider.dart';
import '../areas/areas.dart';
import '../editing/editing_providers.dart';
import '../editing/widgets/config_sheet.dart';
import '../editing/widgets/widget_selector.dart';
import '../themes/themes.dart';
import 'template_model.dart';
import 'widgets/edit_toggle.dart';
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
  M get model => widget.model;

  final Map<String, AreaState> widgetAreas = {};

  static Animation<double> wiggle = const AlwaysStoppedAnimation(0);
  static AnimationController? wiggleController;
  late AnimationController _wiggleController;

  List<Widget> getPageSettings();

  Future<void> updateModel(M model) async {
    await context.read(groupsLogicProvider).updateTemplateModel(model);
  }

  @override
  void initState() {
    super.initState();
    _wiggleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    wiggleController = _wiggleController;
    wiggle = _wiggleController.view;
  }

  @override
  void dispose() {
    _wiggleController.dispose();
    if (_wiggleController == wiggleController) {
      wiggleController = null;
      wiggle = const AlwaysStoppedAnimation(0);
    }
    super.dispose();
  }

  void removeWidgetsWithParams(dynamic params) {
    for (var area in widgetAreas.values) {
      area.removeWidgetWithParams(params);
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
                  home: Stack(
                    children: [
                      MediaQuery(
                        data: MediaQuery.of(context).addPadding(bottom: editState ? WidgetSelector.sheetHeight : 0),
                        child: buildPages(context),
                      ),
                      Builder(builder: (context) {
                        if (context.watch(editProvider)) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: ConfigSheet<M>(),
                          );
                        } else {
                          return Container();
                        }
                      }),
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
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

extension on MediaQueryData {
  MediaQueryData addPadding({double? bottom}) {
    return copyWith(padding: padding.copyWith(bottom: bottom != null ? padding.bottom + bottom : null));
  }
}
