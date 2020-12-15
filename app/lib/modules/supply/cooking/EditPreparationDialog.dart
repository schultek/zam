import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../SupplyRepository.dart';

class EditPreparationDialog extends StatefulWidget {
  final String preparation;
  final String recipeId;

  EditPreparationDialog(this.preparation, this.recipeId);

  @override
  _EditPreparationDialogState createState() => _EditPreparationDialogState();

  static Future<String> open(BuildContext context, String preparation, String recipeId) {
    return showDialog<String>(
        context: context, builder: (_) => SupplyProvider.of(context, child: EditPreparationDialog(preparation, recipeId)));
  }
}

class _EditPreparationDialogState extends State<EditPreparationDialog> {
  String preparation;

  @override
  void initState() {
    super.initState();
    preparation = widget.preparation;
  }

  void closeDialog() async {
    await Provider.of<SupplyRepository>(context, listen: false).savePreparation(preparation, widget.recipeId);
    Navigator.of(context).pop(preparation);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Zubereitung bearbeiten"),
      content: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: preparation,
            ),
            onChanged: (String prep) {
              setState(() {
                preparation = prep;
              });
            },
          ),
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                closeDialog();
              }),
        ],
      ),
    );
  }
}
