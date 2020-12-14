import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jufa/modules/modules.dart';
import 'package:provider/provider.dart';

import '../SupplyModels.dart';
import '../SupplyRepository.dart';
import 'AddArticleDialog.dart';
import 'ArticleEntryDialog.dart';
import 'RecipeDialog.dart';

class EditShoppingListPage extends StatefulWidget {
  final ArticleList list;

  EditShoppingListPage(this.list);

  @override
  _EditShoppingListPageState createState() => _EditShoppingListPageState();
}

class _EditShoppingListPageState extends State<EditShoppingListPage> {
  String listName = "";
  ArticleEntry currentEntry;
  List<ArticleEntry> listEntries = [];

  TextEditingController articleController;
  TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    articleController = TextEditingController();

    titleController = TextEditingController();
    if (widget.list != null) {
      listName = widget.list.name;
      listEntries = widget.list.entries.sublist(0);
      titleController.text = listName;
    }
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
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
                labelText: widget.list != null ? "Mehr Artikel oder Rezepte hinzufügen" : 'Suche nach Artikeln oder Rezepten',
              )),
              suggestionsCallback: (pattern) async {
                SupplyRepository repository = Provider.of<SupplyRepository>(context, listen: false);
                List<dynamic> suggestions = [];
                suggestions.addAll(
                  repository.articles.where((article) => article.name.toLowerCase().contains(pattern.toLowerCase())).toList(),
                );
                suggestions.addAll(
                  repository.articleLists
                      .whereType<Recipe>()
                      .where((recipe) => recipe.name.toLowerCase().contains(pattern.toLowerCase()))
                      .toList(),
                );
                if (suggestions.isEmpty) {
                  suggestions.add(NewArticleSuggestion(pattern));
                }
                  return suggestions;

              },
              itemBuilder: (context, dynamic suggestion) {
                if (suggestion is NewArticleSuggestion) {
                  return ListTile(
                    leading: Icon(Icons.add),
                    title: Text("Neuen Artikel zur Liste hinzufügen")
                  );
                } else {
                  return ListTile(
                    leading: Icon((suggestion is Article) ? Icons.shopping_cart : Icons.fastfood),
                    title: Text(suggestion.name),
                  );
                }
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
                } else if (suggestion is NewArticleSuggestion) {
                  ArticleEntry articleEntry = await AddArticleDialog.open(context, suggestion.name);
                  if (articleEntry != null) {
                    setState(() {
                      listEntries.add(articleEntry);
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
                          trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState((){
                                  listEntries.removeAt(index);
                                }
                                );
                              },
                          ),
                        );
                      },
                    );
                  }),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.purple),
              child: Text(
                widget.list != null ? "Aktualisieren" : "Erstellen",
                 style: TextStyle(
                      color: Colors.white)
              ),
              onPressed: () async {
                if (widget.list == null) {
                  await Provider.of<SupplyRepository>(context, listen: false).saveShoppingList(listName, listEntries);
                } else {
                  var updatedList = ArticleList(widget.list.id, listName, listEntries, widget.list.note);
                  await Provider.of<SupplyRepository>(context, listen: false).updateShoppingList(updatedList);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewArticleSuggestion {
  String name;

  NewArticleSuggestion(this.name);

}

