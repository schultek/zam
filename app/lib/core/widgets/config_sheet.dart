import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../providers/editing_providers.dart';
import '../templates/templates.dart';
import '../themes/themes.dart';

class ConfigSheet<T extends TemplateModel> extends StatelessWidget {
  const ConfigSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch(currentPageProvider);

    var state = Template.of(context, listen: false);
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
