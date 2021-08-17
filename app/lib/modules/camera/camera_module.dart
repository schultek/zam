import 'package:flutter/material.dart';

import '../../core/elements/elements.dart';
import '../../core/module/module.dart';
import '../../core/widgets/widget_selector.dart';
import 'pages/camera_page.dart';

@Module('camera')
class CameraModule {
  @ModuleItem('camera')
  PageSegment getCameraPage() {
    return PageSegment(
      builder: (context) {
        if (WidgetSelector.existsIn(context)) {
          return const Center(child: Text('Camera'));
        }
        return const CameraPage();
      },
    );
  }
}
