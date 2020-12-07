part of templates;

class ReorderToggle extends StatefulWidget {
  ReorderToggle();

  @override
  _ReorderToggleState createState() => _ReorderToggleState();
}

class _ReorderToggleState extends State<ReorderToggle> with FlareController {

  Animation<double> transition;

  FlutterActorArtboard artboard;
  ActorAnimation iconAnimation;

  @override
  void dispose() {
    super.dispose();
    if (this.transition != null)
      this.transition.removeListener(onAnimationTick);
  }


  setTransition(Animation<double> transition) {
    if (this.transition == transition) return;
    if (this.transition != null) this.transition.removeListener(onAnimationTick());
    this.transition = transition;
    this.transition.addListener(onAnimationTick());
  }

  onAnimationTick() {
    if (this.artboard == null || this.iconAnimation == null) return;
    var time = this.transition.value * this.iconAnimation.duration;
    this.iconAnimation.apply(time, this.artboard, 1.0);
    this.isActive.value = true;
  }

  @override
  Widget build(BuildContext context) {

    var state = TripTemplate.of(context);
    setTransition(state.transition);

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
        state.toggleEdit();
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
