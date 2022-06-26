import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart' hide KeepAlive;
import 'package:riverpod_context/riverpod_context.dart';

import '../../../helpers/extensions.dart';
import '../../../main.mapper.g.dart';
import '../../../widgets/nested_will_pop_scope.dart';
import '../../editing/editing_providers.dart';
import '../../editing/selected_area_provider.dart';
import '../../layouts/layouts.dart';
import '../../templates/templates.dart';
import '../../themes/themes.dart';
import '../../widgets/layout_preview.dart';
import '../../widgets/layout_preview_switcher.dart';
import '../../widgets/settings_section.dart';
import '../widgets/custom_page_view.dart';
import '../widgets/empty_page.dart';
import '../widgets/keep_alive.dart';
import '../widgets/main_group_header.dart';

part 'swipe_template_model.dart';
part 'swipe_template_page.dart';

class SwipeTemplate extends Template<SwipeTemplateModel> {
  // ignore: prefer_const_constructors_in_immutables
  SwipeTemplate(SwipeTemplateModel model, {Key? key}) : super(model, key: key);

  @override
  State<StatefulWidget> createState() => SwipeTemplateState();
}

class SwipeTemplateState extends TemplateState<SwipeTemplate, SwipeTemplateModel> {
  late final CustomPageController pageController;

  final leftKey = const ValueKey('left');
  final rightKey = const ValueKey('right');
  final mainKey = const ValueKey('main');

  @override
  void initState() {
    super.initState();
    pageController = CustomPageController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read(activeLayoutProvider.notifier).state = model.mainPage.layout.withId('main');
    });
  }

  @override
  void didUpdateWidget(covariant SwipeTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      updateActiveLayout(pageController.page);
    });
  }

  void updateActiveLayout(int page) {
    if (page == -1) {
      context.read(activeLayoutProvider.notifier).state = model.leftPage?.layout.withId('left');
    } else if (page == 0) {
      context.read(activeLayoutProvider.notifier).state = model.mainPage.layout.withId('main');
    } else if (page == 1) {
      context.read(activeLayoutProvider.notifier).state = model.rightPage?.layout.withId('right');
    }
  }

  @override
  List<Widget> getPageSettings() {
    var pageIndex = pageController.page;
    if (pageIndex == -1) {
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
    } else if (pageIndex == 0) {
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
            if (!Navigator.of(context).canPop() && pageController.page != 0) {
              pageController.animateToPage(0);
              return false;
            }
            return true;
          },
          child: Builder(builder: (context) {
            var isEditing = context.watch(isEditingProvider);
            return CustomPageView(
              controller: pageController,
              onPageChanged: updateActiveLayout,
              anchor: mainKey,
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
