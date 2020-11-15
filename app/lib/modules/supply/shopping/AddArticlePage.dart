import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../SupplyRepository.dart';

class AddArticlePage extends StatefulWidget {
  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  String articleName = "";
  String articleCategory = "";
  String articleHint = "";

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
              await Provider.of<SupplyRepository>(context, listen: false).saveArticle(articleName, articleCategory, articleHint);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Artikelname',
                  ),
                  onChanged: (String name) {
                    articleName = name;
                  },
                ),
                Container(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Kategorie',
                  ),
                  onChanged: (String category) {
                    articleCategory = category;
                  },
                ),
                Container(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hinweis',
                  ),
                  onChanged: (String hint) {
                    articleHint = hint;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}