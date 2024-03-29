import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modules/thebutton/thebutton.module.dart';
import '../modules/thebutton/widgets/thebutton_shape.dart';

class UserAvatar extends StatelessWidget {
  final String id;
  final bool small;
  final bool needsSurface;
  const UserAvatar({Key? key, required this.id, this.small = false, this.needsSurface = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var child = Consumer(
      builder: (context, ref, _) {
        var user = ref.watch(groupUserByIdProvider(id));
        var showButtonLevel = ref.watch(theButtonProvider.select((v) => v.value?.showInAvatars ?? false));
        var userLevel = ref.watch(theButtonUserLevelProvider(id));
        return CircleAvatar(
          radius: small ? 15 : 20,
          backgroundColor: context.surfaceColor,
          foregroundColor: context.onSurfaceColor,
          backgroundImage: user?.profileUrl != null ? CachedNetworkImageProvider(user!.profileUrl!) : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (user?.profileUrl == null)
                if (user?.nickname != null)
                  Center(child: Text(user!.nickname!.substring(0, 1)))
                else
                  Center(child: Icon(Icons.account_circle_outlined, size: small ? 20 : 25)),
              if (showButtonLevel)
                if (userLevel != null && userLevel >= 0 && userLevel < theButtonLevelsCount)
                  Positioned(right: -13, bottom: -13, child: StarPaint(color: getColorForLevel(userLevel, context)))
            ],
          ),
        );
      },
    );
    if (needsSurface) {
      return ThemedSurface(
        preference: const ColorPreference(useHighlightColor: true),
        builder: (context, color) => child,
      );
    } else {
      return child;
    }
  }
}
