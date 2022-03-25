import 'dart:typed_data';

import 'package:flare_flutter/asset_provider.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../themes/theme_context.dart';
import '../widget_template.dart';

class ReorderToggle extends StatefulWidget {
  final void Function()? onPressed;
  const ReorderToggle({this.onPressed, Key? key}) : super(key: key);
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
      ..value = WidgetTemplate.of(context, listen: false).transition.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var state = WidgetTemplate.of(context);

    if (state.isEditing && controller.value != 1) {
      controller.forward();
    } else if (!state.isEditing && controller.value != 0) {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = WidgetTemplate.of(context, listen: false);
    return SizedBox(
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
          widget.onPressed?.call();
          state.toggleEdit();
        },
      ),
    );
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
