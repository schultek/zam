import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'SupplyModels.dart';

class SupplyRepository with ChangeNotifier {
  String tripId;

  StreamSubscription<QuerySnapshot> _articleSubscription;
  List<Article> articles = List();

  StreamSubscription<QuerySnapshot> _articleListSubscription;
  List<ArticleList> articleLists = List();

  SupplyRepository(this.tripId) {
    this._articleSubscription = FirebaseFirestore.instance
        .collection("trips")
        .doc(this.tripId)
        .collection("modules")
        .doc("supply")
        .collection("articles")
        .snapshots()
        .listen((snapshot) {
      List<Article> articles = snapshot.docs.map((QueryDocumentSnapshot doc) {
        return Article.fromDocument(doc);
      }).toList();
      this.articles = articles;
      this.notifyListeners();
    });

    this._articleListSubscription = FirebaseFirestore.instance
        .collection("trips")
        .doc(this.tripId)
        .collection("modules")
        .doc("supply")
        .collection("articleLists")
        .snapshots()
        .listen((snapshot) {
      List<ArticleList> articleLists = snapshot.docs.map((QueryDocumentSnapshot doc) {
        return ArticleList.fromDocument(doc);
      }).toList();
      this.articleLists = articleLists;
      this.notifyListeners();
    });
  }

  @override
  dispose() {
    super.dispose();
    this._articleSubscription.cancel();
    this._articleListSubscription.cancel();
  }

  ArticleList getArticleListById(String listId) {
    return this.articleLists.firstWhere((list) => list.id == listId);
  }

  Article getArticleById(String articleId) {
    return this.articles.firstWhere((article) => article.id == articleId, orElse: () => null);
  }

  Future<void> saveArticle(String articleName, String articleCategory, String articleHint) async {
    await FirebaseFirestore.instance
        .collection("trips")
        .doc(this.tripId)
        .collection("modules")
        .doc("supply")
        .collection("articles")
        .add({
      "name": articleName,
      "category": articleCategory,
      "hint": articleHint,
    });
  }

  Future<void> saveShoppingList(String listName, List<ArticleEntry> listEntries) async {
    await FirebaseFirestore.instance
        .collection("trips")
        .doc(this.tripId)
        .collection("modules")
        .doc("supply")
        .collection("articleLists")
        .add({
      "name": listName,
      "type": "shoppingList",
      "entries": listEntries.map((entry) => entry.toMap()).toList(),
      "note": "",
    });
  }
}

class SupplyProvider extends StatelessWidget {
  final String tripId;
  final Widget child;

  SupplyProvider({@required this.tripId, @required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SupplyRepository>(
      create: (context) => SupplyRepository(this.tripId),
      child: this.child,
    );
  }

  static Widget of(BuildContext context, {Widget child}) {
    return SupplyProvider(tripId: Provider.of<SupplyRepository>(context, listen: false).tripId, child: child);
  }
}
