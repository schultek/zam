import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../shopping/edit_shopping_list_screen.dart';
import '../../supply_models.dart';
import '../../supply_repository.dart';

class AddArticleToRecipeDialog extends StatefulWidget {
  @override
  _AddArticleToRecipeDialogState createState() => _AddArticleToRecipeDialogState();

  static Future<ArticleEntry?> open(BuildContext context) {
    return showDialog<ArticleEntry>(
      context: context,
      builder: (_) => SupplyProvider.of(context, child: AddArticleToRecipeDialog()),
    );
  }
}

class _AddArticleToRecipeDialogState extends State<AddArticleToRecipeDialog> {
  String articleName = "";
  String articleCategory = "";
  String articleHint = "";
  late double articleAmount;
  String articleUnit = "";
  String? id;
  late TextEditingController articleController;

  @override
  void initState() {
    super.initState();
    articleController = TextEditingController();
  }

  Future<void> closeDialog(bool shouldSave) async {
    if (shouldSave) {
      id ??= await Provider.of<SupplyRepository>(context, listen: false)
          .saveArticle(articleName, articleCategory, articleHint);
      var articleEntry = ArticleEntry(id!, articleAmount, articleUnit, false, articleHint);
      Navigator.of(context).pop(articleEntry);
    } else {
      Navigator.of(context).pop(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Neuen Artikel hinzufügen"),
      content: ListView(
        children: [
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: articleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Mehr Artikel hinzufügen",
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
                  leading: const Icon(Icons.fastfood),
                  title: Text(suggestion.name),
                );
              } else {
                return Container();
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
          if (id == null) Container(height: 10) else Container(),
          if (id == null)
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Kategorie',
              ),
              onChanged: (String category) {
                articleCategory = category;
              },
            )
          else
            Container(),
          if (id == null) Container(height: 10) else Container(),
          if (id == null)
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Hinweis',
              ),
              onChanged: (String hint) {
                articleHint = hint;
              },
            )
          else
            Container(),
          Container(height: 10),
          TextField(
            decoration: const InputDecoration(
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
          Container(height: 10),
          TextField(
            decoration: const InputDecoration(
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
          onPressed: () async {
            closeDialog(false);
          },
          child: const Text("Abbrechen"),
        ),
        TextButton(
          onPressed: () async {
            closeDialog(true);
          },
          child: const Text("Speichern"),
        ),
      ],
    );
  }
}
