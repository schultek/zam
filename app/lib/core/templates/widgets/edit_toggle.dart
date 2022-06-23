import 'dart:typed_data';

import 'package:flare_flutter/asset_provider.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_context/riverpod_context.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../editing/editing_providers.dart';
import '../../themes/themes.dart';

class EditToggles extends StatelessWidget {
  const EditToggles({this.isEditing = true, this.notifyVisibility = true, Key? key}) : super(key: key);

  final bool notifyVisibility;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    Widget child = const ReorderToggle();

    if (notifyVisibility) {
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
      child = VisibilityDetector(
        key: const ValueKey('edit-toggles'),
        onVisibilityChanged: (visibilityInfo) {
          context.read(toggleVisibilityProvider.notifier).state = visibilityInfo.visibleFraction > 0.1;
        },
        child: child,
      );
    }

    return child;
  }
}

class ReorderToggle extends StatefulWidget {
  const ReorderToggle({Key? key}) : super(key: key);

  @override
  _ReorderToggleState createState() => _ReorderToggleState();
}

class MyAssetProvider extends AssetProvider {
  final String asset;
  MyAssetProvider(this.asset);

  static final Map<String, Future<ByteData>> _cached = {};

  @override
  Future<ByteData> load() {
    return _cached[asset] ??= rootBundle.load(asset);
  }
}

class _ReorderToggleState extends State<ReorderToggle> with FlareController, TickerProviderStateMixin {
  FlutterActorArtboard? artboard;
  ActorAnimation? iconAnimation;

  static MyAssetProvider iconProvider = MyAssetProvider('assets/animations/reorder_icon.flr');

  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..value = context.read(isEditingProvider) ? 1 : 0;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.listen<bool>(isEditingProvider, (_, isEditing) {
      if (isEditing && controller.value != 1 && controller.status != AnimationStatus.forward) {
        controller.forward();
      } else if (!isEditing && controller.value != 0 && controller.status != AnimationStatus.reverse) {
        controller.reverse();
      }
    });

    Widget child = SizedBox(
      width: 50,
      child: IconButton(
        icon: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: <Color>[context.onSurfaceColor, context.onSurfaceColor],
            ).createShader(bounds);
          },
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              if (iconAnimation != null && artboard != null) {
                var time = controller.value * iconAnimation!.duration;
                iconAnimation!.apply(time, artboard!, 1.0);
                isActive.value = true;
              }
              return child!;
            },
            child: FlareActor.asset(
              iconProvider,
              controller: this,
            ),
          ),
        ),
        onPressed: () {
          context.read(editProvider.notifier).toggleEdit();
        },
      ),
    );

    return child;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    this.artboard = artboard;
    iconAnimation = artboard.getAnimation('go');

    var time = controller.value * iconAnimation!.duration;
    iconAnimation!.apply(time, artboard, 1.0);
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) => false;

  @override
  void setViewTransform(Mat2D viewTransform) {}
}
