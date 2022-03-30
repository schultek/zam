import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import 'supply_models.dart';

class SupplyRepository with ChangeNotifier {
  String groupId;

  late StreamSubscription<QuerySnapshot> _articleSubscription;
  List<Article> articles = [];

  late StreamSubscription<QuerySnapshot> _articleListSubscription;
  List<ArticleList> articleLists = [];

  SupplyRepository(this.groupId, {this.articles = const [], this.articleLists = const []}) {
    _articleSubscription = FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("modules")
        .doc("supply")
        .collection("articles")
        .snapshots()
        .listen((snapshot) {
      List<Article> articles = snapshot.toList();
      this.articles = articles;
      notifyListeners();
    });

    _articleListSubscription = FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("modules")
        .doc("supply")
        .collection("articleLists")
        .snapshots()
        .listen((snapshot) {
      List<ArticleList> articleLists = snapshot.toList();
      this.articleLists = articleLists;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _articleSubscription.cancel();
    _articleListSubscription.cancel();
  }

  ArticleList getArticleListById(String listId) {
    return articleLists.firstWhere((list) => list.id == listId);
  }

  Article getArticleById(String articleId) {
    return articles.firstWhere((article) => article.id == articleId);
  }

  Future<String> saveArticle(String articleName, String articleCategory, String articleHint) async {
    var docRef = await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("modules")
        .doc("supply")
        .collection("articles")
        .add({
      "name": articleName,
      "category": articleCategory,
      "hint": articleHint,
    });
    return docRef.id;
  }

  Future<void> saveShoppingList(String listName, List<ArticleEntry> listEntries) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("modules")
        .doc("supply")
        .collection("articleLists")
        .add({
      "name": listName,
      "type": "shoppingList",
      "entries": Mapper.toValue(listEntries),
      "note": "",
    });
  }

  Future<void> updateShoppingList(ArticleList list) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("modules")
        .doc("supply")
        .collection("articleLists")
        .doc(list.id)
        .update({
      "name": list.name,
      "entries": Mapper.toValue(list.entries),
      "note": list.note,
    });
  }

  Future<void> removeShoppingList(String listId) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("modules")
        .doc("supply")
        .collection("articleLists")
        .doc(listId)
        .delete();
  }

  Future<void> addArticleEntryToRecipe(String recipeId, ArticleEntry articleEntry) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("modules")
        .doc("supply")
        .collection("articleLists")
        .doc(recipeId)
        .update({
      "entries": FieldValue.arrayUnion([Mapper.toValue(articleEntry)]),
    });
  }

  Future<void> saveRecipe(String recipeName, List<ArticleEntry> recipeEntries, String preparation, String note) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("modules")
        .doc("supply")
        .collection("articleLists")
        .add({
      "name": recipeName,
      "type": "recipe",
      "entries": Mapper.toValue(recipeEntries),
      "preparation": preparation,
      "note": note,
    });
  }

  Future<void> removeRecipe(String recipeId) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("modules")
        .doc("supply")
        .collection("articleLists")
        .doc(recipeId)
        .delete();
  }

  Future<void> savePreparation(String preparation, String recipeId) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("modules")
        .doc("supply")
        .collection("articleLists")
        .doc(recipeId)
        .update({
      "preparation": preparation,
    });
  }
}

class SupplyProvider extends StatelessWidget {
  final String groupId;
  final Widget child;

  const SupplyProvider({required this.groupId, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SupplyRepository>(
      create: (context) => SupplyRepository(groupId),
      child: child,
    );
  }

  static Widget of(BuildContext context, {required Widget child}) {
    var parent = Provider.of<SupplyRepository>(context, listen: false);
    return ChangeNotifierProvider<SupplyRepository>(
      create: (context) => SupplyRepository(
        parent.groupId,
        articles: parent.articles,
        articleLists: parent.articleLists,
      ),
      child: child,
    );
  }
}
