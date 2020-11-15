import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'SupplyModels.dart';
import 'SupplyRepository.dart';

class ShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        title: Text("Einkaufsliste"),
      ),
      body: Container(
        child: Selector<SupplyRepository, List<Article>>(
          selector: (context, repository) => repository.articles,
          builder: (context, articles, _) {
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(articles[index].name),
                  subtitle: Text(articles[index].category),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        children: [
          SpeedDialChild(
              child: Icon(Icons.add),
              label: "Artikel hinzufügen",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddArticlePage()));
              }),
        ],
      ),
    );
  }
}

class AddArticlePage extends StatefulWidget {
  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  String articleName;
  String articleCategory;
  String articleHint;

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
            onPressed: () {
              Provider.of<SupplyRepository>(context, listen: false).saveArticle(articleName, articleCategory, articleHint);
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
