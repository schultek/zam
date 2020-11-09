import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'SupplyModels.dart';

class SupplyRepository with ChangeNotifier {

  String tripId;

  StreamSubscription<QuerySnapshot> _articleSubscription;
  List<Article> articles;

  StreamSubscription<QuerySnapshot> _articleListSubscription;
  List<ArticleList> articleLists;

  SupplyRepository(this.tripId) {

    this._articleSubscription = FirebaseFirestore.instance.collection("trips")
        .doc(this.tripId)
        .collection("modules")
        .doc("supply")
        .collection("articles")
        .snapshots().listen((snapshot) {
      List<Article> articles = snapshot.docs.map((QueryDocumentSnapshot doc) {
        return Article.fromDocument(doc);
      }).toList();
      this.articles = articles;
      this.notifyListeners();
    });

    this._articleListSubscription = FirebaseFirestore.instance.collection("trips")
        .doc(this.tripId)
        .collection("modules")
        .doc("supply")
        .collection("articleLists")
        .snapshots().listen((snapshot) {
      List<ArticleList> articleLists = snapshot.docs.map((QueryDocumentSnapshot doc) {
        return ArticleList.fromDocument(doc);
      }).toList();
      this.articleLists = articleLists;
      this.notifyListeners();
    });

  }

  dispose() {
    this._articleSubscription.cancel();
    this._articleListSubscription.cancel();
  }

}

class SupplyProvider extends StatelessWidget {

  final String tripId;
  final Widget child;

  SupplyProvider({@required this.tripId, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<SupplyRepository>(
      create: (context) => SupplyRepository(this.tripId),
      dispose: (context, repo) => repo.dispose(),
      builder: (context, child) => child,
      child: this.child,
    );
  }

}