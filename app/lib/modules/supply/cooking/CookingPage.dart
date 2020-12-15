import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../general/Extensions.dart';
import '../SupplyModels.dart';
import '../SupplyRepository.dart';
import 'AddRecipePage.dart';
import 'RecipePage.dart';

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
                shouldRebuild: (previous, next) {
                  var intersect = next.toSet().intersectionBy(previous, (e) => e.id + "-" + e.name);
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
                              builder: (_) => SupplyProvider.of(context, child: RecipePage(recipeList[index].id)),
                            ));
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
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
              child: Text("Rezept hinzufügen"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SupplyProvider.of(context, child: AddRecipePage()),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteRecipeDialog extends StatefulWidget {
  final Recipe recipe;

  DeleteRecipeDialog(this.recipe);
  @override
  _DeleteRecipeDialogState createState() => _DeleteRecipeDialogState();

  static dynamic open(BuildContext context, Recipe recipe) {
    return showDialog(context: context, builder: (_) => SupplyProvider.of(context, child: DeleteRecipeDialog(recipe)));
  }
}

class _DeleteRecipeDialogState extends State<DeleteRecipeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Wirklich das ganze Rezept löschen?"),
      content: Text(widget.recipe.name),
      actions: <Widget>[
        TextButton(
          child: Text("Abbrechen"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text("Löschen"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade300),
          ),
          onPressed: () {
            Provider.of<SupplyRepository>(context, listen: false).removeRecipe(widget.recipe.id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
