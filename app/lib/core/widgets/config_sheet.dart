import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/trips/selected_trip_provider.dart';
import '../core.dart';
import '../providers/editing_providers.dart';

class ConfigSheetController {
  final BuildContext _context;

  void close() {
    Route? lastRoute;
    Navigator.of(_context).popUntil((route) {
      try {
        return lastRoute is ConfigSheetRoute;
      } finally {
        lastRoute = route;
      }
    });
  }

  const ConfigSheetController(this._context);
}

class ConfigSheet<T extends TemplateModel> extends StatefulWidget {
  const ConfigSheet({Key? key}) : super(key: key);

  static ConfigSheetController show<T extends TemplateModel>(BuildContext context) {
    var trip = context.read(selectedTripProvider)!;

    Navigator.of(context).push(ConfigSheetRoute<T>(trip));

    return ConfigSheetController(context);
  }

  @override
  State<ConfigSheet> createState() => _ConfigSheetState<T>();
}

class ConfigSheetRoute<T extends TemplateModel> extends TransitionRoute {
  ConfigSheetRoute(this.trip);
  final Trip trip;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        builder: (context) => Align(
          alignment: Alignment.bottomCenter,
          child: InheritedTheme.captureAll(
            context,
            TripTheme(
              theme: TripThemeData.fromModel(trip.theme),
              child: ConfigSheet<T>(),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  Future<RoutePopDisposition> willPop() async {
    return RoutePopDisposition.doNotPop;
  }
}

class _ConfigSheetState<T extends TemplateModel> extends State<ConfigSheet<T>> {
  @override
  Widget build(BuildContext context) {
    context.watch(currentPageProvider);

    var state = WidgetTemplate.of(context, listen: false);
    var settings = state.getPageSettings();

    if (settings.isEmpty) {
      return Container();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.08,
      maxChildSize: 0.5,
      snap: true,
      snapSizes: const [0.2, 0.3],
      builder: (context, scrollController) => ThemedSurface(
        preference: const ColorPreference(deltaElevation: 0),
        builder: (context, color) => Container(
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: -4)],
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Material(
              color: color,
              child: ListView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: settings,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
