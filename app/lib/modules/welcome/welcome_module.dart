import 'package:flutter/material.dart';

import '../../general/module/Module.dart';
import '../../general/widgets/widgets.dart';

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

  @ModuleItem(id: "banner")
  BodySegment getWelcomeBanner() {
    return BodySegment(
      size: SegmentSize.Wide,
      builder: (context) => const AspectRatio(
        aspectRatio: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(child: Text("Welcome")),
        ),
      ),
    );
  }

  @ModuleItem(id: "banner2")
  BodySegment getWelcomeBanner2() {
    return BodySegment(
      size: SegmentSize.Wide,
      builder: (context) => const AspectRatio(
        aspectRatio: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(child: Text("Bonjour")),
        ),
      ),
    );
  }

  @ModuleItem(id: "banner3")
  BodySegment getWelcomeBanner3() {
    return BodySegment(
      size: SegmentSize.Wide,
      builder: (context) => const AspectRatio(
        aspectRatio: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(child: Text("Willkommen")),
        ),
      ),
    );
  }
}
