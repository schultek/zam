import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../helpers/extensions.dart';
import '../supply_models.dart';
import '../supply_repository.dart';
import 'add_recipe_screen.dart';
import 'dialogs/delete_recipe_dialog.dart';
import 'recipe_screen.dart';

class CookingScreen extends StatelessWidget {
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
        title: const Text("Rezepteliste"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Selector<SupplyRepository, List<Recipe>>(
              selector: (context, repository) => repository.articleLists.whereType<Recipe>().toList(),
              shouldRebuild: (previous, next) {
                var intersect = next.toSet().intersectionBy(previous, (e) => "${e.id}-${e.name}");
                return next.length != previous.length || intersect.length != previous.length;
              },
              builder: (context, recipeList, _) {
                return ListView.builder(
                  itemCount: recipeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(recipeList[index].name),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SupplyProvider.of(context, child: RecipeScreen(recipeList[index].id)),
                          ));
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            DeleteRecipeDialog.open(context, recipeList[index]);
                          },
                        ));
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SupplyProvider.of(context, child: AddRecipeScreen()),
              ));
            },
            child: const Text("Rezept hinzufügen"),
          ),
        ],
      ),
    );
  }
}
