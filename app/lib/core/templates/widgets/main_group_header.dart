import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/trips/selected_trip_provider.dart';
import '../../core.dart';
import '../../providers/editing_providers.dart';
import '../../widgets/layout_preview.dart';
import 'layout_toggle.dart';
import 'trip_selector.dart';

class MainGroupHeader extends StatelessWidget {
  const MainGroupHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 10, right: 10, bottom: 10),
      child: Consumer(
        builder: (context, ref, _) {
          var trip = ref.watch(selectedTripProvider)!;
          var user = ref.watch(tripUserProvider)!;

          var isEditing = ref.watch(isEditingProvider);

          var leading = [
            if (!isEditing) const TripSelectorButton(),
            if (isEditing && user.isOrganizer) const TripSettingsButton(),
            if (isEditing) const SizedBox(width: 50),
          ];

          var trailing = [
            if (!isEditing && !user.isOrganizer) const SizedBox(width: 50),
            if (user.isOrganizer) EditToggles(isEditing: isEditing),
          ];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...leading,
              Expanded(
                child: Text(
                  trip.name,
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline5!.apply(color: context.onSurfaceColor),
                ),
              ),
              ...trailing,
            ],
          );
        },
      ),
    );
  }

  static Widget preview() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(child: PreviewCard(width: 40, height: 10)),
    );
  }
}
