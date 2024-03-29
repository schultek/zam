part of route;

class ModulePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  ModulePageRoute(BuildContext context, {required this.child})
      : super(
          maintainState: false,
          pageBuilder: (ctx, animation, a2) {
            var transitionState = ModuleRouteTransition.of(context);
            if (transitionState == null) {
              return child;
            }

            animation.addStatusListener((status) {
              transitionState.onAnimate(context, animation.value);
            });

            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                var transition = transitionState.onAnimate(context, animation.value);
                return Stack(
                  children: [
                    transition.card,
                    ClipRRect(
                      clipper: TransitionClipper(transition),
                      child: Opacity(
                        opacity: transition.pageOpacity,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: getPageTransform(transition, ctx),
                          child: child,
                        ),
                      ),
                    ),
                  ],
                );
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

    var dx = transition.page.center.dx - size.width / 2;
    var dy = transition.page.center.dy - size.height / 2;

    return Matrix4.identity()
      ..translate(dx, dy)
      ..scale(scale);
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
