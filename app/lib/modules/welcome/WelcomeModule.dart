import 'package:flutter/material.dart';
import 'package:jufa/general/widgets/widgets.dart';

import '../../general/module/Module.dart';

@Module()
class WelcomeModule {

  ModuleData moduleData;
  WelcomeModule(this.moduleData);

  @ModuleItem(id: "banner")
  BodySegment getWelcomeBanner() {
    return BodySegment(
      size: SegmentSize.Wide,
      builder: (context) => AspectRatio(
        aspectRatio: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(child: Text("Welcome")),
        ),
      ),
    );
  }

}
