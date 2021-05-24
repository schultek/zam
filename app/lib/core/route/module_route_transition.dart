part of route;

class _InheritedModuleRouteTransition extends InheritedWidget {
  final _ModuleRouteTransitionState state;
  const _InheritedModuleRouteTransition({Key? key, required this.state, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedModuleRouteTransition old) => true;
}

class ModuleRouteTransition extends StatefulWidget {
  final Widget child;
  const ModuleRouteTransition({required this.child});

  @override
  State<StatefulWidget> createState() => _ModuleRouteTransitionState();

  static _ModuleRouteTransitionState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedModuleRouteTransition>()?.state;
  }
}

class _ModuleRouteTransitionState extends State<ModuleRouteTransition> with SingleTickerProviderStateMixin {
  Rect? fullRect;
  final containerKey = GlobalKey();

  Rect get moduleRect => containerKey.globalPaintBounds;

  late RectTransform _moduleTransform;

  @override
  void initState() {
    super.initState();
    _moduleTransform = RectTransform(Offset.zero, 1);
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedModuleRouteTransition(
      state: this,
      child: Container(
        key: containerKey,
        child: Transform(
          alignment: Alignment.center,
          transform: _moduleTransform.toMatrix4(),
          child: widget.child,
        ),
      ),
    );
  }

  ModuleTransition onAnimate(BuildContext context, double value) {
    fullRect ??= Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    var dxCurve = Curves.easeInOutQuad;
    var dyCurve = Curves.easeInCubic;
    var dRange = const Range(0, 0.8);
    var scaleCurve = Curves.easeIn;

    var dx = fullRect!.center.dx - moduleRect.center.dx;
    var dy = fullRect!.center.dy - moduleRect.center.dy;

    _moduleTransform = RectTransform(
      Offset(dx * dxCurve.transformRange(value, r: dRange), dy * dyCurve.transformRange(value, r: dRange)),
      1 + scaleCurve.transform(value) * 0.2,
    );

    var cardRect = moduleRect.transform(_moduleTransform);

    var pageCurve = Curves.easeInOut;
    var pageRange = const Range(0.2, 1);

    var pageRect = Rect.lerp(cardRect, fullRect, pageCurve.transformRange(value, r: pageRange))!;

    var card = value > 0
        ? Positioned.fromRect(
            rect: cardRect,
            child: widget.child,
          )
        : Container();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (mounted) setState(() {});
    });

    return ModuleTransition(pageRect, card, value);
  }
}

class ModuleTransition {
  Rect page;
  Widget card;

  late double cardShadow;
  late double clipRadius;
  late double pageOpacity;

  ModuleTransition(this.page, this.card, double value) {
    cardShadow = min(0.2, value);
    clipRadius = (1 - Curves.easeIn.transformRange(value, r: const Range(0.7, 1))) * 20;
    pageOpacity = Curves.easeInOut.transformRange(value, r: const Range(0.1, 0.6));
  }
}

class Range {
  final double start;
  final double end;

  const Range(this.start, this.end) : assert(start < end);
}

extension RangedCurve on Curve {
  double transformRange(double t, {Range r = const Range(0, 1)}) {
    return transform(max(0, min(1, (t - r.start) / (r.end - r.start))));
  }
}

extension RectTransformUtil on Rect {
  Rect transform(RectTransform rectTransform) {
    return Rect.fromCenter(
      center: center + rectTransform.translate,
      width: width * rectTransform.scale,
      height: height * rectTransform.scale,
    );
  }
}

class RectTransform {
  Offset translate;
  double scale;

  RectTransform(this.translate, this.scale);

  Matrix4 toMatrix4() {
    return Matrix4.identity()
      ..translate(translate.dx, translate.dy)
      ..scale(scale);
  }
}
