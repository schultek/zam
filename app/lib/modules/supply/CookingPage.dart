import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'SupplyModels.dart';
import 'SupplyRepository.dart';

class CookingPage extends StatefulWidget {
  @override
  _CookingPageState createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  List<Recipe> recipeList = [
    Recipe("Tomaten waschen, Tomaten schneiden, Tomaten kochen, Tomaten würzen, Tomaten auf Teller kippen, Tomaten essen",
        [ArticleRelation(Article("Tomate", "", "nomnom"), 4, "Stück", false, "")], "Tomatensuppe", "")
  ];

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
        title: Text("Rezepteliste"),
      ),
      body: Container(
        child: Selector<SupplyRepository, List<Recipe>>(
          selector: (context, repository) => repository.articleLists.whereType<Recipe>().toList(),
          shouldRebuild: (previous, next) => previous == null || previous.length != next.length,
          builder: (context, recipeList, _) {
            return ListView.builder(
              itemCount: recipeList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(recipeList[index].name),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipePage(recipeList[index], relation)));
                  },
                );
              },
            );

          }
        ),
      ),
    );
  }
}

class RecipePage extends StatelessWidget {
  final Recipe recipe;
  final ArticleRelation relation;

  RecipePage(this.recipe, this.relation);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Container(
        height: 30,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
        ),
      ]),
      Text(recipe.name, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
      Container(height: 50),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Text(
            recipe.preparation,
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black12,
          ),
        ),
      ),
      Container(height: 50),
      Expanded(
        child: ListView(
          children: recipe.relations.map(
            (ArticleRelation articleRelation) {
              return ListTile(
                title: Text(articleRelation.article.name),
                trailing: Text(articleRelation.amount.toString() + "  " + articleRelation.unit),
              );
            },
          ).toList(),
        ),
      ),
    ]));
  }
}
