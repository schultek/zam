import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../files_provider.dart';
import '../widgets/gallery_preview.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  static Future<List<CameraDescription>> camerasFuture = availableCameras();
  CameraController? controller;

  double minZoom = 1;
  double maxZoom = 1;
  double zoom = 1;
  double nextZoom = 1;

  FlashMode flashMode = FlashMode.off;
  bool takingPicture = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    camerasFuture.then((cameras) => initController(cameras[0]));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initController(cameraController.description);
    }
  }

  Future<void> initController(CameraDescription camera) async {
    if (controller != null) {
      await controller!.dispose();
    }

    CameraController cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController.getMaxZoomLevel().then((value) => maxZoom = value),
        cameraController.getMinZoomLevel().then((value) => minZoom = value),
      ]);
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  IconData get flashModeIcon =>
      [Icons.flash_off, Icons.flash_auto, Icons.flash_on][FlashMode.values.indexOf(flashMode)];

  void toggleFlashMode() {
    if (!controllerIsInitialized) return;
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

  bool get controllerIsInitialized => controller != null && controller!.value.isInitialized;

  Future<void> takePicture() async {
    if (!controllerIsInitialized) return;
    setState(() => takingPicture = true);
    var file = await controller!.takePicture();
    await context.read(filesLogicProvider).addPicture(file);
    setState(() => takingPicture = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          SafeArea(
            top: false,
            child: Column(
              children: [
                const Spacer(),
                if (controllerIsInitialized)
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
                    child: CameraPreview(
                      controller!,
                      child: TweenAnimationBuilder<double>(
                        key: ValueKey(takingPicture),
                        tween: Tween(begin: takingPicture ? 0 : 1, end: 0),
                        duration: const Duration(milliseconds: 200),
                        builder: (context, value, _) {
                          return Container(
                            color: Colors.black.withOpacity(value > 0.5 ? 1 : value * 2),
                          );
                        },
                      ),
                    ),
                  ),
                SizedBox(
                  height: 120,
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
