import 'dart:math';

import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flutter/material.dart';

class ReorderToggle extends StatefulWidget {

  final AnimationController controller;
  final void Function(bool on) onStartToggle;
  final void Function(bool on) onCompletedToggle;

  ReorderToggle({this.controller, this.onStartToggle, this.onCompletedToggle});

  @override
  _ReorderToggleState createState() => _ReorderToggleState();
}

class _ReorderToggleState extends State<ReorderToggle> with FlareController {

  bool isToggled = false;

  FlutterActorArtboard artboard;
  ActorAnimation iconAnimation;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onAnimationTick);
    widget.controller.addStatusListener(onAnimationStatus);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(onAnimationTick);
    widget.controller.removeStatusListener(onAnimationStatus);
  }

  onAnimationTick() {
    if (this.artboard == null || this.iconAnimation == null) return;
    var time = widget.controller.value * this.iconAnimation.duration;
    this.iconAnimation.apply(time, this.artboard, 1.0);
    this.isActive.value = true;
  }

  onAnimationStatus(status) {
    if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
      widget.onCompletedToggle(isToggled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: <Color>[Colors.grey[600], Colors.grey[600]],
          ).createShader(bounds);
        },
        child: FlareActor(
          "lib/assets/animations/reorder_icon.flr",
          alignment:Alignment.center,
          fit:BoxFit.contain,
          controller: this,
        ),
      ),
      onPressed: () {
        isToggled = !isToggled;
        if (isToggled) {
          widget.controller.forward();
        } else {
          widget.controller.reverse();
        }
        widget.onStartToggle(isToggled);
      },
    );
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    this.artboard = artboard;
    this.iconAnimation = artboard.getAnimation("go");
    this.iconAnimation.apply(0, artboard, 1.0);
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) => false;

  @override
  void setViewTransform(Mat2D viewTransform) {}
}
