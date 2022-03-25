import 'package:flutter/material.dart';

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
      ),
    );
  }
}

class TripSettingsButton extends StatelessWidget {
  const TripSettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: InkResponse(
        child: Icon(Icons.settings, color: context.onSurfaceColor, size: 20),
        onTap: () {
          if (WidgetTemplate.of(context, listen: false).isEditing) {
            WidgetTemplate.of(context, listen: false).toggleEdit();
          }
          Navigator.push(context, TripSettingsPage.route());
        },
      ),
    );
  }
}
