import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../elements/content_segment.dart';
import '../elements/decorators/default_content_segment_decorator.dart';
import '../elements/decorators/element_decorator.dart';
import '../themes/theme_context.dart';
import 'mixins/single_element_area_mixin.dart';
import 'widget_area.dart';

class SingleWidgetArea extends WidgetArea<ContentSegment> {
  final ElementDecorator<ContentSegment> decorator;
  const SingleWidgetArea({
    required String id,
    this.decorator = const DefaultContentSegmentDecorator(),
    Key? key,
  }) : super(id, key: key);

  @override
  State<StatefulWidget> createState() => SingleWidgetAreaState();
}

class SingleWidgetAreaState extends WidgetAreaState<SingleWidgetArea, ContentSegment>
    with SingleElementAreaMixin<SingleWidgetArea, ContentSegment> {
  @override
  ElementDecorator<ContentSegment> get elementDecorator => widget.decorator;

  @override
  EdgeInsets getPadding() => !template.isEditing && element == null ? EdgeInsets.zero : super.getPadding();

  @override
  Widget buildArea(BuildContext context) {
    if (element != null) return element!;

    if (template.isEditing) return Container();

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(20),
      strokeWidth: 1,
      dashPattern: const [4, 8],
      color: context.onSurfaceHighlightColor,
      child: Container(),
    );
  }

  @override
  BoxConstraints constrainWidget(ContentSegment widget) => BoxConstraints.tight(areaSize);
}
