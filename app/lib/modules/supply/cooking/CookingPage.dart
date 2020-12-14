import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../SupplyModels.dart';
import '../SupplyRepository.dart';

import '../../../general/Extensions.dart';
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

