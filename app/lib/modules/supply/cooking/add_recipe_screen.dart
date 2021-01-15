import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../shopping/dialogs/add_article_dialog.dart';
import '../shopping/dialogs/article_entry_dialog.dart';
import '../shopping/edit_shopping_list_screen.dart';
import '../supply_models.dart';
import '../supply_repository.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  String recipeName = "";
  ArticleEntry? currentEntry;
  List<ArticleEntry> recipeEntries = [];
  String preparation = "";
  String note = "";

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
              await Provider.of<SupplyRepository>(context, listen: false)
                  .saveRecipe(recipeName, recipeEntries, preparation, note);
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
                recipeName = name;
              },
            ),
            Container(height: 20),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Zubereitung',
              ),
              onChanged: (String prep) {
                preparation = prep;
              },
            ),
            Container(height: 20),
            TypeAheadField(
              textFieldConfiguration: const TextFieldConfiguration(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Suche nach Artikeln',
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
                if (suggestions.isEmpty) {
                  suggestions.add(NewArticleSuggestion(pattern));
                }
                return suggestions;
              },
              itemBuilder: (context, dynamic suggestion) {
                if (suggestion is NewArticleSuggestion) {
                  return const ListTile(
                    leading: Icon(Icons.add),
                    title: Text("Neuen Artikel zur Liste hinzufügen"),
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
                      recipeEntries.add(articleEntry);
                    });
                  }
                } else if (suggestion is NewArticleSuggestion) {
                  ArticleEntry? articleEntry = await AddArticleDialog.open(context, suggestion.name);
                  if (articleEntry != null) {
                    setState(() {
                      recipeEntries.add(articleEntry);
                    });
                  }
                }

                articleController.text = "";
              },
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: recipeEntries.length,
                  itemBuilder: (context, index) {
                    return Selector<SupplyRepository, Article>(
                      selector: (context, repo) => repo.getArticleById(recipeEntries[index].articleId),
                      builder: (BuildContext context, Article article, _) {
                        return ListTile(
                          title: Text(article.name),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
