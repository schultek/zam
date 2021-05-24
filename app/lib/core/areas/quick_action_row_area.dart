part of areas;

class QuickActionRowArea extends WidgetArea<QuickAction> {
  const QuickActionRowArea(String id) : super(id);

  @override
  State<StatefulWidget> createState() => QuickActionRowAreaState();
}

class QuickActionRowAreaState extends WidgetAreaState<QuickActionRowArea, QuickAction> {
  late List<QuickAction> row;
  final _boxKey = GlobalKey();

  @override
  void initArea(List<QuickAction> widgets) => row = widgets;

  @override
  List<QuickAction> getWidgets() => row;

  @override
  Widget buildArea(BuildContext context) {
    return SizedBox(
      key: _boxKey,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: row,
      ),
    );
  }

  @override
  BoxConstraints constrainWidget(QuickAction widget) => const BoxConstraints();

  @override
  QuickAction getWidgetFromKey(Key key) => row.firstWhere((e) => e.key == key);

  @override
  bool hasKey(Key key) => row.any((e) => e.key == key);

  @override
  bool canInsertItem(_) => row.length < 3;

  @override
  void insertItem(QuickAction item) => setState(() => row.add(item));

  @override
  void removeItem(Key key) {
    var index = row.indexWhere((w) => w.key == key);
    removeAtIndex(index);
  }

  @override
  bool didReorderItem(Offset offset, Key itemKey) {
    Offset itemOffset = getOffset(itemKey);
    Size itemSize = getSize(itemKey);

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
