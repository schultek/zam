import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../main.mapper.g.dart';
import '../../modules/modules.dart';
import '../../modules/profile/widgets/image_selector.dart';
import '../../providers/trips/logic_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../themes/widgets/theme_selector.dart';
import '../themes/widgets/trip_theme.dart';
import 'settings_section.dart';

class TripSettings extends StatefulWidget {
  const TripSettings({Key? key}) : super(key: key);

  @override
  _TripSettingsState createState() => _TripSettingsState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const TripSettings());
  }
}

class _TripSettingsState extends State<TripSettings> {
  @override
  Widget build(BuildContext context) {
    var trip = context.watch(selectedTripProvider)!;

    var templateSettings = trip.template.settings(context);
    var moduleSettings = registry.getSettings(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: GestureDetector(
              onTap: () async {
                var pngBytes = await ImageSelector.fromGallery(context);
                if (pngBytes != null) {
                  context.read(tripsLogicProvider).setTripPicture(pngBytes);
                }
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.grey.shade800,
                    child: trip.pictureUrl == null
                        ? const Center(child: Icon(Icons.add, size: 60))
                        : CachedNetworkImage(
                            imageUrl: trip.pictureUrl!,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SettingsSection(padding: const EdgeInsets.all(14), children: [
            TextFormField(
              initialValue: trip.name,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              style: TextStyle(color: context.getTextColor()),
              onFieldSubmitted: (text) {
                context.read(tripsLogicProvider).updateTrip({'name': text});
              },
            ),
          ]),
          if (templateSettings != null)
            SettingsSection(
              title: 'Template',
              children: [...templateSettings],
            ),
          SettingsSection(title: 'Theme', children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ThemeSelector(
                schemeIndex: trip.theme.schemeIndex,
                onChange: (index) {
                  context
                      .read(tripsLogicProvider)
                      .updateTrip({'theme': trip.theme.copyWith(schemeIndex: index).toMap()});
                },
              ),
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: trip.theme.dark,
              onChanged: (value) {
                context.read(tripsLogicProvider).updateTrip({'theme': trip.theme.copyWith(dark: value).toMap()});
              },
            ),
          ]),
          for (var settings in moduleSettings)
            SettingsSection(
              title: settings.title,
              children: settings.settings,
            ),
          SettingsSection(children: [
            ListTile(
              title: const Text('Leave', style: TextStyle(color: Colors.red)),
              onTap: () {
                context.read(tripsLogicProvider).leaveSelectedTrip();
              },
            ),
          ]),
        ],
      ),
    );
  }
}
