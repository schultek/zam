import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../supply_models.dart';
import '../../supply_repository.dart';

class RecipeDialog extends StatefulWidget {
  final Recipe recipe;
  const RecipeDialog(this.recipe);

  @override
  _RecipeDialogState createState() => _RecipeDialogState();

  static Future<List<ArticleEntry>?> open(BuildContext context, Recipe recipe) {
    return showDialog<List<ArticleEntry>>(
      context: context,
      builder: (_context) => SupplyProvider.of(context, child: RecipeDialog(recipe)),
    );
  }
}

class _RecipeDialogState extends State<RecipeDialog> {
  List<ArticleEntry> articleEntries = [];

  @override
  void initState() {
    super.initState();
    for (ArticleEntry article in widget.recipe.entries) {
      articleEntries.add(ArticleEntry(article.articleId, article.amount, article.unit, true, article.hint));
    }
  }

  void closeDialog(bool shouldSave) {
    var result = shouldSave
        ? articleEntries.where((ArticleEntry entry) => entry.checked).map((ArticleEntry entry) {
            entry.checked = false;
            return entry;
          }).toList()
        : null;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actionsPadding: const EdgeInsets.only(right: 10),
      title: Text(widget.recipe.name),
      content: SizedBox(
        height: 500,
        width: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: articleEntries.length,
          itemBuilder: (context, index) {
            print(Provider.of<SupplyRepository>(context, listen: false).articles);
            return CheckboxListTile(
              title: Text(
                Provider.of<SupplyRepository>(context, listen: false)
                    .getArticleById(articleEntries[index].articleId)
                    .name,
              ),
              value: articleEntries[index].checked,
              onChanged: (value) {
                setState(() {
                  articleEntries[index].checked = value ?? false;
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => closeDialog(false),
          child: const Text("Abbrechen", style: TextStyle(color: Colors.black54)),
        ),
        FlatButton(
          onPressed: () => closeDialog(true),
          child: const Text("Speichern", style: TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }
}
