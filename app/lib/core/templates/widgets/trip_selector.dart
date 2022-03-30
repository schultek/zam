import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/editing_providers.dart';
import '../../providers/selected_area_provider.dart';
import '../../themes/themes.dart';
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
          if (context.read(isEditingProvider)) {
            context.read(editProvider.notifier).toggleEdit();
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
          if (context.read(isEditingProvider)) {
            context.read(selectedAreaProvider.notifier).selectWidgetAreaById(null);
          }
          Navigator.push(context, TripSettingsPage.route());
        },
      ),
    );
  }
}
