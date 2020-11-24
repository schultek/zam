import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../SupplyModels.dart';
import '../SupplyRepository.dart';

class AddShoppingListPage extends StatefulWidget {
  @override
  _AddShoppingListPageState createState() => _AddShoppingListPageState();
}

class _AddShoppingListPageState extends State<AddShoppingListPage> {
  String listName = "";
  ArticleEntry currentEntry;
  List<ArticleEntry> listEntries = [];

  TextEditingController articleController;

  @override
  void initState() {
    super.initState();
    articleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Speichern",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await Provider.of<SupplyRepository>(context, listen: false).saveShoppingList(listName, listEntries);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Titel',
              ),
              onChanged: (String name) {
                listName = name;
              },
            ),
            Container(height: 20),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Suche nach Artikeln oder Rezepten',
              )),
              suggestionsCallback: (pattern) async {
                SupplyRepository repository = Provider.of<SupplyRepository>(context, listen: false);
                List<dynamic> articles =
                    repository.articles.where((article) => article.name.toLowerCase().contains(pattern.toLowerCase())).toList();
                List<dynamic> recipes = repository.articleLists
                    .whereType<Recipe>()
                    .where((recipe) => recipe.name.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
                return articles + recipes;
              },
              itemBuilder: (context, dynamic suggestion) {
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(suggestion.name),
                );
              },
              onSuggestionSelected: (suggestion) async {
                if (suggestion is Article) {
                  ArticleEntry articleEntry = await ArticleEntryDialog.open(context, suggestion);
                  if (articleEntry != null) {
                    setState(() {
                      listEntries.add(articleEntry);
                    });
                  }
                } else if (suggestion is Recipe) {
                  List<ArticleEntry> articleEntries = await RecipeDialog.open(context, suggestion);
                  if (articleEntries != null) {
                    setState(() {
                    listEntries.addAll(articleEntries);
                    });
                  }
                }
                articleController.text = "";
              },
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: listEntries.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(listEntries[index].articleId));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleEntryDialog extends StatefulWidget {
  final Article article;

  ArticleEntryDialog(this.article);

  @override
  _ArticleEntryDialogState createState() => _ArticleEntryDialogState();

  static Future<ArticleEntry> open(BuildContext context, Article article) {
    return showDialog<ArticleEntry>(context: context, builder: (context) => ArticleEntryDialog(article));
  }
}

class _ArticleEntryDialogState extends State<ArticleEntryDialog> {
  ArticleEntry articleEntry;

  @override
  void initState() {
    super.initState();
    articleEntry = ArticleEntry(widget.article.id, 0, "", false, "");
  }

  void closeDialog(bool shouldSave) {
    Navigator.of(context).pop(shouldSave ? articleEntry : null);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actionsPadding: EdgeInsets.only(right: 10),
      title: Text(widget.article.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Amount',
            ),
            keyboardType: TextInputType.number,
            onChanged: (String amount) {
              setState(() {
                articleEntry.amount = double.parse(amount);
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Unit',
            ),
            onChanged: (String unit) {
              setState(() {
                articleEntry.unit = unit;
              });
            },
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Abbrechen", style: TextStyle(color: Colors.black54)),
          onPressed: () => closeDialog(false),
        ),
        FlatButton(
          child: Text("Speichern", style: TextStyle(color: Colors.black54)),
          onPressed: () => closeDialog(true),
        ),
      ],
    );
  }
}


class RecipeDialog extends StatefulWidget {
  final Recipe recipe;

  RecipeDialog(this.recipe);

  @override
  _RecipeDialogState createState() => _RecipeDialogState();

  static Future<List<ArticleEntry>> open(BuildContext context, Recipe recipe) {
    return showDialog<List<ArticleEntry>>(context: context, builder: (context) => RecipeDialog(recipe));
  }
}

class _RecipeDialogState extends State<RecipeDialog> {
  List<ArticleEntry> articleEntries;

  @override
  void initState() {
    super.initState();
    for (ArticleEntry article in widget.recipe.entries) {
      articleEntries.add(ArticleEntry(article.articleId, article.amount, article.unit, true, article.hint));
    }
  }

  void closeDialog(bool shouldSave) {
    Navigator.of(context).pop(shouldSave ? articleEntries : null);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actionsPadding: EdgeInsets.only(right: 10),
      title: Text(widget.recipe.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Abbrechen", style: TextStyle(color: Colors.black54)),
          onPressed: () => closeDialog(false),
        ),
        FlatButton(
          child: Text("Speichern", style: TextStyle(color: Colors.black54)),
          onPressed: () => closeDialog(true),
        ),
      ],
    );
  }
}

