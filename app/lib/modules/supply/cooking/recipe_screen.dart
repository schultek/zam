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
  bool overview = true;

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
                    icon: Icon(Icons.arrow_back, color: context.theme.primaryColor),
                  ),
                ],
              ),
              Text(
                recipe.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: context.theme.primaryColor,
                ),
              ),
              Container(height: 20),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      labelPadding: EdgeInsets.symmetric(vertical: 10),
                      tabs: [
                        Text(
                          "Übersicht",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "Zubereitung",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 500,
                      child: TabBarView(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: 150,
                                height: 400,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 350,
                                      child: Expanded(
                                        child: ListView(
                                          children: recipe.entries.map((ArticleEntry entry) {
                                            return Selector<SupplyRepository, Article>(
                                              selector: (context, repository) =>
                                                  repository.getArticleById(entry.articleId),
                                              builder: (context, article, child) {
                                                return ListTile(
                                                  title: Text(article.name),
                                                  subtitle: Text("${entry.amount}  ${entry.unit}"),
                                                );
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
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
                          ),
                          Column(
                            children: [
                              Container(
                                height: 30,
                              ),
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
                                              await EditPreparationDialog.open(
                                                  context, recipe.preparation, widget.recipeId);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
