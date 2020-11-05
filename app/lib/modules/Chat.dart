part of modules;

class Chat extends Module {
  @override
  List<ModuleCard> getCards(ModuleData context) {
    return [
      ModuleCard(
        builder: (context) => Container(
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor,
              boxShadow: [BoxShadow(blurRadius: 10)]),
          padding: EdgeInsets.all(10),
          child: Center(child: Text("Chat")),
        ),
      ),
    ];
  }
}
