import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../supply_models.dart';
import '../../supply_repository.dart';

class AddArticleDialog extends StatefulWidget {
  final String suggestion;
  const AddArticleDialog(this.suggestion);

  @override
  _AddArticleDialogState createState() => _AddArticleDialogState();

  static Future<ArticleEntry?> open(BuildContext context, String suggestion) {
    return showDialog<ArticleEntry>(
        context: context, builder: (_) => SupplyProvider.of(context, child: AddArticleDialog(suggestion)));
  }
}

class _AddArticleDialogState extends State<AddArticleDialog> {
  String articleName = "";
  String articleCategory = "";
  String articleHint = "";
  double articleAmount = 1;
  String articleUnit = "";

  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    nameController.text = widget.suggestion;
    articleName = widget.suggestion;
  }

  Future<void> closeDialog(bool shouldSave) async {
    if (shouldSave) {
      var articleId = await Provider.of<SupplyRepository>(context, listen: false)
          .saveArticle(articleName, articleCategory, articleHint);
      var articleEntry = ArticleEntry(articleId, articleAmount, articleUnit, false, articleHint);
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
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Name",
            ),
            onChanged: (String name) {
              articleName = name;
            },
          ),
          Container(height: 10),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Kategorie',
            ),
            onChanged: (String category) {
              articleCategory = category;
            },
          ),
          Container(height: 10),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Hinweis',
            ),
            onChanged: (String hint) {
              articleHint = hint;
            },
          ),
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
