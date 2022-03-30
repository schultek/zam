import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../announcement.module.dart';

class AnnouncementCard extends StatelessWidget {
  final AsyncValue<Announcement> announcement;
  final VoidCallback? onDismissed;
  const AnnouncementCard({Key? key, required this.announcement, this.onDismissed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.1,
      child: announcement.when(
        data: (data) {
          Widget child = Container(
            color: data.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (data.title != null && data.title!.isNotEmpty) ...[
                    Flexible(
                      child: Center(
                        child: AutoSizeText(
                          data.title!,
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: data.textColor ?? context.onSurfaceColor,
                          ),
                          maxLines: 5,
                          stepGranularity: 10,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Expanded(
                    child: Center(
                      child: AutoSizeText(
                        data.message,
                        style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          color: data.textColor ?? context.onSurfaceColor,
                        ),
                        maxLines: 5,
                        stepGranularity: 10,
                        minFontSize: 10,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          if (data.isDismissible) {
            child = Stack(
              children: [
                child,
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.close, color: data.textColor),
                    onPressed: onDismissed,
                  ),
                ),
              ],
            );
          }
          return child;
        },
        loading: () => const LoadingShimmer(),
        error: (e, st) => Center(child: Text('${context.tr.error} $e')),
      ),
    );
  }
}
