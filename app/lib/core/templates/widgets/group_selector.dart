import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../providers/groups/selected_group_provider.dart';
import '../../editing/editing_providers.dart';
import '../../editing/widgets/ju_logo.dart';
import '../../pages/groups_page.dart';
import '../../themes/themes.dart';

class GroupSelectorButton extends StatelessWidget {
  const GroupSelectorButton({this.active = true, Key? key}) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    var group = context.watch(selectedGroupProvider);

    Widget child = Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        boxShadow: [BoxShadow(blurRadius: 8, color: context.onSurfaceColor.withOpacity(0.4))],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: JuLogo(
          name: group?.name,
          theme: group?.theme,
          size: 40,
        ),
      ),
    );

    if (active) {
      child = InkResponse(
        child: child,
        onTap: () {
          if (context.read(isEditingProvider)) {
            context.read(editProvider.notifier).toggleEdit();
          }
          Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const SelectGroupPage(),
          ));
        },
      );
    } else {
      child = Opacity(
        opacity: 0.4,
        child: child,
      );
    }

    return SizedBox(
      width: 40,
      child: Center(child: child),
    );
  }
}
