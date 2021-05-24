import 'package:flutter/material.dart';

import '../../supply_models.dart';

class ArticleEntryDialog extends StatefulWidget {
  final Article article;
  const ArticleEntryDialog(this.article);

  @override
  _ArticleEntryDialogState createState() => _ArticleEntryDialogState();

  static Future<ArticleEntry?> open(BuildContext context, Article article) {
    return showDialog<ArticleEntry>(context: context, builder: (context) => ArticleEntryDialog(article));
  }
}

class _ArticleEntryDialogState extends State<ArticleEntryDialog> {
  late ArticleEntry articleEntry;

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
      actionsPadding: const EdgeInsets.only(right: 10),
      title: Text(widget.article.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
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
            decoration: const InputDecoration(
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
        TextButton(
          onPressed: () => closeDialog(false),
          child: const Text("Abbrechen", style: TextStyle(color: Colors.black54)),
        ),
        TextButton(
          onPressed: () => closeDialog(true),
          child: const Text("Speichern", style: TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }
}
