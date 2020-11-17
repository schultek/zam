import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jufa/modules/supply/SupplyModels.dart';
import 'package:provider/provider.dart';

import '../SupplyRepository.dart';

class AddShoppingListPage extends StatefulWidget {
  @override
  _AddShoppingListPageState createState() => _AddShoppingListPageState();
}

class _AddShoppingListPageState extends State<AddShoppingListPage> {

  String listName = "";
  List<ArticleEntry> listEntries = [];

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
              await Provider.of<SupplyRepository>(context, listen: false).saveShoppingList(listName, listEntries);
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
                    labelText: 'Titel',
                  ),
                  onChanged: (String name) {
                    listName = name;
                  },
                ),
                Container(
                  height: 10
                ),
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Suche nach Artikeln oder Rezepten',
                      )
                  ),
                  suggestionsCallback: (pattern) async {
                    SupplyRepository repository = Provider.of<SupplyRepository>(context, listen: false);
                    List <dynamic> articles = repository.articles.where((article) => article.name.contains(pattern)).toList();
                    List <dynamic> recipes = repository.articleLists.whereType<Recipe>().where((recipe) => recipe.name.contains(pattern)).toList();
                    return articles + recipes;
                  },
                  itemBuilder: (context, dynamic suggestion) {
                    return ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text(suggestion.name),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    if (suggestion is Article) {
                      ArticleEntry entry = ArticleEntry(suggestion.id, 0, "", false, "");
                      listEntries.add(entry);
                    } else if (suggestion is Recipe) {
                      ArticleEntry entry =
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
