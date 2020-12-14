import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../SupplyModels.dart';
import '../SupplyRepository.dart';
import 'AddArticleToRecipeDialog.dart';

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
              ElevatedButton(
                child: Text("Artikel hinzufügen"),
                onPressed: () async {
                  ArticleEntry articleEntry = await AddArticleToRecipeDialog.open(context);
                  if (articleEntry != null) {
                    await Provider.of<SupplyRepository>(context, listen: false)
                        .addArticleEntryToRecipe(widget.recipeId, articleEntry);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
