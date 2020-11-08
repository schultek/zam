class Article {
  String name;
  String category;
  String hint;

  Article(this.name, this.category, this.hint);
}

class ArticleList {
  List<ArticleRelation> relations;
  String name;
  String note;

  ArticleList(this.relations, this.name, this.note);
}

class ArticleRelation {
  Article article;
  double amount;
  String unit;
  bool checked;
  String hint;

  ArticleRelation(this.article, this.amount, this.unit, this.checked, this.hint);
}

class Recipe extends ArticleList{
  String preparation;

  Recipe(this.preparation, relations, name, note) : super(relations, name, note);
}

class ArticleRepository {
  List<Article> articles;
  List<ArticleList> articleLists;

  ArticleRepository(this.articles, this.articleLists);
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