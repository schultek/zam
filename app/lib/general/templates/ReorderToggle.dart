part of templates;

class ReorderToggle extends StatefulWidget {
  ReorderToggle();

  @override
  _ReorderToggleState createState() => _ReorderToggleState();
}

class _ReorderToggleState extends State<ReorderToggle> with FlareController {

  FlutterActorArtboard artboard;
  ActorAnimation iconAnimation;

  @override
  Widget build(BuildContext context) {

    var state = WidgetTemplate.of(context, listen: false);

    return IconButton(
      icon: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: <Color>[Colors.grey[600], Colors.grey[600]],
          ).createShader(bounds);
        },
        child: AnimatedBuilder(
          animation: state.transition,
          builder: (context, child) {
            if (this.iconAnimation != null) {
              var time = state.transition.value * this.iconAnimation.duration;
              this.iconAnimation.apply(time, this.artboard, 1.0);
              this.isActive.value = true;
            }
            return child;
          },
          child: FlareActor(
            "lib/assets/animations/reorder_icon.flr",
            alignment:Alignment.center,
            fit:BoxFit.contain,
            controller: this,
          ),
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
