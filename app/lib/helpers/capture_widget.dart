import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CaptureWidget {
  /// * If the widget is not in the widget tree, use this method.
  /// if the fileName is not set, it sets the file name as "davinci".
  /// you can define whether to openFilePreview or returnImageUint8List
  /// If the image is blurry, calculate the pixelratio dynamically. See the readme
  /// for more info on how to do it.
  static Future<Uint8List> offStage(
    Widget widget, {
    double? pixelRatio,
  }) async {
    /// finding the widget in the current context by the key.
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    /// create a new pipeline owner
    final PipelineOwner pipelineOwner = PipelineOwner();

    /// create a new build owner
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

    Size logicalSize = ui.window.physicalSize / ui.window.devicePixelRatio;
    pixelRatio ??= ui.window.devicePixelRatio;

    final RenderView renderView = RenderView(
      window: ui.window,
      child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: 1.0,
      ),
    );

    /// setting the rootNode to the renderview of the widget
    pipelineOwner.rootNode = renderView;

    /// setting the renderView to prepareInitialFrame
    renderView.prepareInitialFrame();

    /// setting the rootElement with the widget that has to be captured
    final RenderObjectToWidgetElement<RenderBox> rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
    ).attachToRenderTree(buildOwner);

    ///adding the rootElement to the buildScope
    buildOwner.buildScope(rootElement);

    ///adding the rootElement to the buildScope
    buildOwner.buildScope(rootElement);

    /// finialize the buildOwner
    buildOwner.finalizeTree();

    ///Flush Layout
    pipelineOwner.flushLayout();

    /// Flush Compositing Bits
    pipelineOwner.flushCompositingBits();

    /// Flush paint
    pipelineOwner.flushPaint();

    /// we start the createImageProcess once we have the repaintBoundry of
    /// the widget we attached to the widget tree.
    return _createImageProcess(
      repaintBoundary: repaintBoundary,
      pixelRatio: pixelRatio,
    );
  }

  /// create image process
  static Future<Uint8List> _createImageProcess(
      {required RenderRepaintBoundary repaintBoundary, required double pixelRatio}) async {
    /// the boundary is converted to Image.
    final ui.Image image = await repaintBoundary.toImage(pixelRatio: pixelRatio);

    /// The raw image is converted to byte data.
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    /// The byteData is converted to uInt8List image aka memory Image.
    final u8Image = byteData!.buffer.asUint8List();

    return u8Image;
  }
}
