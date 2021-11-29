import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../modules/modules.dart';
import '../../modules/profile/widgets/image_selector.dart';
import '../../providers/trips/logic_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../core.dart';

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
        iconTheme: IconThemeData(color: context.getTextColor()),
        title: Text('Settings', style: TextStyle(color: context.getTextColor())),
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
          _section([
            Padding(
              padding: const EdgeInsets.all(14),
              child: TextFormField(
                initialValue: trip.name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                style: TextStyle(color: context.getTextColor()),
                onFieldSubmitted: (text) {
                  context.read(tripsLogicProvider).updateTrip({'name': text});
                },
              ),
            ),
          ]),
          if (templateSettings != null) _section([...templateSettings], title: 'Template'),
          for (var settings in moduleSettings) _section(settings.settings, title: settings.title),
          _section([
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

  Widget _section(List<Widget> children, {String? title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: FillColor(
        builder: (context, color) => Material(
          color: color,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
