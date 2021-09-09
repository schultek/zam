import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/loading_shimmer.dart';
import '../announcement_provider.dart';

class AnnouncementCard extends StatelessWidget {
  final AsyncValue<Announcement> announcement;
  const AnnouncementCard({Key? key, required this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: announcement.when(
        data: (data) => Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: AutoSizeText(
              data.message,
              style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
              maxLines: 5,
              stepGranularity: 10,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        loading: () => const LoadingShimmer(),
        error: (e, st) => Center(child: Text('Error $e')),
      ),
    );
  }
}
