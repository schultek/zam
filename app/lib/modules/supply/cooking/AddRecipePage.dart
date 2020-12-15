import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jufa/modules/supply/shopping/AddArticleDialog.dart';
import 'package:jufa/modules/supply/shopping/ArticleEntryDialog.dart';
import 'package:jufa/modules/supply/shopping/EditShoppingListPage.dart';
import 'package:provider/provider.dart';

import '../SupplyModels.dart';
import '../SupplyRepository.dart';

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  String recipeName = "";
  ArticleEntry currentEntry;
  List<ArticleEntry> recipeEntries = [];
  String preparation = "";

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
              await Provider.of<SupplyRepository>(context, listen: false).saveRecipe(recipeName, recipeEntries, preparation);
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
                recipeName = name;
              },
            ),
            Container(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Zubereitung',
              ),
              onChanged: (String prep) {
                preparation = prep;
              },
            ),
            Container(height: 20),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Suche nach Artikeln',
              )),
              suggestionsCallback: (pattern) async {
                SupplyRepository repository = Provider.of<SupplyRepository>(context, listen: false);
                List<dynamic> suggestions = [];
                suggestions.addAll(
                  repository.articles.where((article) => article.name.toLowerCase().contains(pattern.toLowerCase())).toList(),
                );
                return suggestions;
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
                      recipeEntries.add(articleEntry);
                    });
                  }
                } else if (suggestion is NewArticleSuggestion) {
                  ArticleEntry articleEntry = await AddArticleDialog.open(context, suggestion.name);
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
