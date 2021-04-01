import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../SupplyModels.dart';
import '../SupplyRepository.dart';
import 'AddArticleToRecipeDialog.dart';
import 'EditPreparationDialog.dart';

class RecipePage extends StatefulWidget {
  final String recipeId;

  RecipePage(this.recipeId);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  bool overview = true;

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
              Text(
                recipe.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Container(height: 20),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
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
                                              selector: (context, repository) => repository.getArticleById(entry.articleId),
                                              builder: (context, article, child) {
                                                return ListTile(
                                                  title: Text(article.name),
                                                  subtitle: Text(entry.amount.toString() + "  " + entry.unit),
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
                          ),
                          Column(
                            children: [
                              Container(
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
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
                                                icon: Icon(Icons.edit),
                                                color: Colors.purple,
                                                onPressed: () async {
                                                  await EditPreparationDialog.open(context, recipe.preparation, widget.recipeId);
                                                }),
                                          )),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black12,
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
