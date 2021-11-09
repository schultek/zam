import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/trips/selected_trip_provider.dart';

class UserAvatar extends StatelessWidget {
  final String id;
  const UserAvatar({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        var user = ref.watch(tripUserByIdProvider(id));
        return CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: user?.profileUrl != null ? CachedNetworkImageProvider(user!.profileUrl!) : null,
          child: user?.profileUrl == null
              ? user?.nickname != null
                  ? Center(child: Text(user!.nickname!.substring(0, 1)))
                  : const Icon(
                      Icons.account_circle_outlined,
                      size: 25,
                    )
              : null,
        );
      },
    );
  }
}
