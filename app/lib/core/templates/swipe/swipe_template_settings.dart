part of templates;

class SwipeTemplateSettings extends StatefulWidget {
  const SwipeTemplateSettings({Key? key}) : super(key: key);

  @override
  _SwipeTemplateSettingsState createState() => _SwipeTemplateSettingsState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const SwipeTemplateSettings());
  }
}

class _SwipeTemplateSettingsState extends State<SwipeTemplateSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: ListView(
          children: [
            ListTile(
              title: TextFormField(
                initialValue: context.read(selectedTripProvider)!.name,
                decoration: const InputDecoration(labelText: "Name"),
                style: TextStyle(color: context.getTextColor()),
                onFieldSubmitted: (text) {
                  context.read(tripsLogicProvider).updateTrip({"name": text});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
