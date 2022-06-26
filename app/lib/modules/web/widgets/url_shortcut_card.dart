import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../web_module.dart';

class UrlShortcutCard extends StatelessWidget {
  final LaunchUrlParams params;
  const UrlShortcutCard(this.params, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (params.imageUrl == null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (params.icon != null)
                Text(
                  params.icon!,
                  style: TextStyle(fontSize: 46, color: context.onSurfaceColor),
                )
              else
                Icon(Icons.language, size: 50, color: context.onSurfaceColor),
              const SizedBox(height: 10),
              Text(
                params.label ?? context.tr.launch_url,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: context.onSurfaceColor),
                overflow: TextOverflow.fade,
                softWrap: true,
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(params.imageUrl!),
          ),
        ),
        alignment: Alignment.bottomLeft,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: context.theme.primaryColor.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (params.icon != null)
                      Text(
                        params.icon!,
                        style: const TextStyle(fontSize: 25),
                      )
                    else
                      const Icon(Icons.language, size: 25),
                    const SizedBox(width: 5),
                    Text(
                      params.label ?? context.tr.launch_url,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
