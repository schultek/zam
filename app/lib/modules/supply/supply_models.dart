import 'package:dart_mappable/dart_mappable.dart';

@MappableClass()
class Article {
  String id;
  String name;
  String category;
  String hint;

  Article(this.id, this.name, this.category, this.hint);
}

@MappableClass(discriminatorKey: "type")
class ArticleList {
  String id;
  String name;
  List<ArticleEntry> entries;
  String note;

  ArticleList(this.id, this.name, this.entries, this.note);
}

@MappableClass()
class ArticleEntry {
  String articleId;
  double amount;
  String unit;
  bool checked;
  String hint;

  ArticleEntry(this.articleId, this.amount, this.unit, this.checked, this.hint);
}

@MappableClass(discriminatorValue: "recipe")
class Recipe extends ArticleList {
  String preparation;

  Recipe(String id, String name, List<ArticleEntry> entries, this.preparation, String note)
      : super(id, name, entries, note);
}

@MappableClass(discriminatorValue: "shoppingList")
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
