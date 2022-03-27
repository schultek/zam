import 'package:flutter/material.dart';

import '../elements/content_segment.dart';
import '../elements/decorators/default_content_segment_decorator.dart';
import '../elements/decorators/element_decorator.dart';
import 'mixins/list_area_mixin.dart';
import 'mixins/scroll_mixin.dart';
import 'widget_area.dart';

class HorizontalScrollArea extends WidgetArea<ContentSegment> {
  final ElementDecorator<ContentSegment> decorator;
  const HorizontalScrollArea(String id, {Key? key, this.decorator = const DefaultContentSegmentDecorator()})
      : super(id, key: key);

  @override
  State<StatefulWidget> createState() => HorizontalScrollAreaState();
}

class HorizontalScrollAreaState extends WidgetAreaState<HorizontalScrollArea, ContentSegment>
    with ListAreaMixin<HorizontalScrollArea, ContentSegment>, ScrollMixin<HorizontalScrollArea, ContentSegment> {
  @override
  ElementDecorator<ContentSegment> get elementDecorator => widget.decorator;

  @override
  EdgeInsets getPadding() => isEditing ? const EdgeInsets.symmetric(horizontal: 2) : EdgeInsets.zero;

  @override
  EdgeInsets getMargin() => isEditing ? const EdgeInsets.symmetric(horizontal: 5) : EdgeInsets.zero;

  @override
  Radius getRadius() => const Radius.circular(10);

  double spacing = 10;

  @override
  ScrollController scrollController = ScrollController();

  @override
  Widget buildArea(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        cacheExtent: isEditing ? 10000 : 200,
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: isEditing ? 13 : 20, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: elements.length,
        itemBuilder: (context, index) => elements[index],
        separatorBuilder: (context, index) => SizedBox(width: spacing),
      ),
    );
  }

  @override
  BoxConstraints constrainWidget(ContentSegment widget) => const BoxConstraints(maxHeight: 160);

  @override
  bool canInsertItem(item) => true;

  @override
  void removeItem(Key key) {
    var index = elements.indexWhere((w) => w.key == key);
    removeAtIndex(index);
  }

  @override
  bool didReorderItem(Offset offset, Key itemKey) {
    Offset itemOffset = getOffset(itemKey);
    Size itemSize = getSize(itemKey);

    maybeScroll(offset, itemKey, itemSize);

    int index = elements.indexWhere((e) => e.key == itemKey);

    if (index > 0 && offset.dx < itemOffset.dx - spacing) {
      var prevItem = elements[index - 1];
      if (!logic.hasItem(prevItem.key)) return false;
      var prevItemSize = getSize(prevItem.key);

      if (offset.dx < itemOffset.dx - prevItemSize.width / 2 - spacing) {
        setState(() {
          var draggedItem = elements.removeAt(index);
          elements.insert(index - 1, draggedItem);
        });
        translateX(elements[index].key, -itemSize.width - spacing);
        return true;
      }
    } else if (index < elements.length - 1 && offset.dx > itemOffset.dx + spacing) {
      var nextItem = elements[index + 1];
      if (!logic.hasItem(nextItem.key)) return false;
      var nextItemSize = getSize(nextItem.key);

      if (offset.dx > itemOffset.dx + nextItemSize.width / 2 + spacing) {
        setState(() {
          var draggedItem = elements.removeAt(index);
          elements.insert(index + 1, draggedItem);
        });

        translateX(elements[index].key, itemSize.width + spacing);
        return true;
      }
    }
    return false;
  }

  @override
  void insertItem(Offset offset, ContentSegment item) {
    var indexAfter = elements.indexWhere((e) {
      if (!logic.hasItem(e.key)) return false;
      var size = logic.itemSize(e.key);
      return logic.itemOffset(e.key).dx + size.width > offset.dx;
    });

    setState(() {
      if (indexAfter == -1) {
        elements.add(item);
      } else {
        var itemWidth = getSize(item.key).width;
        for (int i = indexAfter; i < elements.length; i++) {
          if (!logic.hasItem(elements[i].key)) continue;
          translateX(elements[i].key, -itemWidth - spacing);
        }
        elements.insert(indexAfter, item);
      }
    });
  }

  void removeAtIndex(int index) {
    var item = elements[index];

    var itemWidth = getSize(item.key).width;
    for (int i = index + 1; i < elements.length; i++) {
      if (!logic.hasItem(elements[i].key)) continue;
      translateX(elements[i].key, itemWidth + spacing);
    }

    elements.removeAt(index);
  }
}
