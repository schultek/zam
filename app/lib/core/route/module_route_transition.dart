part of route;

class _InheritedModuleRouteTransition extends InheritedWidget {
  final _ModuleRouteTransitionState state;
  const _InheritedModuleRouteTransition({Key? key, required this.state, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedModuleRouteTransition old) => true;
}

class ModuleRouteTransition<T extends ModuleElement> extends StatefulWidget {
  final Widget child;
  final T element;
  const ModuleRouteTransition({required this.child, required this.element, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModuleRouteTransitionState<T>();

  static _ModuleRouteTransitionState? of(BuildContext context) {
    try {
      return context.dependOnInheritedWidgetOfExactType<_InheritedModuleRouteTransition>()?.state;
    } catch (_) {
      return null;
    }
  }
}

class _ModuleRouteTransitionState<T extends ModuleElement> extends State<ModuleRouteTransition<T>>
    with SingleTickerProviderStateMixin {
  Rect? fullRect;
  final containerKey = GlobalKey();

  Rect get moduleRect => containerKey.globalPaintBounds;

  bool isHidden = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedModuleRouteTransition(
      state: this,
      child: Container(
        key: containerKey,
        child: Opacity(
          opacity: isHidden ? 0 : 1,
          child: widget.child,
        ),
      ),
    );
  }

  AreaState<Area<T>, T> get widgetArea => Area.of<T>(context)!;

  ModuleTransition onAnimate(BuildContext context, double value) {
    fullRect ??= Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    var dxCurve = Curves.easeInOutQuad;
    var dyCurve = Curves.easeInCubic;
    var dRange = const Range(0, 0.8);
    var scaleCurve = Curves.easeIn;

    var dx = fullRect!.center.dx - moduleRect.center.dx;
    var dy = fullRect!.center.dy - moduleRect.center.dy;

    var transform = RectTransform(
      Offset(dx * dxCurve.transformRange(value, r: dRange), dy * dyCurve.transformRange(value, r: dRange)),
      1 + scaleCurve.transform(value) * 0.2,
    );

    isHidden = value > 0;

    var cardRect = moduleRect.transform(transform);

    var pageCurve = Curves.easeInOutCubic;
    var pageRange = const Range(0.2, 1);

    var pageRect = Rect.lerp(cardRect, fullRect, pageCurve.transformRange(value, r: pageRange))!;

    Widget card = Container();

    if (mounted && value > 0) {
      card = Positioned.fromRect(
        rect: cardRect,
        child: InheritedArea<T>(
          state: widgetArea,
          child: TripTheme(
            theme: widgetArea.theme,
            child: widgetArea.elementDecorator.decorateDragged(
              this.context,
              widget.element,
              widget.child,
              value,
            ),
          ),
        ),
      );
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (mounted) setState(() {});
    });

    return ModuleTransition(pageRect, card, value);
  }
}

class ModuleTransition {
  Rect page;
  Widget card;

  late double clipRadius;
  late double pageOpacity;

  ModuleTransition(this.page, this.card, double value) {
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
