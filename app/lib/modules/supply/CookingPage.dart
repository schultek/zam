import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jufa/models/Trip.dart';
import 'package:jufa/pages/TripHome.dart';

import 'SupplyModels.dart';

class CookingPage extends StatefulWidget {
  @override
  _CookingPageState createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  List<Recipe> recipeList = [
    Recipe("", [ArticleRelation(Article("Tomate", "", "nomnom"), 4, "Stück", false, "")], "Tomatensuppe", "")];

  Trip trip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
            ),
          title: Text("Rezepteliste"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: recipeList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(recipeList[index].name),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipePage(recipeList[index])));
                  });
            }),
      ),
    );
  }
}

class RecipePage extends StatelessWidget {
  final Recipe recipe;

  RecipePage(this.recipe);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
            children: [
              Container(
                height: 50
              ),
              Text(
                  recipe.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
              Expanded(
          child: ListView(
              children: recipe.relations.map((ArticleRelation articleRelation) {
            return ListTile(
              title: Text(articleRelation.article.name),
            );
          }).toList())
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                      Icons.arrow_back,
                      color: Colors.white),
            ),
      ]
      )
    );
  }
}
