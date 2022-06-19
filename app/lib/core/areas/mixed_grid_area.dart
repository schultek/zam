import 'package:flutter/material.dart';

import '../elements/elements.dart';
import 'area.dart';
import 'mixins/grid_area_mixin.dart';
import 'mixins/scroll_mixin.dart';

class MixedGridArea extends Area<ContentElement> {
  final ScrollController scrollController;
  const MixedGridArea({required String id, required this.scrollController, Key? key}) : super(id, key: key);

  @override
  State<StatefulWidget> createState() => BodyWidgetAreaState();
}

class BodyWidgetAreaState extends AreaState<MixedGridArea, ContentElement>
    with ScrollMixin<MixedGridArea, ContentElement>, GridAreaMixin<MixedGridArea, ContentElement> {
  @override
  bool get wantKeepAlive => true;

  @override
  final ElementDecorator<ContentElement> elementDecorator = const DefaultContentElementDecorator();

  @override
  ElementSize sizeOf(ContentElement element) => element.size;

  @override
  EdgeInsets getPadding() => EdgeInsets.zero;

  double spacing = 20;

  @override
  Widget buildArea(BuildContext context) {
    Widget child = Container();

    if (!isLoading) {
      child = AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.topCenter,
        curve: Curves.easeInOut,
        child: ListView.builder(
          padding: EdgeInsets.only(top: spacing / 2),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: grid.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(
                bottom: index == grid.length - 1 ? spacing / 2 : spacing, left: spacing / 2, right: spacing / 2),
            child: grid[index][0].size == ElementSize.wide
                ? grid[index][0]
                : Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: grid[index][0],
                      ),
                      Container(width: spacing),
                      Flexible(
                        fit: FlexFit.tight,
                        child: grid[index].length == 2 ? grid[index][1] : Container(),
                      )
                    ],
                  ),
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 400),
      child: child,
    );
  }

  @override
  BoxConstraints constrainWidget(ContentElement? widget) {
    if (widget?.size == ElementSize.wide) {
      return BoxConstraints(maxWidth: areaSize.width - spacing);
    } else {
      return BoxConstraints(maxWidth: (areaSize.width - spacing * 2) / 2);
    }
  }

  @override
  ScrollController get scrollController => widget.scrollController;

  @override
  Offset? didReorderItem(Offset offset, Key itemKey) {
    Offset itemOffset = getOffset(itemKey);
    Size itemSize = getSize(itemKey);

    maybeScroll(offset, itemKey, itemSize);

    if (offset.dy < itemOffset.dy - spacing) {
      var dragIndex = indexOf(itemKey);
      if (dragIndex.row > 0) {
        var aboveRow = grid[dragIndex.row - 1];
        var aboveSize = getSize(aboveRow[0].key);

        if (offset.dy < itemOffset.dy - aboveSize.height / 2 - spacing) {
          if (dragIndex.size == ElementSize.wide) {
            _onReorder(itemKey, aboveRow[0].key);

            translateY(aboveRow[0].key, -itemSize.height - spacing);
            if (aboveRow.length == 2) translateY(aboveRow[1].key, -itemSize.height - spacing);
          } else {
            if (aboveRow.length == 2) {
              var aboveItem = aboveRow[dragIndex.column];

              _onReorder(itemKey, aboveItem.key);
              translateY(aboveItem.key, -itemSize.height - spacing);
            } else if (grid[dragIndex.row].length == 2) {
              var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

              _onReorder(itemKey, aboveRow[0].key);
              translateY(aboveRow[0].key, -itemSize.height - spacing);
              translateY(siblingItem.key, itemSize.height + spacing);
            }
          }

          return Offset(0, -aboveSize.height - spacing);
        }
      }
    }

    if (offset.dy > itemOffset.dy + spacing) {
      var dragIndex = indexOf(itemKey);
      if (dragIndex.row < grid.length - 1) {
        var belowRow = grid[dragIndex.row + 1];
        var belowSize = getSize(belowRow[0].key);

        if (offset.dy > itemOffset.dy + belowSize.height / 2 + spacing) {
          if (dragIndex.size == ElementSize.wide) {
            if (belowRow[0].size == ElementSize.wide || belowRow.length == 2) {
              _onReorder(itemKey, belowRow[0].key);

              translateY(belowRow[0].key, itemSize.height + spacing);
              if (belowRow.length == 2) {
                translateY(belowRow[1].key, itemSize.height + spacing);
              }
            }
          } else {
            if (belowRow.length == 2) {
              var belowItem = belowRow[dragIndex.column];

              _onReorder(itemKey, belowItem.key);
              translateY(belowItem.key, itemSize.height + spacing);
            } else if (belowRow[0].size == ElementSize.wide) {
              var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

              _onReorder(itemKey, belowRow[0].key);
              translateY(belowRow[0].key, itemSize.height + spacing);
              translateY(siblingItem.key, -itemSize.height - spacing);
            } else if (dragIndex.column == 0) {
              var belowItem = belowRow[0];

              _onReorder(itemKey, belowItem.key);
              translateY(belowItem.key, itemSize.height + spacing);
            } else {
              var siblingItem = grid[dragIndex.row][0];
              var belowItem = belowRow[0];

              _onReorder(itemKey, siblingItem.key);
              _onReorder(itemKey, belowItem.key);

              translateX(siblingItem.key, -itemSize.width - spacing);
              translateY(belowItem.key, itemSize.height + spacing);
            }
          }

          return Offset(0, belowSize.height + spacing);
        }
      }
    }

    if ((offset.dx - itemOffset.dx).abs() > itemSize.width / 2 + spacing) {
      var dragIndex = indexOf(itemKey);
      if (dragIndex.size == ElementSize.square && grid[dragIndex.row].length == 2) {
        var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

        _onReorder(itemKey, siblingItem.key);

        var sign = dragIndex.column == 0 ? 1 : -1;
        translateX(siblingItem.key, sign * (itemSize.width + spacing));

        return Offset(sign * (itemSize.width + spacing), 0);
      }
    }

    return null;
  }

  void _onReorder(Key draggedItem, Key newPosition) {
    GridIndex curIndex = indexOf(draggedItem);
    GridIndex newIndex = indexOf(newPosition);

    setState(() {
      if (curIndex.row == newIndex.row) {
        grid[curIndex.row] = grid[curIndex.row].reversed.toList();
      } else if (curIndex.size == ElementSize.square && newIndex.size == ElementSize.square) {
        var draggedCard = grid[curIndex.row][curIndex.column];
        grid[curIndex.row][curIndex.column] = grid[newIndex.row][newIndex.column];
        grid[newIndex.row][newIndex.column] = draggedCard;
      } else {
        var draggedRow = grid.removeAt(curIndex.row);
        grid.insert(newIndex.row, draggedRow);
      }
    });
  }

  @override
  void removeItem(Key key) {
    var index = indexOf(key);
    _removeAtIndex(index);
  }

  void _removeAtIndex(GridIndex index) {
    var itemSize = getSize(grid[index.row][index.column].key);

    if (index.row == grid.length - 1) {
      if (index.column == 1) {
        grid[index.row].removeAt(1);
      } else {
        if (index.size == ElementSize.wide) {
          grid.removeAt(index.row);
        } else {
          if (grid[index.row].length == 2) {
            var siblingItem = grid[index.row][1];
            translateX(siblingItem.key, itemSize.width + spacing);

            grid[index.row].removeAt(0);
          } else {
            grid.removeAt(index.row);
          }
        }
      }
    } else {
      var belowRow = grid[index.row + 1];

      if (index.size == ElementSize.wide) {
        translateY(belowRow[0].key, itemSize.height + spacing);
        grid[index.row][0] = belowRow[0];

        if (belowRow.length == 2) {
          translateY(belowRow[1].key, itemSize.height + spacing);

          if (grid[index.row].length == 2) {
            grid[index.row][1] = belowRow[1];
          } else {
            grid[index.row].add(belowRow[1]);
          }
        } else if (grid[index.row].length == 2) {
          grid[index.row].removeAt(1);
        }

        _removeAtIndex(GridIndex(index.row + 1, 0, ElementSize.wide));
      } else {
        if (belowRow.length == 2) {
          translateY(belowRow[index.column].key, itemSize.height + spacing);

          grid[index.row][index.column] = belowRow[index.column];

          _removeAtIndex(GridIndex(index.row + 1, index.column, ElementSize.square));
        } else {
          if (index.column == 0) {
            if (belowRow[0].size == ElementSize.square) {
              translateY(belowRow[0].key, itemSize.height + spacing);

              grid[index.row][0] = belowRow[0];

              _removeAtIndex(GridIndex(index.row + 1, index.column, ElementSize.square));
            } else {
              translateY(belowRow[0].key, itemSize.height + spacing);
              translateY(grid[index.row][1].key, -itemSize.height - spacing);

              var sibling = grid[index.row][1];
              grid[index.row] = [belowRow[0]];
              belowRow.add(sibling);

              _removeAtIndex(GridIndex(index.row + 1, index.column, ElementSize.square));
            }
          } else {
            if (belowRow[0].size == ElementSize.square) {
              translateY(belowRow[0].key, itemSize.height + spacing);
              translateX(belowRow[0].key, -itemSize.width - spacing);

              grid[index.row][1] = belowRow[0];

              _removeAtIndex(GridIndex(index.row + 1, 0, ElementSize.square));
            } else {
              translateY(belowRow[0].key, itemSize.height + spacing);
              translateY(grid[index.row][0].key, -itemSize.height - spacing);

              grid[index.row + 1] = grid[index.row];
              grid[index.row] = belowRow;

              _removeAtIndex(GridIndex(index.row + 1, index.column, ElementSize.square));
            }
          }
        }
      }
    }
  }
}
