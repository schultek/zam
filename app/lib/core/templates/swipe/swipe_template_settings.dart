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
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.getTextColor()),
        title: Text('Settings', style: TextStyle(color: context.getTextColor())),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer(
          builder: (context, ref, _) {
            var trip = ref.watch(selectedTripProvider)!;
            return ListView(
              children: [
                GestureDetector(
                  onTap: () async {
                    var pngBytes = await ImageSelector.fromGallery(context);
                    if (pngBytes != null) {
                      context.read(tripsLogicProvider).setTripPicture(pngBytes);
                    }
                  },
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width / 5,
                    backgroundColor: Colors.grey,
                    backgroundImage: trip.pictureUrl != null ? CachedNetworkImageProvider(trip.pictureUrl!) : null,
                    child: trip.pictureUrl == null ? const Center(child: Icon(Icons.add, size: 60)) : null,
                  ),
                ),
                const SizedBox(height: 40),
                ListTile(
                  title: TextFormField(
                    initialValue: trip.name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    style: TextStyle(color: context.getTextColor()),
                    onFieldSubmitted: (text) {
                      context.read(tripsLogicProvider).updateTrip({'name': text});
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: const Text('Leave', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    context.read(tripsLogicProvider).leaveSelectedTrip();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
