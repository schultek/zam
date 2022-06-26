import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/groups/selected_group_provider.dart';
import '../../editing/editing_providers.dart';
import '../../themes/themes.dart';
import '../../widgets/layout_preview.dart';
import 'edit_toggle.dart';
import 'group_selector.dart';

class InvertGroupHeader extends InheritedWidget {
  const InvertGroupHeader({
    this.invert = true,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  final bool invert;

  static InvertGroupHeader? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InvertGroupHeader>();
  }

  @override
  bool updateShouldNotify(InvertGroupHeader oldWidget) {
    return oldWidget.invert != invert;
  }
}

class MainGroupHeader extends StatelessWidget {
  const MainGroupHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 20, right: 20, bottom: 10),
      child: Consumer(
        builder: (context, ref, _) {
          var group = ref.watch(selectedGroupProvider)!;
          var isOrganizer = ref.watch(isOrganizerProvider);

          var isEditing = ref.watch(isEditingProvider);

          var leading = [
            if (!isEditing) const GroupSelectorButton(),
            if (isEditing) const GroupSelectorButton(active: false),
          ];

          var trailing = [
            if (!isOrganizer) const SizedBox(width: 40),
            if (isOrganizer) EditToggles(isEditing: isEditing),
          ];

          var invert = InvertGroupHeader.of(context)?.invert ?? false;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...leading,
              Expanded(
                child: Text(
                  group.name,
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline5!
                      .apply(color: invert ? context.surfaceColor : context.onSurfaceColor),
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
