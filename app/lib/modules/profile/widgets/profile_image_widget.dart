import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../providers/trips/selected_trip_provider.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = context.watch(tripUserProvider);

    var date = DateTime.now();
    String greeting;
    if (date.hour < 6) {
      greeting = 'Gute Nacht';
    } else if (date.hour < 11) {
      greeting = 'Guten Morgen';
    } else if (date.hour < 13) {
      greeting = 'Guten Mittag';
    } else if (date.hour < 18) {
      greeting = 'Hallo';
    } else if (date.hour < 22) {
      greeting = 'Guten Abend';
    } else {
      greeting = 'Gute Nacht';
    }

    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AspectRatio(
                aspectRatio: 1,
                child: ThemedSurface(
                  preference: const ColorPreference(useHighlightColor: true),
                  builder: (context, color) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: color, width: 2),
                      shape: BoxShape.circle,
                      image: user?.profileUrl != null
                          ? DecorationImage(image: CachedNetworkImageProvider(user!.profileUrl!))
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (user?.nickname != null)
              Text(
                '$greeting ${user!.nickname!}',
                style: context.theme.textTheme.headline5!.apply(color: context.onSurfaceColor),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}