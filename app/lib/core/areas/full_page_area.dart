import 'package:flutter/material.dart';

import '../elements/page_segment.dart';
import '../themes/widgets/trip_theme.dart';
import 'mixins/single_element_area_mixin.dart';
import 'widget_area.dart';

class FullPageArea extends WidgetArea<PageSegment> {
  const FullPageArea({required String id, Key? key}) : super(id, key: key);

  @override
  State<StatefulWidget> createState() => FullPageAreaState();
}

class FullPageAreaState extends WidgetAreaState<FullPageArea, PageSegment>
    with SingleElementAreaMixin<FullPageArea, PageSegment> {
  @override
  bool get wantKeepAlive => element?.keepAlive ?? super.wantKeepAlive;

  @override
  EdgeInsetsGeometry getMargin() =>
      template.isEditing ? const EdgeInsets.symmetric(horizontal: 10, vertical: 40) : super.getMargin();

  @override
  EdgeInsetsGeometry getPadding() => template.isEditing ? super.getPadding() : EdgeInsets.zero;

  @override
  Widget buildArea(BuildContext context) {
    return element ?? const Center(child: Text('No Content'));
  }

  @override
  BoxConstraints constrainWidget(PageSegment widget) => BoxConstraints.tight(areaSize);

  @override
  Widget? decorateElement(BuildContext context, PageSegment element) {
    return Material(
      textStyle: TextStyle(color: context.getTextColor()),
      color: Colors.transparent,
      child: element.builder(context),
    );
  }
}
