import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../helpers/extensions.dart';
import '../../main.mapper.g.dart';
import '../../modules/modules.dart';
import '../../modules/profile/widgets/image_selector.dart';
import '../../providers/auth/claims_provider.dart';
import '../../providers/trips/logic_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../themes/themes.dart';
import 'layout_preview.dart';
import 'settings_section.dart';
import 'template_preview_switcher.dart';

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
        title: Text(context.tr.settings),
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
              decoration: InputDecoration(labelText: context.tr.name),
              style: TextStyle(color: context.onSurfaceColor),
              onFieldSubmitted: (text) {
                context.read(tripsLogicProvider).updateTrip({'name': text});
              },
            ),
          ]),
          SettingsSection(
            title: context.tr.template,
            children: [
              Builder(builder: (context) {
                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(trip.template.name),
                        subtitle: Text(context.tr.tap_to_change),
                        onTap: () async {
                          var newTemplate = await TemplatePreviewSwitcher.show(context, trip.template);

                          if (newTemplate != null) {
                            context.read(tripsLogicProvider).updateTemplateModel(newTemplate);
                          }
                        },
                      ),
                    ),
                    PreviewBox(preview: trip.template.preview())
                  ],
                );
              }),
              ...templateSettings
            ],
          ),
          SettingsSection(title: context.tr.theme, children: [
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
              title: Text(context.tr.dark_mode),
              value: trip.theme.dark,
              onChanged: (value) {
                context.read(tripsLogicProvider).updateTrip({'theme': trip.theme.copyWith(dark: value).toMap()});
              },
            ),
          ]),
          for (var settings in moduleSettings)
            SettingsSection(
              title: settings.key,
              children: settings.value.settings,
            ),
          SettingsSection(title: context.tr.danger_zone, children: [
            ListTile(
              title: Text(
                context.tr.leave,
                style: TextStyle(color: context.theme.colorScheme.error, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                showConfirmDialog(
                  context,
                  '${context.tr.do_want_to_leave} ${trip.name}?',
                  context.tr.leave,
                  () => context.read(tripsLogicProvider).leaveSelectedTrip(),
                );
              },
            ),
            if (context.read(claimsProvider).isOrganizer)
              ListTile(
                title: Text(
                  context.tr.delete,
                  style: TextStyle(color: context.theme.colorScheme.error, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  showConfirmDialog(
                    context,
                    '${context.tr.do_want_to_delete} ${trip.name}? ${context.tr.cant_be_undone}',
                    context.tr.delete,
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
            child: Text(context.tr.cancel),
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
