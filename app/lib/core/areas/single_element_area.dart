import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../elements/elements.dart';
import '../themes/themes.dart';
import 'area.dart';
import 'mixins/single_element_area_mixin.dart';

class SingleElementArea extends Area<ContentElement> {
  final ElementDecorator<ContentElement> decorator;
  const SingleElementArea({
    required String id,
    this.decorator = const DefaultContentElementDecorator(),
    Key? key,
  }) : super(id, key: key);

  @override
  State<StatefulWidget> createState() => SingleElementAreaState();
}

class SingleElementAreaState extends AreaState<SingleElementArea, ContentElement>
    with SingleElementAreaMixin<SingleElementArea, ContentElement> {
  @override
  ElementDecorator<ContentElement> get elementDecorator => widget.decorator;

  @override
  EdgeInsets getPadding() => !isEditing && element == null ? EdgeInsets.zero : super.getPadding();

  @override
  Widget buildArea(BuildContext context) {
    if (element != null) return Center(child: element!);

    if (isEditing) return Container();

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
  BoxConstraints constrainWidget(ContentElement widget) => BoxConstraints.loose(areaSize);
}
