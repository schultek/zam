import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../SupplyModels.dart';
import '../SupplyRepository.dart';
import 'EditShoppingListPage.dart';
import 'ShoppingListDialog.dart';

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
        title: Text("Einkaufslisten"),
      ),
      body: Container(
        child: Selector<SupplyRepository, List<ShoppingList>>(
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
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        DeleteListDialog.open(context, lists[index]);
                      },
                    ));
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => SupplyProvider.of(context, child: EditShoppingListPage(null))));
        },
      ),
    );
  }
}

class DeleteListDialog extends StatefulWidget {
  final ArticleList list;

  DeleteListDialog(this.list);
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
      title: Text("Wirklich die ganze Einkaufsliste löschen?"),
      content: Text(widget.list.name),
      actions: <Widget>[
        TextButton(
          child: Text("Abbrechen"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text("Löschen"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade300),
          ),
          onPressed: () {
            Provider.of<SupplyRepository>(context, listen: false).removeShoppingList(widget.list.id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
