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
      keepAlive: false,
      builder: (context) {
        if (WidgetSelector.existsIn(context)) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: context.getTextColor(),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.camera_alt, size: MediaQuery.of(context).size.width / 2),
          );
        }
        return const CameraPage();
      },
    );
  }
}
