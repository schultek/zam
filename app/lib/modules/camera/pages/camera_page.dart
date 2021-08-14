import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../widgets/gallery_preview.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  static Future<List<CameraDescription>> camerasFuture = availableCameras();
  CameraController? controller;

  late double minZoom, maxZoom;
  double zoom = 1, nextZoom = 1;

  FlashMode flashMode = FlashMode.off;
  bool takingPicture = false;

  @override
  void initState() {
    super.initState();

    camerasFuture.then((cameras) async {
      await initController(cameras[0]);
    });
  }

  Future<void> initController(CameraDescription camera) async {
    controller = CameraController(camera, ResolutionPreset.max);
    await controller!.initialize();
    minZoom = await controller!.getMinZoomLevel();
    maxZoom = await controller!.getMaxZoomLevel();

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  IconData get flashModeIcon =>
      [Icons.flash_off, Icons.flash_auto, Icons.flash_on][FlashMode.values.indexOf(flashMode)];

  void toggleFlashMode() {
    var i = FlashMode.values.indexOf(flashMode);
    flashMode = FlashMode.values[(i + 1) % 3];
    controller?.setFlashMode(flashMode);
    setState(() {});
  }

  Future<void> switchCamera() async {
    await camerasFuture.then((cameras) async {
      var i = cameras.indexOf(controller!.description);
      await initController(cameras[(i + 1) % cameras.length]);
    });
  }

  Future<void> takePicture() async {
    setState(() => takingPicture = true);
    var file = await controller!.takePicture();
    print(file.path);
    setState(() => takingPicture = false);
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTapUp: (details) {
                  controller!.setFocusPoint(Offset(
                    details.globalPosition.dx / MediaQuery.of(context).size.width,
                    details.globalPosition.dy / MediaQuery.of(context).size.height,
                  ));
                },
                onScaleUpdate: (details) {
                  print(details.scale);
                  nextZoom = zoom * details.scale;
                  nextZoom = min(max(nextZoom, minZoom), maxZoom);
                  controller!.setZoomLevel(nextZoom);
                },
                onScaleEnd: (details) {
                  zoom = nextZoom;
                },
                child: CameraPreview(controller!),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(flashModeIcon),
                      onPressed: toggleFlashMode,
                    ),
                    InkWell(
                      onTap: takePicture,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: takingPicture ? Colors.black : Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_android),
                      onPressed: switchCamera,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Positioned(
            top: 20,
            right: 20,
            child: SafeArea(child: GalleryPreview()),
          ),
        ],
      ),
    );
  }
}
