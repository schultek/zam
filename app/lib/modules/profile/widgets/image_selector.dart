library image_selector;

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImageSelector {
  static Future<Uint8List?> fromGallery(BuildContext context) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    var bytes = await image.readAsBytes();
    Uint8List? pngData = await showDialog(context: context, builder: (context) => CropDialog(image: bytes));
    return pngData;
  }
}

class CropDialog extends StatefulWidget {
  final Uint8List image;

  const CropDialog({required this.image, Key? key}) : super(key: key);

  @override
  _CropDialogState createState() => _CropDialogState();
}

class _CropDialogState extends State<CropDialog> {
  double? width;
  double scale = 1.0;
  double? previousScale;
  double? startX;
  double? startY;
  double? previousX;
  double? previousY;
  double x = 0;
  double y = 0;

  GlobalKey scr = GlobalKey();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color.fromARGB(220, 0, 0, 0),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(30),
              child: const Text(
                'Adjust image',
                style: TextStyle(color: CupertinoColors.white),
              ),
            ),
            GestureDetector(
              onScaleStart: (ScaleStartDetails details) {
                previousScale = scale;
                startX = details.focalPoint.dx;
                startY = details.focalPoint.dy;
                previousX = x;
                previousY = y;
              },
              onScaleUpdate: (ScaleUpdateDetails details) {
                setState(() {
                  if (details.scale == 1) {
                    x = details.focalPoint.dx - startX! + previousX!;
                    y = details.focalPoint.dy - startY! + previousY!;
                  }
                  scale = previousScale! * details.scale;
                });
              },
              onScaleEnd: (ScaleEndDetails details) {
                previousScale = null;
                previousX = null;
                previousY = null;
              },
              child: CustomPaint(
                painter: _Box(),
                child: RepaintBoundary(
                  key: scr,
                  child: Container(
                    width: width,
                    color: CupertinoColors.black,
                    height: width,
                    child: ClipRect(
                      child: Transform(
                        transform: Matrix4.translationValues(x, y, 0),
                        alignment: FractionalOffset.center,
                        child: Transform(
                          transform: Matrix4.identity()..scale(scale, scale),
                          alignment: FractionalOffset.center,
                          child: Image.memory(widget.image),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(50),
              child: CupertinoButton.filled(
                onPressed: () async {
                  RenderRepaintBoundary? boundary = scr.currentContext!.findRenderObject() as RenderRepaintBoundary?;
                  Uint8List? bytes;
                  if (boundary != null) {
                    var origBytes = await (await boundary.toImage()).toByteData(format: ui.ImageByteFormat.png);
                    if (origBytes != null) {
                      var origImg = img.decodeImage(origBytes.buffer.asUint8List());
                      if (origImg != null) {
                        var thumbnail = img.copyResize(origImg, width: 300);
                        bytes = Uint8List.fromList(img.encodePng(thumbnail));
                      }
                    }
                  }

                  Navigator.of(context).pop(bytes);
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Box extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var paint = Paint();
    paint.strokeWidth = 3;
    paint.color = const Color.fromARGB(200, 255, 255, 255);
    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset.zero, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
