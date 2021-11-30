import 'package:flutter/material.dart';

import '../elements/quick_action.dart';
import 'mixins/list_area_mixin.dart';
import 'widget_area.dart';

class QuickActionRowArea extends WidgetArea<QuickAction> {
  const QuickActionRowArea(String id, {Key? key}) : super(id, key: key);

  @override
  State<StatefulWidget> createState() => QuickActionRowAreaState();
}

class QuickActionRowAreaState extends WidgetAreaState<QuickActionRowArea, QuickAction>
    with ListAreaMixin<QuickActionRowArea, QuickAction> {
  final _boxKey = GlobalKey();

  @override
  Widget buildArea(BuildContext context) {
    return SizedBox(
      key: _boxKey,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: elements,
      ),
    );
  }

  @override
  BoxConstraints constrainWidget(QuickAction widget) => const BoxConstraints();

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
    Size itemSize = getSize(itemKey);

    var row = elements;

    var boxWidth = _boxKey.currentContext!.size!.width;
    var spacing = (boxWidth - itemSize.width * row.length) / (row.length + 1);

    int index = row.indexWhere((e) => e.key == itemKey);

    if (index > 0 && offset.dx < itemOffset.dx - itemSize.width / 2 - spacing / 2 - 20) {
      setState(() {
        var draggedItem = row.removeAt(index);
        row.insert(index - 1, draggedItem);
      });
      translateX(row[index].key, -itemSize.width - spacing);
      return true;
    } else if (index < row.length - 1 && offset.dx > itemOffset.dx + itemSize.width / 2 + spacing / 2 + 20) {
      setState(() {
        var draggedItem = row.removeAt(index);
        row.insert(index + 1, draggedItem);
      });
      translateX(row[index].key, itemSize.width + spacing);
      return true;
    }
    return false;
  }

  void removeAtIndex(int index) {
    var row = elements;
    var itemSize = getSize(row[index].key);

    var boxWidth = _boxKey.currentContext!.size!.width;
    var spacing = (boxWidth - itemSize.width * row.length) / (row.length + 1);

    if (row.length == 1) {
      row.removeAt(index);
    } else if (row.length == 2) {
      if (index == 0) {
        translateX(row[1].key, itemSize.width / 2 + spacing / 2);
      } else {
        translateX(row[0].key, -itemSize.width / 2 - spacing / 2);
      }
      row.removeAt(index);
    } else if (row.length == 3) {
      if (index == 0) {
        translateX(row[1].key, itemSize.width / 2 + spacing / 2);
        translateX(row[2].key, (boxWidth + itemSize.width) / 12);
      } else if (index == 1) {
        translateX(row[0].key, -(boxWidth + itemSize.width) / 12);
        translateX(row[2].key, (boxWidth + itemSize.width) / 12);
      } else {
        translateX(row[0].key, -(boxWidth + itemSize.width) / 12);
        translateX(row[1].key, -itemSize.width / 2 - spacing / 2);
      }
      row.removeAt(index);
    }
  }
}
