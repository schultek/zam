import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../supply_models.dart';
import '../supply_repository.dart';
import 'dialogs/shopping_list_dialog.dart';
import 'edit_shopping_list_screen.dart';

class ShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        title: const Text("Einkaufslisten"),
      ),
      body: Selector<SupplyRepository, List<ShoppingList>>(
        selector: (context, repository) => repository.articleLists.whereType<ShoppingList>().toList(),
        builder: (context, lists, _) {
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(lists[index].name),
                subtitle: Text("${lists[index].entries.length} Artikel"),
                onTap: () {
                  ShoppingListDialog.open(context, lists[index].id);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    DeleteListDialog.open(context, lists[index]);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => SupplyProvider.of(context, child: const EditShoppingListPage(null))),
          );
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class DeleteListDialog extends StatefulWidget {
  final ArticleList list;
  const DeleteListDialog(this.list);

  @override
  _DeleteListDialogState createState() => _DeleteListDialogState();

  static dynamic open(BuildContext context, ArticleList list) {
    return showDialog(context: context, builder: (_) => SupplyProvider.of(context, child: DeleteListDialog(list)));
  }
}

class _DeleteListDialogState extends State<DeleteListDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Wirklich die ganze Einkaufsliste löschen?"),
      content: Text(widget.list.name),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Abbrechen"),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade300),
          ),
          onPressed: () {
            Provider.of<SupplyRepository>(context, listen: false).removeShoppingList(widget.list.id);
            Navigator.of(context).pop();
          },
          child: const Text("Löschen"),
        ),
      ],
    );
  }
}
