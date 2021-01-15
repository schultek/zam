import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../supply_models.dart';
import '../supply_repository.dart';
import 'dialogs/article_entry_dialog.dart';
import 'dialogs/recipe_dialog.dart';

class AddShoppingListPage extends StatefulWidget {
  @override
  _AddShoppingListPageState createState() => _AddShoppingListPageState();
}

class _AddShoppingListPageState extends State<AddShoppingListPage> {
  String listName = "";
  ArticleEntry? currentEntry;
  List<ArticleEntry> listEntries = [];

  late TextEditingController articleController;

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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await Provider.of<SupplyRepository>(context, listen: false).saveShoppingList(listName, listEntries);
              Navigator.of(context).pop();
            },
            child: const Text(
              "Speichern",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Titel',
              ),
              onChanged: (String name) {
                listName = name;
              },
            ),
            Container(height: 20),
            TypeAheadField(
              textFieldConfiguration: const TextFieldConfiguration(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Suche nach Artikeln oder Rezepten',
                ),
              ),
              suggestionsCallback: (pattern) async {
                SupplyRepository repository = Provider.of<SupplyRepository>(context, listen: false);
                List<dynamic> suggestions = [];
                suggestions.addAll(
                  repository.articles
                      .where((article) => article.name.toLowerCase().contains(pattern.toLowerCase()))
                      .toList(),
                );
                suggestions.addAll(
                  repository.articleLists
                      .whereType<Recipe>()
                      .where((recipe) => recipe.name.toLowerCase().contains(pattern.toLowerCase()))
                      .toList(),
                );
                return suggestions;
              },
              itemBuilder: (context, dynamic suggestion) {
                if (suggestion is ArticleList) {
                  return ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: Text(suggestion.name),
                  );
                } else if (suggestion is Article) {
                  return ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: Text(suggestion.name),
                  );
                } else {
                  return Container();
                }
              },
              onSuggestionSelected: (suggestion) async {
                if (suggestion is Article) {
                  ArticleEntry? articleEntry = await ArticleEntryDialog.open(context, suggestion);
                  if (articleEntry != null) {
                    setState(() {
                      listEntries.add(articleEntry);
                    });
                  }
                } else if (suggestion is Recipe) {
                  List<ArticleEntry>? articleEntries = await RecipeDialog.open(context, suggestion);
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
                  return Selector<SupplyRepository, Article>(
                    selector: (context, repo) => repo.getArticleById(listEntries[index].articleId),
                    builder: (BuildContext context, Article article, _) {
                      return ListTile(
                        title: Text(article.name),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
