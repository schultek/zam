import 'package:cloud_firestore/cloud_firestore.dart';

class Article {

  String id;
  String name;
  String category;
  String hint;

  Article(this.id, this.name, this.category, this.hint);

  factory Article.fromDocument(QueryDocumentSnapshot doc) {
    return Article(doc.id, doc.get("name"), doc.get("category"), doc.get("hint"));
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(map["id"], map["name"], map["category"], map["hint"]);
  }
}

class ArticleList {

  String id;
  String name;
  List<ArticleEntry> entries;
  String note;

  ArticleList(this.id,  this.name, this.entries, this.note);

  factory ArticleList.fromDocument(QueryDocumentSnapshot doc) {
    List<ArticleEntry> articleEntries = (doc.get("entries") as List<dynamic>)
        .map((entry) => ArticleEntry.fromMap(entry)).toList();
    String type = doc.get("type");
    if (type == "recipe") {
      return Recipe(doc.id, doc.get("name"), articleEntries, doc.get("preparation"), doc.get("note"));
    } else if (type == "shoppingList") {
      return ShoppingList(doc.id, doc.get("name"), articleEntries, doc.get("note"));
    } else {
      return ArticleList(doc.id, doc.get("name"), articleEntries, doc.get("note"));
    }

  }
}

class ArticleEntry {

  String articleId;
  double amount;
  String unit;
  bool checked;
  String hint;

  ArticleEntry(this.articleId, this.amount, this.unit, this.checked, this.hint);

  factory ArticleEntry.fromMap(Map<String, dynamic> relation) {
    return ArticleEntry(relation["articleId"], relation["amount"] + 0.0, relation["unit"], relation["checked"], relation["hint"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "articleId" : articleId,
      "amount" : amount,
      "unit" : unit,
      "checked" : checked,
      "hint" : hint,
    };
  }
}

class Recipe extends ArticleList {
  String preparation;

  Recipe(String id, String name, List<ArticleEntry> entries, this.preparation, String note) : super(id, name, entries, note);
}

class ShoppingList extends ArticleList {
  ShoppingList(String id, String name, List<ArticleEntry> entries, String note) : super(id, name, entries, note);
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