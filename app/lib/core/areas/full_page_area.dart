import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../elements/elements.dart';
import 'area.dart';
import 'mixins/single_element_area_mixin.dart';

class FullPageArea extends Area<PageElement> {
  const FullPageArea({required String id, Key? key}) : super(id, key: key);

  @override
  State<StatefulWidget> createState() => FullPageAreaState();
}

class FullPageAreaState extends AreaState<FullPageArea, PageElement>
    with SingleElementAreaMixin<FullPageArea, PageElement> {
  @override
  bool get wantKeepAlive => element?.keepAlive ?? super.wantKeepAlive;

  @override
  final ElementDecorator<PageElement> elementDecorator = DefaultPageElementDecorator();

  @override
  EdgeInsets getMargin() => isEditing ? const EdgeInsets.symmetric(horizontal: 10, vertical: 10) : super.getMargin();

  @override
  EdgeInsets getPadding() => isEditing ? super.getPadding() : EdgeInsets.zero;

  @override
  Widget buildArea(BuildContext context) {
    if (isLoading) {
      return Container();
    }
    return element ?? Center(child: Text(context.tr.no_content));
  }

  @override
  BoxConstraints constrainWidget(PageElement? widget) => BoxConstraints.tight(areaSize);
}
