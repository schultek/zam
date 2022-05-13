import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../profile.module.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget(this.params, {Key? key}) : super(key: key);

  final ProfileImageElementParams params;

  @override
  Widget build(BuildContext context) {
    var user = context.watch(groupUserProvider);

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
            if (params.showName) ...[
              const SizedBox(height: 15),
              if (user?.nickname != null)
                Text(
                  '${params.showGreeting ? getGreeting(context) + ' ' : ''}${user!.nickname!}',
                  style: context.theme.textTheme.titleMedium!.apply(color: context.onSurfaceColor),
                  textAlign: TextAlign.center,
                ),
            ],
          ],
        ),
      ),
    );
  }

  String getGreeting(BuildContext context) {
    var date = DateTime.now();
    if (date.hour < 6) {
      return context.tr.good_night;
    } else if (date.hour < 11) {
      return context.tr.good_morning;
    } else if (date.hour < 18) {
      return context.tr.hello;
    } else if (date.hour < 22) {
      return context.tr.good_evening;
    } else {
      return context.tr.good_night;
    }
  }
}
