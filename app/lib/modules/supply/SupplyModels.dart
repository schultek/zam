import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jufa/modules/supply/SupplyRepository.dart';

class Article {
  String name;
  String category;
  String hint;

  Article(this.name, this.category, this.hint);

  factory Article.fromDocument(QueryDocumentSnapshot doc) {
    return Article(doc.get("name"), doc.get("category"), doc.get("hint"));
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(map["name"], map["category"], map["hint"]);
  }
}

class ArticleList {
  List<ArticleRelation> relations;
  String name;
  String note;

  ArticleList(this.relations, this.name, this.note);

  factory ArticleList.fromDocument(QueryDocumentSnapshot doc) {
    List<dynamic> relations = doc.get("relations");
    List<ArticleRelation> articleRelations = relations.map((dynamic relation) {
      return ArticleRelation.fromMap(relation);
    }).toList();

    String type = doc.get("type");
    if (type == "recipe") {
      return Recipe(doc.get("preparation"), articleRelations, doc.get("name"), doc.get("note"));
    } else {
      return ArticleList(articleRelations, doc.get("name"), doc.get("note"));
    }

  }
}

class ArticleRelation {
  Article article;
  double amount;
  String unit;
  bool checked;
  String hint;

  ArticleRelation(this.article, this.amount, this.unit, this.checked, this.hint);

  factory ArticleRelation.fromMap(Map<String, dynamic> relation) {
    return ArticleRelation(Article.fromMap(relation["article"]), relation["amount"], relation["unit"], relation["checked"], relation["hint"]);
  }
}

class Recipe extends ArticleList {
  String preparation;

  Recipe(this.preparation, relations, name, note) : super(relations, name, note);
}


/*Datenmodell
   - Klasse: Artikel
       - Attribut: Name
       - Attribut: Kategorie
       - Attribut: Hinweis
   - Klasse: Rezept extends Artikelliste
       - Attribut: Zubereitung
   - Klasse: Artikelliste
       - Attribut: Name
       - Attribut: Notiz
   - Beziehung: Artikel - Artikelliste
       - N zu N Beziehung
       - Attribut: Menge
       - Attribut: abgehakt
       - Attribut: einmalige Notiz

    UI
    - 2 Karten: 1x Kochen und 1x Einkaufen
    - Kochen:
      - Rezepte: hinzufügen, bearbeiten, löschen
    - Einkaufen:
      - Einkaufsliste: hinzufügen, bearbeiten, löschen

 */