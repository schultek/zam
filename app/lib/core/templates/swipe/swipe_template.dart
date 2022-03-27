import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../helpers/extensions.dart';
import '../../../widgets/nested_will_pop_scope.dart';
import '../../core.dart';
import '../../layouts/full_page_layout.dart';
import '../../layouts/grid_layout.dart';
import '../../layouts/layout_model.dart';
import '../../providers/editing_providers.dart';
import '../../providers/selected_area_provider.dart';
import '../../widgets/layout_preview.dart';
import '../../widgets/layout_preview_switcher.dart';
import '../../widgets/settings_section.dart';
import '../widgets/custom_page_view.dart';
import '../widgets/empty_page.dart';
import '../widgets/main_group_header.dart';

part 'swipe_template_model.dart';
part 'swipe_template_page.dart';

class SwipeTemplate extends WidgetTemplate<SwipeTemplateModel> {
  // ignore: prefer_const_constructors_in_immutables
  SwipeTemplate(SwipeTemplateModel model, {Key? key}) : super(model, key: key);

  @override
  State<StatefulWidget> createState() => SwipeTemplateState();
}

class SwipeTemplateState extends WidgetTemplateState<SwipeTemplate, SwipeTemplateModel> {
  late final CustomPageController pageController;

  final leftKey = const ValueKey('left');
  final rightKey = const ValueKey('right');
  final mainKey = const ValueKey('main');

  @override
  void initState() {
    super.initState();
    pageController = CustomPageController(initialPage: widget.model.leftPage != null ? 1 : 0);
  }

  @override
  List<Widget> getPageSettings() {
    var pageIndex = pageController.page;
    if (pageIndex == 0) {
      if (model.leftPage != null) {
        return model.leftPage!.getSettings(
          model,
          (page) => updateModel(model.copyWith(leftPage: page)),
          pageController.animateToPageDelta,
        );
      } else {
        return SwipeTemplatePage.getEmptyPageSettings(
          pageIndex,
          (page) => updateModel(model.copyWith(leftPage: page)),
          pageController.animateToPageDelta,
        );
      }
    } else if (pageIndex == 1) {
      return model.mainPage.getSettings(
        model,
        (page) => updateModel(model.copyWith(mainPage: page)),
        pageController.animateToPageDelta,
      );
    } else {
      if (model.rightPage != null) {
        return model.rightPage!.getSettings(
          model,
          (page) => updateModel(model.copyWith(rightPage: page)),
          pageController.animateToPageDelta,
        );
      } else {
        return SwipeTemplatePage.getEmptyPageSettings(
          pageIndex,
          (page) => updateModel(model.copyWith(rightPage: page)),
          pageController.animateToPageDelta,
        );
      }
    }
  }

  @override
  Widget buildPages(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => NestedWillPopScope(
          onWillPop: () async {
            if (!Navigator.of(context).canPop() && pageController.page != 1) {
              pageController.animateToPage(1);
              return false;
            }
            return true;
          },
          child: Builder(builder: (context) {
            var isEditing = context.watch(isEditingProvider);
            return CustomPageView(
              controller: pageController,
              onPageChanged: (index) {
                if (isEditing) {
                  context.read(selectedAreaProvider.notifier).selectWidgetAreaById(null);
                  if (context.read(editProvider) == EditState.layoutMode) {}
                }
                context.read(currentPageProvider.notifier).state = index;
              },
              children: [
                if (model.leftPage != null) //
                  KeepAlive(
                    key: leftKey,
                    child: model.leftPage!.layout.builder(LayoutContext(
                      id: 'left',
                      context: context,
                      onUpdate: (m) => model.copyWith.leftPage!(layout: m),
                    )),
                  )
                else if (isEditing) //
                  EmptyPage(key: leftKey),
                KeepAlive(
                  key: mainKey,
                  child: model.mainPage.layout.builder(LayoutContext(
                    id: 'main',
                    header: const MainGroupHeader(),
                    context: context,
                    onUpdate: (m) => model.copyWith.mainPage(layout: m),
                  )),
                ),
                if (model.rightPage != null) //
                  KeepAlive(
                    key: rightKey,
                    child: model.rightPage!.layout.builder(LayoutContext(
                      id: 'right',
                      context: context,
                      onUpdate: (m) => model.copyWith.rightPage!(layout: m),
                    )),
                  )
                else if (isEditing) //
                  EmptyPage(key: rightKey),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class KeepAlive extends StatefulWidget {
  const KeepAlive({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
