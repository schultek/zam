import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class Article {
  String id;
  String name;
  String category;
  String hint;

  Article(this.id, this.name, this.category, this.hint);
}

@jsonSerializable
@Json(discriminatorProperty: "type")
class ArticleList {
  String id;
  String name;
  List<ArticleEntry> entries;
  String note;

  ArticleList(this.id, this.name, this.entries, this.note);
}

class ArticleEntry {
  String articleId;
  double amount;
  String unit;
  bool checked;
  String hint;

  ArticleEntry(this.articleId, this.amount, this.unit, this.checked, this.hint);
}

@jsonSerializable
@Json(discriminatorValue: "recipe")
class Recipe extends ArticleList {
  String preparation;

  Recipe(String id, String name, List<ArticleEntry> entries, this.preparation, String note)
      : super(id, name, entries, note);
}

@jsonSerializable
@Json(discriminatorValue: "shoppingList")
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
