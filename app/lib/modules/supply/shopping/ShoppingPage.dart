import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../SupplyModels.dart';
import '../SupplyRepository.dart';
import 'AddArticlePage.dart';
import 'AddShoppingListPage.dart';

class ShoppingPage extends StatelessWidget {
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
        title: Text("Einkaufsliste"),
      ),
      body: Container(
        child: Selector<SupplyRepository, List<ShoppingList>>(
          selector: (context, repository) => repository.articleLists.whereType<ShoppingList>().toList(),
          builder: (context, lists, _) {
            return ListView.builder(
              itemCount: lists.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(lists[index].name),
                  subtitle: Text("${lists[index].entries.length} Artikel"),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        children: [
          SpeedDialChild(
              child: Icon(Icons.fastfood),
              label: "Artikel hinzufügen",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => SupplyProvider.of(context, child: AddArticlePage())));
              }),
          SpeedDialChild(
              child: Icon(Icons.shopping_cart),
              label: "Einkaufsliste hinzufügen",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => SupplyProvider.of(context, child: AddShoppingListPage())));
              }),
        ],
      ),
    );
  }
}


