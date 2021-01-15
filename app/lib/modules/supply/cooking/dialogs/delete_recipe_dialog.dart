import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../supply_models.dart';
import '../../supply_repository.dart';

class DeleteRecipeDialog extends StatefulWidget {
  final Recipe recipe;
  const DeleteRecipeDialog(this.recipe);

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
      title: const Text("Wirklich das ganze Rezept löschen?"),
      content: Text(widget.recipe.name),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Abbrechen"),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade300),
          ),
          onPressed: () {
            Provider.of<SupplyRepository>(context, listen: false).removeRecipe(widget.recipe.id);
            Navigator.of(context).pop();
          },
          child: const Text("Löschen"),
        ),
      ],
    );
  }
}
