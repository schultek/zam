import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'Supply.dart';
import 'SupplyModels.dart';
import 'SupplyRepository.dart';

import '../../general/Extensions.dart';

class CookingPage extends StatelessWidget {
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
          child: Column(
        children: [
          Expanded(
            child: Selector<SupplyRepository, List<Recipe>>(
              selector: (context, repository) => repository.articleLists.whereType<Recipe>().toList(),
              shouldRebuild: (previous, next) =>
                  next.toSet().intersectionBy(previous, (e) => e.id + "-" + e.name).length != next.length,
              builder: (context, recipeList, _) {
                return ListView.builder(
                  itemCount: recipeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(recipeList[index].name),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => SupplyProvider.of(context, child: RecipePage(recipeList[index].id)),
                        ));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}

class RecipePage extends StatefulWidget {
  final String recipeId;

  RecipePage(this.recipeId);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<SupplyRepository, Recipe>(
        selector: (context, repository) => repository.getArticleListById(this.widget.recipeId),
        builder: (context, recipe, child) {
          return Column(
            children: [
              Container(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
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
                  children: recipe.entries.map((ArticleEntry entry) {
                    return Selector<SupplyRepository, Article>(
                      selector: (context, repository) => repository.getArticleById(entry.articleId),
                      builder: (context, article, child) {
                        return ListTile(
                          title: Text(article.name),
                          trailing: Text(entry.amount.toString() + "  " + entry.unit),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(child: Text("Artikel hinzufügen"), onPressed: () {})
            ],
          );
        },
      ),
    );
  }
}
