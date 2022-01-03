import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../providers/trips/selected_trip_provider.dart';
import '../../core.dart';
import '../../widgets/trip_selector_page.dart';
import '../../widgets/trip_settings_page.dart';

class TripSelectorButton extends StatelessWidget {
  const TripSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: InkResponse(
        child: Icon(Icons.menu_open, color: context.onSurfaceColor),
        onTap: () {
          if (WidgetTemplate.of(context, listen: false).isEditing) {
            WidgetTemplate.of(context, listen: false).toggleEdit();
          }
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TripSelectorPage()));
        },
        onLongPress: context.read(isOrganizerProvider) ? () => Navigator.push(context, TripSettingsPage.route()) : null,
      ),
    );
  }
}
