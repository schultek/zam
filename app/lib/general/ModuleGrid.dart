part of module;

class GridIndex {
  int row, column;
  CardSize size;
  GridIndex(this.row, this.column, this.size);
}

class ModuleGrid {
  List<List<ModuleCard>> grid = [];

  ModuleGrid(List<ModuleCard> moduleCards) {
    moduleCards.sort((a, b) => a.index - b.index);

    List<ModuleCard> row;
    for (ModuleCard card in moduleCards) {
      if (card.size == CardSize.Square) {
        if (row == null) {
          row = List()..add(card);
          grid.add(row);
        } else {
          row.add(card);
          row = null;
        }
      } else {
        grid.add(List()..add(card));
      }
    }
  }

  List<Widget> buildSlivers() {
    List<Widget> slivers = [
      SliverList(
        delegate: SliverChildListDelegate.fixed(grid
            .map((row) => Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: row[0].size == CardSize.Wide
                      ? buildItem(row[0])
                      : Row(children: [
                          Flexible(child: buildItem(row[0])),
                          Container(width: 20),
                          Flexible(child: buildItem(row[1]))
                        ]),
                ))
            .toList()),
      ),
    ];

    return slivers;
  }

  buildItem(ModuleCard card) {
    return ReorderableItem(
        key: card.key,
        childBuilder: (context, state) {
          if (state == ReorderableItemState.placeholder) {
            return AspectRatio(
              aspectRatio: card.size == CardSize.Square ? 1 / 1 : 2 / 1,
              child: Material(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.grey[300].withOpacity(.2),
                  child: Container()),
            );
          }
          return DelayedReorderableListener(child: card);
        });
  }

  GridIndex indexOf(Key key) {
    var rowIndex = grid.indexWhere((List<ModuleCard> row) => row.any((card) => card.key == key));
    var columnIndex = grid[rowIndex].indexWhere((card) => card.key == key);
    return GridIndex(rowIndex, columnIndex, grid[rowIndex][columnIndex].size);
  }

  void onReorder(Key draggedItem, Key newPosition) {
    GridIndex curIndex = indexOf(draggedItem);
    GridIndex newIndex = indexOf(newPosition);

    var draggedRow = grid.removeAt(curIndex.row);
    grid.insert(newIndex.row, draggedRow);
  }
}
