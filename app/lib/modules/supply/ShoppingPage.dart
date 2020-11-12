import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'SupplyModels.dart';
import 'SupplyRepository.dart';

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
        child: Selector<SupplyRepository, List<Article>>(
          selector: (context, repository) => repository.articles,
          builder: (context, articles, _) {
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(articles[index].name),
                  subtitle: Text(articles[index].category),
                );
              },
            );
          },
        ),
      ),
    );
  }
}