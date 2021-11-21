import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../core/widgets/widget_selector.dart';
import 'pages/camera_page.dart';

class CameraModule extends ModuleBuilder<PageSegment> {
  @override
  FutureOr<PageSegment?> build(ModuleContext context) {
    return PageSegment(
      context: context,
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
