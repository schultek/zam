import 'package:flutter/material.dart';

import '../module_element.dart';

abstract class ElementDecorator<T extends ModuleElement> {
  ElementDecorator();

  Widget decorateElement(BuildContext context, T element, Widget child);

  Widget decoratePlaceholder(BuildContext context, T element);

  Widget decorateDragged(BuildContext context, T element, Widget child, double opacity);

  Widget getPlaceholder(BuildContext context);
}
