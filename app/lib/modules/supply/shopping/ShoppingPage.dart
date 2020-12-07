import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../SupplyModels.dart';
import '../SupplyRepository.dart';
import 'AddArticlePage.dart';
import 'AddShoppingListPage.dart';

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
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        children: [
          SpeedDialChild(
              child: Icon(Icons.fastfood),
              label: "Artikel hinzufügen",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => SupplyProvider.of(context, child: AddArticlePage())));
              }),
          SpeedDialChild(
              child: Icon(Icons.shopping_cart),
              label: "Einkaufsliste hinzufügen",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => SupplyProvider.of(context, child: AddShoppingListPage())));
              }),
        ],
      ),
    );
  }
}

class ShoppingListDialog extends StatefulWidget {
  final String id;

  ShoppingListDialog(this.id);

  @override
  _ShoppingListDialogState createState() => _ShoppingListDialogState();

  static Future<void> open(BuildContext context, String id) async {
    await showDialog(
      context: context,
      builder: (_context) => SupplyProvider.of(context, child: ShoppingListDialog(id)),
    );
  }
}

class _ShoppingListDialogState extends State<ShoppingListDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Selector<SupplyRepository, ArticleList>(
          builder: (BuildContext context, ArticleList list, _){
            return Text(list.name);
          },
          selector: (BuildContext context, SupplyRepository repo) {
            return repo.getArticleListById(widget.id);
          },
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Selector<SupplyRepository, ArticleList>(
          builder: (BuildContext context, ArticleList list, _){
            return ListView.builder(
              itemCount: list.entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Selector<SupplyRepository, Article>(
                    builder: (BuildContext context, Article article, _){
                      return CheckboxListTile(
                          title: Text(article.name),
                          value: list.entries[index].checked,
                          onChanged: (value) {
                            list.entries[index].checked = value;
                            Provider.of<SupplyRepository>(context, listen: false).updateShoppingList(list);
                          },
                      );
                    },
                    selector: (BuildContext context, SupplyRepository repo) {
                      return repo.getArticleById(list.entries[index].articleId);
                    },
                  );
              },
            );
          },
          selector: (BuildContext context, SupplyRepository repo) {
            return repo.getArticleListById(widget.id);
          },
        ),

      ),
    );
  }
}

