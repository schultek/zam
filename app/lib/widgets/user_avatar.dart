import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/themes/themes.dart';
import '../modules/thebutton/thebutton_provider.dart';
import '../modules/thebutton/widgets/thebutton_shape.dart';
import '../providers/trips/selected_trip_provider.dart';

class UserAvatar extends StatelessWidget {
  final String id;
  const UserAvatar({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        var user = ref.watch(tripUserByIdProvider(id));
        var showButtonLevel = ref.watch(theButtonProvider.select((v) => v.value?.showInAvatars ?? false));
        var userLevel = ref.watch(theButtonUserLevelProvider(id));
        return CircleAvatar(
          backgroundColor: context.theme.colorScheme.primary,
          foregroundColor: context.theme.colorScheme.onPrimary,
          backgroundImage: user?.profileUrl != null ? CachedNetworkImageProvider(user!.profileUrl!) : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (user?.profileUrl == null)
                if (user?.nickname != null)
                  Center(child: Text(user!.nickname!.substring(0, 1)))
                else
                  const Center(child: Icon(Icons.account_circle_outlined, size: 25)),
              if (showButtonLevel)
                if (userLevel != null && userLevel >= 0 && userLevel < theButtonLevelsCount)
                  Positioned(right: -13, bottom: -13, child: StarPaint(color: getColorForLevel(userLevel, context)))
            ],
          ),
        );
      },
    );
  }
}
