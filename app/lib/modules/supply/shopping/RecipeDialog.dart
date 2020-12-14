import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../SupplyModels.dart';
import '../SupplyRepository.dart';

class RecipeDialog extends StatefulWidget {
  final Recipe recipe;

  RecipeDialog(this.recipe);

  @override
  _RecipeDialogState createState() => _RecipeDialogState();

  static Future<List<ArticleEntry>> open(BuildContext context, Recipe recipe) {
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
    Navigator.of(context).pop(shouldSave ? articleEntries.where((ArticleEntry entry) => entry.checked).map((ArticleEntry entry) {
      entry.checked = false;
      return entry;
    }).toList() : null);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actionsPadding: EdgeInsets.only(right: 10),
      title: Text(widget.recipe.name),
      content: Container(
        height: 500,
        width: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: articleEntries.length,
          itemBuilder: (context, index) {
            print(Provider.of<SupplyRepository>(context, listen: false).articles);
            return CheckboxListTile(
                title: Text(
                    Provider.of<SupplyRepository>(context, listen: false).getArticleById(articleEntries[index].articleId).name),
                value: articleEntries[index].checked,
                onChanged: (bool value) {
                  setState(() {
                    articleEntries[index].checked = value;
                  });
                });
          },
        ),
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
