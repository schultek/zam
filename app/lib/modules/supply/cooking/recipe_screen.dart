import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../supply_models.dart';
import '../supply_repository.dart';
import 'dialogs/add_article_to_recipe_dialog.dart';
import 'dialogs/edit_preparation_dialog.dart';

class RecipeScreen extends StatefulWidget {
  final String recipeId;
  const RecipeScreen(this.recipeId);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<SupplyRepository, Recipe>(
        selector: (context, repository) => repository.getArticleListById(widget.recipeId) as Recipe,
        builder: (context, recipe, child) {
          return Column(
            children: [
              Container(height: 30),
              Row(
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black12,
                  ),
                  child: Stack(
                    children: [
                      Text(
                        recipe.preparation,
                        textAlign: TextAlign.center,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: const ShapeDecoration(color: Colors.white, shape: CircleBorder()),
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.purple,
                            onPressed: () async {
                              await EditPreparationDialog.open(context, recipe.preparation, widget.recipeId);
                            },
                          ),
                        ),
                      ),
                    ],
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
                          trailing: Text("${entry.amount}  ${entry.unit}"),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  ArticleEntry? articleEntry = await AddArticleToRecipeDialog.open(context);
                  if (articleEntry != null) {
                    await Provider.of<SupplyRepository>(context, listen: false)
                        .addArticleEntryToRecipe(widget.recipeId, articleEntry);
                  }
                },
                child: const Text("Artikel hinzufügen"),
              ),
            ],
          );
        },
      ),
    );
  }
}
