import 'package:flutter/material.dart';

import '../elements/decorators/default_quick_action_decorator.dart';
import '../elements/decorators/element_decorator.dart';
import '../elements/quick_action.dart';
import 'mixins/list_area_mixin.dart';
import 'widget_area.dart';

class QuickActionRowArea extends WidgetArea<QuickAction> {
  final ElementDecorator<QuickAction> decorator;
  const QuickActionRowArea(String id, {Key? key, this.decorator = const DefaultQuickActionDecorator()})
      : super(id, key: key);

  @override
  State<StatefulWidget> createState() => QuickActionRowAreaState();
}

class QuickActionRowAreaState extends WidgetAreaState<QuickActionRowArea, QuickAction>
    with ListAreaMixin<QuickActionRowArea, QuickAction> {
  final _boxKey = GlobalKey();

  @override
  ElementDecorator<QuickAction> get elementDecorator => widget.decorator;

  @override
  EdgeInsets getPadding() => const EdgeInsets.all(5);

  @override
  Widget buildArea(BuildContext context) {
    return SizedBox(
      key: _boxKey,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var element in elements)
            Flexible(
              fit: FlexFit.tight,
              child: Center(child: element),
            )
        ],
      ),
    );
  }

  @override
  BoxConstraints constrainWidget(QuickAction widget) =>
      BoxConstraints(maxHeight: 100, maxWidth: areaSize.width / 3 - 5);

  @override
  bool canInsertItem(item) => elements.length < 3;

  @override
  void removeItem(Key key) {
    var index = elements.indexWhere((w) => w.key == key);
    removeAtIndex(index);
  }

  @override
  bool didReorderItem(Offset offset, Key itemKey) {
    Offset itemOffset = getOffset(itemKey);

    int index = elements.indexWhere((e) => e.key == itemKey);
    var boxWidth = _boxKey.currentContext!.size!.width;
    var spacing = boxWidth / elements.length;

    if (index > 0 && offset.dx < itemOffset.dx - spacing / 2 - 10) {
      setState(() {
        var draggedItem = elements.removeAt(index);
        elements.insert(index - 1, draggedItem);
      });
      translateX(elements[index].key, -spacing);
      return true;
    } else if (index < elements.length - 1 && offset.dx > itemOffset.dx + spacing / 2 + 10) {
      setState(() {
        var draggedItem = elements.removeAt(index);
        elements.insert(index + 1, draggedItem);
      });
      translateX(elements[index].key, spacing);
      return true;
    }
    return false;
  }

  @override
  void insertItem(Offset offset, QuickAction item) {
    var boxWidth = _boxKey.currentContext!.size!.width;

    if (elements.isEmpty) {
      setState(() => elements.add(item));
    } else if (elements.length == 1) {
      setState(() => elements.add(item));
      translateX(elements[0].key, boxWidth / 4);
    } else if (elements.length == 2) {
      setState(() => elements.insert(1, item));
      translateX(elements[0].key, boxWidth / 12);
      translateX(elements[2].key, -boxWidth / 12);
    }
  }

  void removeAtIndex(int index) {
    var boxWidth = _boxKey.currentContext!.size!.width;

    if (elements.length == 1) {
      elements.removeAt(index);
    } else if (elements.length == 2) {
      if (index == 0) {
        translateX(elements[1].key, boxWidth / 4);
      } else {
        translateX(elements[0].key, -boxWidth / 4);
      }
      elements.removeAt(index);
    } else if (elements.length == 3) {
      if (index == 0) {
        translateX(elements[1].key, boxWidth / 4);
        translateX(elements[2].key, boxWidth / 12);
      } else if (index == 1) {
        translateX(elements[0].key, -boxWidth / 12);
        translateX(elements[2].key, boxWidth / 12);
      } else {
        translateX(elements[0].key, -boxWidth / 12);
        translateX(elements[1].key, -boxWidth / 4);
      }
      elements.removeAt(index);
    }
  }
}
