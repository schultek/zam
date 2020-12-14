import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jufa/modules/supply/shopping/EditShoppingListPage.dart';
import 'package:provider/provider.dart';

import '../SupplyModels.dart';
import '../SupplyRepository.dart';

class AddArticleToRecipeDialog extends StatefulWidget {
  AddArticleToRecipeDialog();
  @override
  _AddArticleToRecipeDialogState createState() => _AddArticleToRecipeDialogState();

  static Future<ArticleEntry> open(BuildContext context) {
    return showDialog<ArticleEntry>(
        context: context, builder: (_) => SupplyProvider.of(context, child: AddArticleToRecipeDialog()));
  }
}

class _AddArticleToRecipeDialogState extends State<AddArticleToRecipeDialog> {
  String articleName = "";
  String articleCategory = "";
  String articleHint = "";
  double articleAmount;
  String articleUnit = "";
  String id;
  TextEditingController articleController;

  @override
  void initState() {
    super.initState();
    articleController = TextEditingController();
  }

  void closeDialog(bool shouldSave) async {
    if (shouldSave) {
      if (id == null) {
        id = await Provider.of<SupplyRepository>(context, listen: false).saveArticle(articleName, articleCategory, articleHint);
      }
      var articleEntry = ArticleEntry(id, articleAmount, articleUnit, false, articleHint);
      Navigator.of(context).pop(articleEntry);
    } else {
      Navigator.of(context).pop(null);
    }
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Neuen Artikel hinzufügen"),
      content: ListView(
        children: [
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: articleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Mehr Artikel hinzufügen",
                )),
            suggestionsCallback: (pattern) async {
              SupplyRepository repository = Provider.of<SupplyRepository>(context, listen: false);
              List<dynamic> suggestions = [];
              suggestions.addAll(
                repository.articles.where((article) => article.name.toLowerCase().contains(pattern.toLowerCase())).toList(),
              );
              if (suggestions.isEmpty) {
                suggestions.add(NewArticleSuggestion(pattern));
              }
              return suggestions;
            },
            itemBuilder: (context, dynamic suggestion) {
              if (suggestion is NewArticleSuggestion) {
                return ListTile(leading: Icon(Icons.add), title: Text("Neuen Artikel zur Liste hinzufügen"));
              } else {
                return ListTile(
                  leading: Icon(Icons.fastfood),
                  title: Text(suggestion.name),
                );
              }
            },
            onSuggestionSelected: (suggestion) async {
              setState(() {
                if (suggestion is Article) {
                  articleName = suggestion.name;
                  id = suggestion.id;
                } else if (suggestion is NewArticleSuggestion) {
                  articleName = suggestion.name;
                }
              });

              articleController.text = articleName;
            },
          ),
          (id == null)
              ? Container(
                  height: 10,
                )
              : Container(),
          (id == null)
              ? TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Kategorie',
                  ),
                  onChanged: (String category) {
                    articleCategory = category;
                  },
                )
              : Container(),
          (id == null)
              ? Container(
                  height: 10,
                )
              : Container(),
          (id == null)
              ? TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hinweis',
                  ),
                  onChanged: (String hint) {
                    articleHint = hint;
                  },
                )
              : Container(),
          Container(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Amount',
            ),
            keyboardType: TextInputType.number,
            onChanged: (String amount) {
              setState(() {
                articleAmount = double.parse(amount);
              });
            },
          ),
          Container(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Unit',
            ),
            onChanged: (String unit) {
              setState(() {
                articleUnit = unit;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Abbrechen"),
          onPressed: () async {
            closeDialog(false);
          },
        ),
        TextButton(
          child: Text(
            "Speichern",
          ),
          onPressed: () async {
            closeDialog(true);
          },
        ),
      ],
    );
  }
}
