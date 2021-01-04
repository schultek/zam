part of areas;

class QuickActionRowArea extends WidgetArea<QuickAction> {
  QuickActionRowArea(String id) : super(id);

  @override
  State<StatefulWidget> createState() => QuickActionRowAreaState();
}

class QuickActionRowAreaState extends WidgetAreaState<QuickActionRowArea, QuickAction> {
  List<QuickAction> row;

  @override
  void initAreaState() {
    row = [];
  }

  @override
  Widget buildArea(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: row,
      ),
    );
  }

  @override
  BoxConstraints constrainWidget(QuickAction widget) {
    // TODO: implement constrainWidget
    throw UnimplementedError();
  }

  @override
  QuickAction getWidgetFromKey(Key key) {
    return row.firstWhere((e) => e.key == key, orElse: () => null);
  }

  @override
  bool hasKey(Key key) {
    return row.any((e) => e.key == key);
  }

  bool _scheduledRebuild = false;

  @override
  bool checkDropPosition(Offset offset, QuickAction item) {
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

    if (row.length >= 3) {
      return false;
    }

    setState(() {
      row.add(item);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      while (checkDragPosition(offset, item.key)) {}

      _scheduledRebuild = false;
    });
    _scheduledRebuild = true;

    return true;
  }

  bool checkDragPosition(Offset offset, Key itemKey) {
    var managerState = WidgetTemplate.of(context, listen: false).reorderable;

    Offset itemOffset = managerState.itemOffset(itemKey) - areaOffset;
    Size itemSize = managerState.itemSize(itemKey);

    int index = row.indexWhere((e) => e.key == itemKey);

    if (index > 0 && offset.dx < itemOffset.dx - itemSize.width / 2 - 20) {
      var draggedItem = row.removeAt(index);
      row.insert(index - 1, draggedItem);
      return true;
    } else if (index < row.length - 1 && offset.dx > itemOffset.dx + itemSize.width / 2 + 20) {
      var draggedItem = row.removeAt(index);
      row.insert(index + 1, draggedItem);
      return true;
    }
    return false;
  }

  @override
  void onDrop() {
    selectedWidgets = row;
  }

  @override
  void cancelDrop(Key key) {
    setState(() {
      onWidgetRemoved(key);
    });
  }

  @override
  void onWidgetRemoved(Key key) {
    row.removeWhere((e) => e.key == key);
  }
}
