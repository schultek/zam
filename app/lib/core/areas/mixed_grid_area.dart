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

  @override
  Widget buildArea(BuildContext context) {
    Widget child = Container();

    if (!isLoading) {
      child = AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.topCenter,
        curve: Curves.easeInOut,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: grid.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: index == grid.length - 1 ? 10 : 20, left: 10, right: 10),
            child: grid[index][0].size == ElementSize.wide
                ? grid[index][0]
                : Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: grid[index][0],
                      ),
                      Container(width: 20),
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
  BoxConstraints constrainWidget(ContentElement widget) {
    if (widget.size == ElementSize.wide) {
      return BoxConstraints(maxWidth: areaSize.width - 20);
    } else {
      return BoxConstraints(maxWidth: (areaSize.width - 40) / 2);
    }
  }

  @override
  ScrollController get scrollController => widget.scrollController;

  @override
  bool scrollDownEnabled = false; // TODO find something better

  @override
  bool didReorderItem(Offset offset, Key itemKey) {
    Offset itemOffset = getOffset(itemKey);
    Size itemSize = getSize(itemKey);

    maybeScroll(offset, itemKey, itemSize);

    if (offset.dy < itemOffset.dy - 20) {
      var dragIndex = indexOf(itemKey);
      if (dragIndex.row > 0) {
        var aboveRow = grid[dragIndex.row - 1];
        var aboveSize = getSize(aboveRow[0].key);

        if (offset.dy < itemOffset.dy - aboveSize.height / 2 - 20) {
          if (dragIndex.size == ElementSize.wide) {
            _onReorder(itemKey, aboveRow[0].key);

            translateY(aboveRow[0].key, -itemSize.height - 20);
            if (aboveRow.length == 2) translateY(aboveRow[1].key, -itemSize.height - 20);
          } else {
            if (aboveRow.length == 2) {
              var aboveItem = aboveRow[dragIndex.column];

              _onReorder(itemKey, aboveItem.key);
              translateY(aboveItem.key, -itemSize.height - 20);
            } else if (grid[dragIndex.row].length == 2) {
              var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

              _onReorder(itemKey, aboveRow[0].key);
              translateY(aboveRow[0].key, -itemSize.height - 20);
              translateY(siblingItem.key, itemSize.height + 20);
            }
          }

          return true;
        }
      }
    } else if (offset.dy > itemOffset.dy + 20) {
      var dragIndex = indexOf(itemKey);
      if (dragIndex.row < grid.length - 1) {
        var belowRow = grid[dragIndex.row + 1];
        var belowSize = getSize(belowRow[0].key);

        if (offset.dy > itemOffset.dy + belowSize.height / 2 + 20) {
          if (dragIndex.size == ElementSize.wide) {
            if (belowRow[0].size == ElementSize.wide || belowRow.length == 2) {
              _onReorder(itemKey, belowRow[0].key);

              translateY(belowRow[0].key, itemSize.height + 20);
              if (belowRow.length == 2) {
                translateY(belowRow[1].key, itemSize.height + 20);
              }
            }
          } else {
            if (belowRow.length == 2) {
              var belowItem = belowRow[dragIndex.column];

              _onReorder(itemKey, belowItem.key);
              translateY(belowItem.key, itemSize.height + 20);
            } else if (belowRow[0].size == ElementSize.wide) {
              var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

              _onReorder(itemKey, belowRow[0].key);
              translateY(belowRow[0].key, itemSize.height + 20);
              translateY(siblingItem.key, -itemSize.height - 20);
            } else if (dragIndex.column == 0) {
              var belowItem = belowRow[0];

              _onReorder(itemKey, belowItem.key);
              translateY(belowItem.key, itemSize.height + 20);
            } else {
              var siblingItem = grid[dragIndex.row][0];
              var belowItem = belowRow[0];

              _onReorder(itemKey, siblingItem.key);
              _onReorder(itemKey, belowItem.key);

              translateX(siblingItem.key, -itemSize.width - 20);
              translateY(belowItem.key, itemSize.height + 20);
            }
          }

          return true;
        }
      }
    } else if ((offset.dx - itemOffset.dx).abs() > itemSize.width / 2 + 20) {
      var dragIndex = indexOf(itemKey);
      if (dragIndex.size == ElementSize.square && grid[dragIndex.row].length == 2) {
        var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

        _onReorder(itemKey, siblingItem.key);

        var sign = dragIndex.column == 0 ? 1 : -1;
        translateX(siblingItem.key, sign * (itemSize.width + 20));

        return true;
      }
    }

    return false;
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
            translateX(siblingItem.key, itemSize.width + 20);

            grid[index.row].removeAt(0);
          } else {
            grid.removeAt(index.row);
          }
        }
      }
    } else {
      var belowRow = grid[index.row + 1];

      if (index.size == ElementSize.wide) {
        translateY(belowRow[0].key, itemSize.height + 20);
        grid[index.row][0] = belowRow[0];

        if (belowRow.length == 2) {
          translateY(belowRow[1].key, itemSize.height + 20);

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
          translateY(belowRow[index.column].key, itemSize.height + 20);

          grid[index.row][index.column] = belowRow[index.column];

          _removeAtIndex(GridIndex(index.row + 1, index.column, ElementSize.square));
        } else {
          if (index.column == 0) {
            if (belowRow[0].size == ElementSize.square) {
              translateY(belowRow[0].key, itemSize.height + 20);

              grid[index.row][0] = belowRow[0];

              _removeAtIndex(GridIndex(index.row + 1, index.column, ElementSize.square));
            } else {
              translateY(belowRow[0].key, itemSize.height + 20);
              translateY(grid[index.row][1].key, -itemSize.height - 20);

              grid[index.row][0] = belowRow[0];
              belowRow.add(grid[index.row][1]);

              _removeAtIndex(GridIndex(index.row + 1, index.column, ElementSize.square));
            }
          } else {
            if (belowRow[0].size == ElementSize.square) {
              translateY(belowRow[0].key, itemSize.height + 20);
              translateX(belowRow[0].key, -itemSize.width - 20);

              grid[index.row][1] = belowRow[0];

              _removeAtIndex(GridIndex(index.row + 1, 0, ElementSize.square));
            } else {
              translateY(belowRow[0].key, itemSize.height + 20);
              translateY(grid[index.row][0].key, -itemSize.height - 20);

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
