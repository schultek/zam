import 'package:flutter/material.dart';

import '../../core/module/module.dart';
import '../../core/templates/templates.dart';
import '../../core/themes/themes.dart';
import '../../models/models.dart';

class TripScreen extends StatelessWidget {
  final Trip trip;
  const TripScreen(this.trip);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeState>(
      future: ImageTheme.load(),
      builder: (context, snapshot) => TripTheme(
        theme: snapshot.hasData ? snapshot.data! : DarkTheme(),
        child: Navigator(
          onGenerateInitialRoutes: (state, route) {
            return [
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: BasicTemplate(
                    ModuleData(trip: trip),
                  ),
                ),
              ),
            ];
          },
          initialRoute: '/',
        ),
      ),
    );
  }
}
