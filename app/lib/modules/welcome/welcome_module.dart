import 'package:flutter/material.dart';

import '../../core/module/module.dart';

@Module()
class WelcomeModule {
  @ModuleItem(id: "action1")
  QuickAction getAction1() {
    return QuickAction(
      icon: Icons.ac_unit,
      text: "Hallo",
    );
  }

  @ModuleItem(id: "welcome")
  ContentSegment? getWelcomeBanner(String? id) {
    if (id == null) {
      var idProvider = IdProvider();
      return ContentSegment(
        idProvider: idProvider,
        size: SegmentSize.Wide,
        builder: (context) {
          return AspectRatio(
            aspectRatio: 2,
            child: GestureDetector(
              onTap: () {
                idProvider.provide(context, "tap");
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "Willkommen",
                    style: TextStyle(color: context.getTextColor()),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return ContentSegment(
        size: SegmentSize.Wide,
        builder: (context) => AspectRatio(
          aspectRatio: 2,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                "Willkommen $id",
                style: TextStyle(color: context.getTextColor()),
              ),
            ),
          ),
        ),
      );
    }
  }
}
