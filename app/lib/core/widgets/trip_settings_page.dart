import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../main.mapper.g.dart';
import '../../modules/modules.dart';
import '../../modules/profile/widgets/image_selector.dart';
import '../../providers/auth/claims_provider.dart';
import '../../providers/trips/logic_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../templates/templates.dart';
import '../themes/themes.dart';
import 'settings_section.dart';

class TripSettingsPage extends StatefulWidget {
  const TripSettingsPage({Key? key}) : super(key: key);

  @override
  _TripSettingsPageState createState() => _TripSettingsPageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const TripSettingsPage());
  }
}

class _TripSettingsPageState extends State<TripSettingsPage> {
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
                  child: ThemedSurface(
                    builder: (context, color) => Container(
                      color: color,
                      child: trip.pictureUrl == null
                          ? Center(child: Icon(Icons.add, size: 60, color: context.onSurfaceHighlightColor))
                          : CachedNetworkImage(
                              imageUrl: trip.pictureUrl!,
                              fit: BoxFit.contain,
                            ),
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
              style: TextStyle(color: context.onSurfaceColor),
              onFieldSubmitted: (text) {
                context.read(tripsLogicProvider).updateTrip({'name': text});
              },
            ),
          ]),
          SettingsSection(
            title: 'Template',
            children: [
              Builder(builder: (context) {
                return ListTile(
                  title: Text(trip.template.name),
                  subtitle: const Text('Tap to change'),
                  onTap: () async {
                    final RenderBox button = context.findRenderObject()! as RenderBox;
                    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
                    final RelativeRect position = RelativeRect.fromRect(
                      Rect.fromPoints(
                        button.localToGlobal(Offset.zero, ancestor: overlay),
                        button.localToGlobal(button.size.bottomRight(Offset.zero) + Offset.zero, ancestor: overlay),
                      ),
                      Offset.zero & overlay.size,
                    );

                    var newTemplate = await showMenu<TemplateModel>(
                      context: context,
                      position: position,
                      items: [
                        for (var template in TemplateModel.all)
                          PopupMenuItem(value: template, child: Text(template.name)),
                      ],
                    );
                    if (newTemplate != null) {
                      context.read(tripsLogicProvider).updateTemplateModel(newTemplate);
                    }
                  },
                );
              }),
              ...templateSettings ?? []
            ],
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
          SettingsSection(title: 'Danger Zone', children: [
            ListTile(
              title: Text(
                'Leave',
                style: TextStyle(color: context.theme.colorScheme.error, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                showConfirmDialog(
                  context,
                  'Do you want to leave ${trip.name}?',
                  'Leave',
                  () => context.read(tripsLogicProvider).leaveSelectedTrip(),
                );
              },
            ),
            if (context.read(claimsProvider).isOrganizer)
              ListTile(
                title: Text(
                  'Delete',
                  style: TextStyle(color: context.theme.colorScheme.error, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  showConfirmDialog(
                    context,
                    'Do you want to delete ${trip.name}? This can\'t be undone.',
                    'Delete',
                    () => context.read(tripsLogicProvider).deleteSelectedTrip(),
                  );
                },
              ),
          ]),
        ],
      ),
    );
  }

  void showConfirmDialog(BuildContext context, String title, String action, Function() onConfirmed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(action),
            onPressed: onConfirmed,
          ),
        ],
      ),
    );
  }
}
