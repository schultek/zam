import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../../widgets/loading_shimmer.dart';
import 'pages/thebutton_help.dart';
import 'pages/thebutton_settings.dart';
import 'thebutton_provider.dart';
import 'widgets/thebutton_widget.dart';

class TheButtonModule extends ModuleBuilder {
  TheButtonModule() : super('thebutton');

  @override
  String getName(BuildContext context) => context.tr.the_button;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'thebutton': buildTheButton,
      };

  @override
  ModuleSettings? getSettings(BuildContext context) {
    var state = context.watch(theButtonProvider);

    return state.whenOrNull<ModuleSettings?>(
      data: (state) => state != null
          ? ModuleSettings([
              SwitchListTile(
                title: Text(context.tr.show_level_in_avatars),
                value: state.showInAvatars,
                onChanged: (v) => context.read(theButtonLogicProvider).setShowInAvatars(v),
              ),
            ])
          : null,
    );
  }

  FutureOr<ContentSegment?> buildTheButton(ModuleContext module) {
    var buttonHelpKey = GlobalKey();
    var buttonSettingsKey = GlobalKey();
    return ContentSegment(
      module: module,
      builder: (context) {
        return Consumer(builder: (context, ref, _) {
          var state = ref.watch(theButtonProvider);
          return state.when(
            data: (state) {
              if (state == null) {
                context.read(theButtonLogicProvider).init();
                return const LoadingShimmer();
              }
              return Stack(
                children: [
                  const Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: TheButton(),
                    ),
                  ),
                  if (context.read(isOrganizerProvider))
                    Positioned.fill(child: TheButtonSettings(key: buttonSettingsKey)),
                  Positioned.fill(child: TheButtonHelp(key: buttonHelpKey)),
                ],
              );
            },
            loading: () => const LoadingShimmer(),
            error: (e, st) => Text('${context.tr.error}: $e'),
          );
        });
      },
    );
  }
}
