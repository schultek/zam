import '../../models/models.dart';

class Article {
  String id;
  String name;
  String category;
  String hint;

  Article(this.id, this.name, this.category, this.hint);

  Article.fromMap(Map<String, dynamic> map)
      : id = map.get("id"),
        name = map.get("name"),
        category = map.get("category"),
        hint = map.get("hint");
}

class ArticleList {
  String id;
  String name;
  List<ArticleEntry> entries;
  String note;

  ArticleList(this.id, this.name, this.entries, this.note);

  ArticleList.fromMap(Map<String, dynamic> map)
      : id = map.get("id"),
        name = map.get("name"),
        entries = map.getList("entries", map: (Map<String, dynamic> v) => ArticleEntry.fromMap(v)),
        note = map.get("note");

  factory ArticleList.typedFromMap(Map<String, dynamic> map) {
    String type = map.get("type");
    if (type == "recipe") {
      return Recipe.fromMap(map);
    } else if (type == "shoppingList") {
      return ShoppingList.fromMap(map);
    } else {
      return ArticleList.fromMap(map);
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

  ArticleEntry.fromMap(Map<String, dynamic> map)
      : articleId = map.get("articleId"),
        amount = map.get("amount"),
        unit = map.get("unit"),
        checked = map.get("checked"),
        hint = map.get("hint");

  Map<String, dynamic> toMap() {
    return {
      "articleId": articleId,
      "amount": amount,
      "unit": unit,
      "checked": checked,
      "hint": hint,
    };
  }
}

class Recipe extends ArticleList {
  String preparation;

  Recipe.fromMap(Map<String, dynamic> map)
      : preparation = map.get("preparation"),
        super.fromMap(map);
}

class ShoppingList extends ArticleList {
  ShoppingList.fromMap(Map<String, dynamic> map) : super.fromMap(map);
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
