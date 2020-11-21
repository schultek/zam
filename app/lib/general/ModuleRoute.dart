part of module;

class ModulePageRoute extends PageRouteBuilder {
  final Widget child;

  ModulePageRoute(BuildContext context, {this.child})
      : super(
          reverseTransitionDuration: Duration(milliseconds: 800),
          transitionDuration: Duration(milliseconds: 800),
          maintainState: false,
          pageBuilder: (ctx, animation, a2) {

            var module = ModuleCardLocator.of(context);
            if (module == null) {
              return child;
            }

            animation.addStatusListener((status) {
              module.animate(animation.value);
            });
            
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                var transition = module.animate(animation.value);
                if (transition != null) {
                  return Stack(
                    children: [
                      ClipRRect(
                        clipper: TransitionClipper(transition),
                        child: Opacity(
                            opacity: transition.pageOpacity,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: getPageTransform(transition, ctx),
                              child: child,
                            )
                        ),
                      ),
                    ],
                  );
                } else {
                  return Opacity(
                    opacity: animation.value,
                    child: child
                  );
                }
              },
              child: child,
            );
          },
          transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
            return child;
          },
        );

  static Matrix4 getPageTransform(ModuleTransition transition, BuildContext context) {

    var size = MediaQuery.of(context).size;

    var scaleY = transition.page.height / size.height;
    var scaleX = transition.page.width / size.width;

    var scale = max(scaleY, scaleX);

    var dx = transition.page.center.dx - size.width/2;
    var dy = transition.page.center.dy - size.height/2;

    return Matrix4.identity()..translate(dx, dy)..scale(scale);

  }
}

class ModuleTransition {

  Rect page;

  double cardShadow;
  double clipRadius;
  double pageOpacity;

  ModuleTransition(this.page, double value) {
    this.cardShadow = min(0.3, value * 2);
    this.clipRadius = (1 - Curves.easeIn.transformRange(value, r: Range(0.7, 1))) * 20;
    this.pageOpacity = Curves.easeInOut.transformRange(value, r: Range(0.1, 1));
  }
}

class TransitionClipper extends CustomClipper<RRect> {
  ModuleTransition transition;

  TransitionClipper(this.transition);

  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndRadius(transition.page, Radius.circular(transition.clipRadius));
  }

  @override
  bool shouldReclip(TransitionClipper oldClipper) => oldClipper.transition != transition;
}
