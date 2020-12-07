part of areas;

class BodyWidgetArea extends WidgetArea<BodySegment> {

  BodyWidgetArea() : super("body");

  @override
  State<StatefulWidget> createState() => BodyWidgetAreaState();
}

class BodyWidgetAreaState extends WidgetAreaState<BodySegment> {

  List<List<BodySegment>> grid = [];

  @override
  initState() {
    super.initState();

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

  Widget buildArea(BuildContext context) {
    return ListView.builder(
      itemCount: grid.length,
      itemBuilder: (context, index) {
        var row = grid[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: row[0].size == SegmentSize.Wide
              ? row[0]
              : Row(children: [
            Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: row[0],
            ),
            Container(width: 20),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: row.length == 2
                  ? row[1]
                  : Container(),
            )
          ]),
        );
      },
    );
  }

  @override
  bool checkDragPosition({offset, Offset itemOffset, Size itemSize, Key itemKey, ReorderableListState listState}) {

    if (offset.dy < itemOffset.dy - itemSize.height / 2 - 20) {
      var dragIndex = indexOf(itemKey);
      if (dragIndex.row > 0) {
        var aboveRow = grid[dragIndex.row - 1];

        if (dragIndex.size == SegmentSize.Wide) {
          onReorder(itemKey, aboveRow[0].key);

          listState.adjustItemTranslationY(aboveRow[0].key, -itemSize.height);
          if (aboveRow.length == 2) listState.adjustItemTranslationY(aboveRow[1].key, -itemSize.height);
        } else {
          if (aboveRow.length == 2) {
            var aboveItem = aboveRow[dragIndex.column];

            onReorder(itemKey, aboveItem.key);
            listState.adjustItemTranslationY(aboveItem.key, -itemSize.height);
          } else {
            var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

            onReorder(itemKey, aboveRow[0].key);
            listState.adjustItemTranslationY(aboveRow[0].key, -itemSize.height);
            listState.adjustItemTranslationY(siblingItem.key, itemSize.height);
          }
        }

        return true;
      }
    } else if (offset.dy > itemOffset.dy + itemSize.height / 2 + 20) {
      var dragIndex = indexOf(itemKey);
      if (dragIndex.row < grid.length - 1) {
        var belowRow = grid[dragIndex.row + 1];

        if (dragIndex.size == SegmentSize.Wide) {
          onReorder(itemKey, belowRow[0].key);

          listState.adjustItemTranslationY(belowRow[0].key, itemSize.height);
          if (belowRow.length == 2) listState.adjustItemTranslationY(belowRow[1].key, itemSize.height);
        } else {
          if (belowRow.length == 2) {
            var belowItem = belowRow[dragIndex.column];

            onReorder(itemKey, belowItem.key);
            listState.adjustItemTranslationY(belowItem.key, itemSize.height);
          } else {
            var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

            onReorder(itemKey, belowRow[0].key);
            listState.adjustItemTranslationY(belowRow[0].key, itemSize.height);
            listState.adjustItemTranslationY(siblingItem.key, -itemSize.height);
          }
        }

        return true;
      }
    } else if ((offset.dx - itemOffset.dx).abs() > itemSize.width / 2 + 20) {

      var dragIndex = indexOf(itemKey);
      if (dragIndex.size == SegmentSize.Square) {

        var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

        onReorder(itemKey, siblingItem.key);

        var sign = dragIndex.column == 0 ? 1 : -1;
        listState.adjustItemTranslationX(siblingItem.key, sign * itemSize.width, itemSize.width);

        return true;
      }
    }

    return false;
  }

  GridIndex indexOf(Key key) {
    var rowIndex = grid.indexWhere((List<BodySegment> row) => row.any((segment) => segment.key == key));
    var columnIndex = grid[rowIndex].indexWhere((card) => card.key == key);
    return GridIndex(rowIndex, columnIndex, grid[rowIndex][columnIndex].size);
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

  @override
  void removeItem(Key key) {
    setState(() {
      var index = indexOf(key);

      selectedWidgets.remove(grid[index.row][index.column]);

      grid[index.row].removeAt(index.column);
      if (grid[index.row].length == 0) {
        grid.removeAt(index.row);
      }

      //this.updateIndices();
    });
  }




  /*

  Future<void> updateIndices() async {
    List<String> sortedIds = [];
    for (var row in grid) {
      for (var item in row) {
        sortedIds.add(item.id);
      }
    }

    await FirebaseFirestore.instance.collection("trips").doc(widget.trip.id).update({
      "modules": sortedIds,
    });
  }

  void addCard(ModuleCard card) {
    setState(() {
      selectedModuleCards.add(card);
      if (grid.isNotEmpty && grid.last.length == 1 && grid.last[0].size == SegmentSize.Square) {
        if (card.size == SegmentSize.Square) {
          grid.last.add(card);
        } else {
          grid.insert(grid.length-1, [card]);
        }
      } else {
        grid.add([card]);
      }
      this.updateIndices();
    });
  }

  void removeCard(BuildContext context, ModuleCard card) {

  }
   */

}

class GridIndex {
  int row, column;
  SegmentSize size;
  GridIndex(this.row, this.column, this.size);
}