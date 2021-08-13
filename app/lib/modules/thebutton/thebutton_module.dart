import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/module/module.dart';
import '../../providers/trips/selected_trip_provider.dart';
import 'pages/thebutton_help.dart';
import 'pages/thebutton_settings.dart';
import 'widgets/thebutton_widget.dart';

@Module()
class TheButtonModule {
  @ModuleItem(id: "thebutton")
  ContentSegment getButtonCard() {
    var buttonHelpKey = GlobalKey(), buttonSettingsKey = GlobalKey();
    return ContentSegment(
      builder: (context) => Stack(
        children: [
          const Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: TheButton(),
            ),
          ),
          if (context.read(isOrganizerProvider)) Positioned.fill(child: TheButtonSettings(key: buttonSettingsKey)),
          Positioned.fill(child: TheButtonHelp(key: buttonHelpKey)),
        ],
      ),
    );
  }
}
