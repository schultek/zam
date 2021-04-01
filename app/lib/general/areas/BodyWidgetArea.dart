part of areas;

class BodyWidgetArea extends WidgetArea<BodySegment> {
  final ScrollController scrollController;
  BodyWidgetArea(this.scrollController) : super("body");

  @override
  State<StatefulWidget> createState() => BodyWidgetAreaState();
}

class BodyWidgetAreaState extends WidgetAreaState<BodyWidgetArea, BodySegment> {
  List<List<BodySegment>> grid = [];

  @override
  initAreaState() {
    List<BodySegment> row;
    for (BodySegment segment in selectedWidgets) {
      if (segment.size == SegmentSize.Square) {
        if (row == null) {
          row = List()..add(segment);
          grid.add(row);
        } else {
          row.add(segment);
          row = null;
        }
      } else {
        grid.add(List()..add(segment));
      }
    }
  }

  @override
  EdgeInsetsGeometry getPadding() => const EdgeInsets.all(0);

  Widget buildArea(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
      curve: Curves.easeInOut,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: grid.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: index == grid.length - 1 ? 10 : 20, left: 10, right: 10),
          child: grid[index][0].size == SegmentSize.Wide
              ? grid[index][0]
              : Row(children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: grid[index][0],
                  ),
                  Container(width: 20),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: grid[index].length == 2 ? grid[index][1] : Container(),
                  )
                ]),
        ),
      ),
    );
  }

  @override
  bool hasKey(Key key) {
    return grid.any((row) => row.any((segment) => segment.key == key));
  }

  GridIndex indexOf(Key key) {
    var rowIndex = grid.indexWhere((List<BodySegment> row) => row.any((segment) => segment.key == key));
    var columnIndex = grid[rowIndex].indexWhere((card) => card.key == key);
    return GridIndex(rowIndex, columnIndex, grid[rowIndex][columnIndex].size);
  }

  @override
  BodySegment getWidgetFromKey(Key key) {
    var index = indexOf(key);
    return grid[index.row][index.column];
  }

  void onReorder(Key draggedItem, Key newPosition) {
    GridIndex curIndex = indexOf(draggedItem);
    GridIndex newIndex = indexOf(newPosition);

    setState(() {
      if (curIndex.row == newIndex.row) {
        grid[curIndex.row] = grid[curIndex.row].reversed.toList();
      } else if (curIndex.size == SegmentSize.Square && newIndex.size == SegmentSize.Square) {
        var draggedCard = grid[curIndex.row][curIndex.column];
        grid[curIndex.row][curIndex.column] = grid[newIndex.row][newIndex.column];
        grid[newIndex.row][newIndex.column] = draggedCard;
      } else {
        var draggedRow = grid.removeAt(curIndex.row);
        grid.insert(newIndex.row, draggedRow);
      }
    });
  }

  void onWidgetRemoved(Key key) {
    var index = indexOf(key);
    this.checkRemovePosition(index);
    this.updateIndices();
  }

  @override
  void cancelDrop(Key key) {
    setState(() {
      onWidgetRemoved(key);
    });
  }

  bool _scheduledRebuild = false;

  @override
  bool checkDropPosition(Offset offset, BodySegment item) {
    if (_scheduledRebuild) {
      return true;
    }

    if (hasKey(item.key)) {
      if (checkDragPosition(offset, item.key)) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _scheduledRebuild = false;
        });
        _scheduledRebuild = true;
      }
      return true;
    }

    setState(() {
      if (grid.length == 0 || grid[grid.length - 1][0].size == SegmentSize.Wide || grid[grid.length - 1].length == 2) {
        grid.add([item]);
      } else if (item.size == SegmentSize.Wide) {
        grid.insert(grid.length - 1, [item]);
      } else {
        grid[grid.length - 1].add(item);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      while (checkDragPosition(offset, item.key)) {}
      _scheduledRebuild = false;
    });
    _scheduledRebuild = true;

    return true;
  }

  void onDrop() {
    updateIndices();
  }

  @override
  BoxConstraints constrainWidget(BodySegment widget) {
    if (widget.size == SegmentSize.Wide) {
      return BoxConstraints(maxWidth: areaSize.width - 20);
    } else {
      return BoxConstraints(maxWidth: (areaSize.width - 40) / 2);
    }
  }

  Future<void> updateIndices() async {
    List<BodySegment> sortedWidgets = [];
    for (var row in grid) {
      for (var item in row) {
        sortedWidgets.add(item);
      }
    }

    selectedWidgets = sortedWidgets;

    // await FirebaseFirestore.instance.collection("trips").doc(widget.trip.id).update({
    //   "modules": sortedWidgets.map((w) => w.id).toList(),
    // });
  }

  bool _scrolling = false;

  void maybeScroll(Offset dragOffset, Key itemKey, Offset itemOffset, Size itemSize) async {
    if (false && !_scrolling) {
      final position = widget.scrollController.position;
      int duration = 15; // in ms

      MediaQueryData d = MediaQuery.of(context);

      double top = d?.padding?.top ?? 0.0;
      double bottom = widget.scrollController.position.viewportDimension - (d?.padding?.bottom ?? 0.0);

      double newOffset = checkScrollPosition(position, itemOffset, itemSize, top, bottom);

      if (newOffset != null && (newOffset - position.pixels).abs() >= 1.0) {
        _scrolling = true;
        await widget.scrollController.position
            .animateTo(newOffset, duration: Duration(milliseconds: duration), curve: Curves.linear);
        _scrolling = false;
        if (hasKey(itemKey)) {
          checkDragPosition(dragOffset, itemKey);
        }
      }
    }
  }

  bool checkDragPosition(Offset offset, Key itemKey) {
    var managerState = WidgetTemplate.of(context, listen: false).reorderable;

    Offset itemOffset = managerState.itemOffset(itemKey) - areaOffset;
    Size itemSize = managerState.itemSize(itemKey);

    maybeScroll(offset, itemKey, itemOffset, itemSize);

    if (offset.dy < itemOffset.dy - itemSize.height / 2 - 20) {
      var dragIndex = indexOf(itemKey);
      if (dragIndex.row > 0) {
        var aboveRow = grid[dragIndex.row - 1];

        if (dragIndex.size == SegmentSize.Wide) {
          onReorder(itemKey, aboveRow[0].key);

          managerState.translateItemY(aboveRow[0].key, -itemSize.height - 20);
          if (aboveRow.length == 2) managerState.translateItemY(aboveRow[1].key, -itemSize.height - 20);
        } else {
          if (aboveRow.length == 2) {
            var aboveItem = aboveRow[dragIndex.column];

            onReorder(itemKey, aboveItem.key);
            managerState.translateItemY(aboveItem.key, -itemSize.height - 20);
          } else if (grid[dragIndex.row].length == 2) {
            var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

            onReorder(itemKey, aboveRow[0].key);
            managerState.translateItemY(aboveRow[0].key, -itemSize.height - 20);
            managerState.translateItemY(siblingItem.key, itemSize.height + 20);
          }
        }

        return true;
      }
    } else if (offset.dy > itemOffset.dy + itemSize.height / 2 + 20) {
      var dragIndex = indexOf(itemKey);
      if (dragIndex.row < grid.length - 1) {
        var belowRow = grid[dragIndex.row + 1];

        if (dragIndex.size == SegmentSize.Wide) {
          if (belowRow[0].size == SegmentSize.Wide || belowRow.length == 2) {
            onReorder(itemKey, belowRow[0].key);

            managerState.translateItemY(belowRow[0].key, itemSize.height + 20);
            if (belowRow.length == 2) managerState.translateItemY(belowRow[1].key, itemSize.height + 20);
          }
        } else {
          if (belowRow.length == 2) {
            var belowItem = belowRow[dragIndex.column];

            onReorder(itemKey, belowItem.key);
            managerState.translateItemY(belowItem.key, itemSize.height + 20);
          } else if (belowRow[0].size == SegmentSize.Wide) {
            var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

            onReorder(itemKey, belowRow[0].key);
            managerState.translateItemY(belowRow[0].key, itemSize.height + 20);
            managerState.translateItemY(siblingItem.key, -itemSize.height - 20);
          } else if (dragIndex.column == 0) {
            var belowItem = belowRow[0];

            onReorder(itemKey, belowItem.key);
            managerState.translateItemY(belowItem.key, itemSize.height + 20);
          } else {
            var siblingItem = grid[dragIndex.row][0];
            var belowItem = belowRow[0];

            onReorder(itemKey, siblingItem.key);
            onReorder(itemKey, belowItem.key);

            managerState.translateItemX(siblingItem.key, -itemSize.width - 20);
            managerState.translateItemY(belowItem.key, itemSize.height + 20);
          }
        }

        return true;
      }
    } else if ((offset.dx - itemOffset.dx).abs() > itemSize.width / 2 + 20) {
      var dragIndex = indexOf(itemKey);
      if (dragIndex.size == SegmentSize.Square && grid[dragIndex.row].length == 2) {
        var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

        onReorder(itemKey, siblingItem.key);

        var sign = dragIndex.column == 0 ? 1 : -1;
        managerState.translateItemX(siblingItem.key, sign * (itemSize.width + 20));

        return true;
      }
    }

    return false;
  }

  @override
  double checkScrollPosition(ScrollPosition position, Offset dragOffset, Size dragSize, double top, double bottom) {
    double step = 1.0;
    double overdragMax = 40.0;
    double overdragCoef = 5.0;

    if (dragOffset.dy < top && position.pixels > position.minScrollExtent) {
      final overdrag = max(top - dragOffset.dy, overdragMax);
      return max(position.minScrollExtent, position.pixels - step * overdrag / overdragCoef);
    } else if (dragOffset.dy + dragSize.height > bottom && position.pixels < position.maxScrollExtent) {
      final overdrag = max<double>(dragOffset.dy + dragSize.height - bottom, overdragMax);
      return min(position.maxScrollExtent, position.pixels + step * overdrag / overdragCoef);
    } else {
      return null;
    }
  }

  void checkRemovePosition(GridIndex index) {
    var managerState = WidgetTemplate.of(context, listen: false).reorderable;

    var itemSize = managerState.itemSize(grid[index.row][index.column].key);

    if (index.row == grid.length - 1) {
      if (index.column == 1) {
        grid[index.row].removeAt(1);
      } else {
        if (index.size == SegmentSize.Wide) {
          grid.removeAt(index.row);
        } else {
          if (grid[index.row].length == 2) {
            var siblingItem = grid[index.row][1];
            managerState.translateItemX(siblingItem.key, itemSize.width + 20);

            grid[index.row].removeAt(0);
          } else {
            grid.removeAt(index.row);
          }
        }
      }
    } else {
      var belowRow = grid[index.row + 1];

      if (index.size == SegmentSize.Wide) {
        managerState.translateItemY(belowRow[0].key, itemSize.height + 20);
        grid[index.row][0] = belowRow[0];

        if (belowRow.length == 2) {
          managerState.translateItemY(belowRow[1].key, itemSize.height + 20);

          if (grid[index.row].length == 2) {
            grid[index.row][1] = belowRow[1];
          } else {
            grid[index.row].add(belowRow[1]);
          }
        } else if (grid[index.row].length == 2) {
          grid[index.row].removeAt(1);
        }

        checkRemovePosition(GridIndex(index.row + 1, 0, SegmentSize.Wide));
      } else {
        if (belowRow.length == 2) {
          managerState.translateItemY(belowRow[index.column].key, itemSize.height + 20);

          grid[index.row][index.column] = belowRow[index.column];

          checkRemovePosition(GridIndex(index.row + 1, index.column, SegmentSize.Square));
        } else {
          if (index.column == 0) {
            if (belowRow[0].size == SegmentSize.Square) {
              managerState.translateItemY(belowRow[0].key, itemSize.height + 20);

              grid[index.row][0] = belowRow[0];

              checkRemovePosition(GridIndex(index.row + 1, index.column, SegmentSize.Square));
            } else {
              managerState.translateItemY(belowRow[0].key, itemSize.height + 20);
              managerState.translateItemY(grid[index.row][1].key, -itemSize.height - 20);

              grid[index.row][0] = belowRow[0];
              belowRow.add(grid[index.row][1]);

              checkRemovePosition(GridIndex(index.row + 1, index.column, SegmentSize.Square));
            }
          } else {
            if (belowRow[0].size == SegmentSize.Square) {
              managerState.translateItemY(belowRow[0].key, itemSize.height + 20);
              managerState.translateItemX(belowRow[0].key, -itemSize.width - 20);

              grid[index.row][1] = belowRow[0];

              checkRemovePosition(GridIndex(index.row + 1, 0, SegmentSize.Square));
            } else {
              managerState.translateItemY(belowRow[0].key, itemSize.height + 20);
              managerState.translateItemY(grid[index.row][0].key, -itemSize.height - 20);

              grid[index.row + 1] = grid[index.row];
              grid[index.row] = belowRow;

              checkRemovePosition(GridIndex(index.row + 1, index.column, SegmentSize.Square));
            }
          }
        }
      }
    }
  }
}

class GridIndex {
  int row, column;
  SegmentSize size;
  GridIndex(this.row, this.column, this.size);
}
