import 'package:flutter/material.dart';

import '../../core/module/module.dart';

@Module()
class WelcomeModule {
  ModuleData moduleData;
  WelcomeModule(this.moduleData);

  @ModuleItem(id: "action1")
  QuickAction getAction1() {
    return QuickAction(
      icon: Icons.ac_unit,
      text: "Hallo",
    );
  }

  @ModuleItem(id: "action2")
  QuickAction getAction2() {
    return QuickAction(
      icon: Icons.bakery_dining,
      text: "Test",
    );
  }

  @ModuleItem(id: "action3")
  QuickAction getAction3() {
    return QuickAction(
      icon: Icons.wine_bar,
      text: "Anja",
    );
  }

  @ModuleItem(id: "halloid")
  ContentSegment getWelcomeBanner() {
    return ContentSegment(
      size: SegmentSize.Wide,
      builder: (context) => AspectRatio(
        aspectRatio: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              "Welcome",
              style: TextStyle(color: context.getTextColor()),
            ),
          ),
        ),
      ),
    );
  }

  @ModuleItem(id: "banner2")
  ContentSegment getWelcomeBanner2() {
    return ContentSegment(
      size: SegmentSize.Wide,
      builder: (context) => AspectRatio(
        aspectRatio: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FillColor(
            builder: (context, fillColor) => Container(
              color: fillColor,
              padding: const EdgeInsets.all(10),
              child: FillColor(
                builder: (context, fillColor) => Container(
                  color: fillColor,
                  padding: const EdgeInsets.all(10),
                  child: FillColor(
                    builder: (context, fillColor) => Container(
                      color: fillColor,
                      padding: const EdgeInsets.all(10),
                      child: FillColor(
                        builder: (context, fillColor) => Container(
                          color: fillColor,
                          padding: const EdgeInsets.all(10),
                          child: FillColor(
                            builder: (context, fillColor) => Container(
                              color: fillColor,
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.portrait,
                                color: context.getTextColor(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @ModuleItem(id: "test123")
  ContentSegment getWelcomeBanner3() {
    return ContentSegment(
      size: SegmentSize.Wide,
      builder: (context) => AspectRatio(
        aspectRatio: 2,
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
  }
}
