import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/groups/selected_group_provider.dart';
import '../../providers/editing_providers.dart';
import '../../themes/themes.dart';
import '../../widgets/layout_preview.dart';
import 'edit_toggle.dart';
import 'group_selector.dart';

class MainGroupHeader extends StatelessWidget {
  const MainGroupHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 10, right: 10, bottom: 10),
      child: Consumer(
        builder: (context, ref, _) {
          var group = ref.watch(selectedGroupProvider)!;
          var isOrganizer = ref.watch(isOrganizerProvider);

          var isEditing = ref.watch(isEditingProvider);

          var leading = [
            if (!isEditing) const GroupSelectorButton(),
            if (isEditing && isOrganizer) const GroupSettingsButton(),
            if (isEditing && !isOrganizer) const SizedBox(width: 50),
          ];

          var trailing = [
            if (!isOrganizer) const SizedBox(width: 50),
            if (isOrganizer) EditToggles(isEditing: isEditing),
          ];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...leading,
              Expanded(
                child: Text(
                  group.name,
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
