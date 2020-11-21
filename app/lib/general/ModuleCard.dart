part of module;

class ModuleData {
  Trip trip;

  ModuleData({this.trip});
}

class ModuleCard {
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context) onNavigate;

  ModuleCard({this.builder, this.onNavigate});

  Widget build() {
    return ModuleCardTransition(
      child: Builder(
        builder: (context) => GestureDetector(
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.grey[300],
            child: this.builder(context),
          ),
          onTap: () {
            if (this.onNavigate != null) {
              Navigator.of(context).push(ModulePageRoute(context, child: this.onNavigate(context)));
            }
          },
        ),
      ),
    );
  }
}

class ModuleCardTransition extends StatefulWidget {
  final Widget child;

  ModuleCardTransition({this.child});

  @override
  _ModuleCardTransitionState createState() => _ModuleCardTransitionState();
}

class _ModuleCardTransitionState extends State<ModuleCardTransition> with SingleTickerProviderStateMixin {
  Rect fullRect;
  final containerKey = GlobalKey();

  Rect get moduleRect => this.containerKey.globalPaintBounds;

  RectTransform _moduleTransform;

  @override
  void initState() {
    super.initState();
    _moduleTransform = RectTransform(Offset.zero, 1);
  }

  @override
  Widget build(BuildContext context) {
    return ModuleCardLocator(
      onAnimate: onAnimate,
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
    if (fullRect == null) {
      fullRect = Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    }

    var dxCurve = Curves.easeInOutQuad;
    var dyCurve = Curves.easeInCubic;
    var dRange = Range(0, 0.8);
    var scaleCurve = Curves.easeIn;

    var dx = fullRect.center.dx - moduleRect.center.dx;
    var dy = fullRect.center.dy - moduleRect.center.dy;

    _moduleTransform = RectTransform(
      Offset(dx * dxCurve.transformRange(value, r: dRange), dy * dyCurve.transformRange(value, r: dRange)),
      1 + scaleCurve.transform(value) * 0.2,
    );

    var cardRect = moduleRect.transform(_moduleTransform);

    var pageCurve = Curves.easeInOut;
    var pageRange = Range(0.2, 1);

    var pageRect = Rect.lerp(cardRect, fullRect, pageCurve.transformRange(value, r: pageRange));

    var card = value > 0
        ? Positioned.fromRect(
            rect: cardRect,
            child: widget.child,
          )
        : Container();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) setState(() {});
    });

    return ModuleTransition(pageRect, card, value);
  }
}

class ModuleCardLocator extends InheritedWidget {
  final Function(BuildContext context, double d) onAnimate;

  ModuleCardLocator({Widget child, this.onAnimate}) : super(child: child);

  static ModuleCardLocator of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ModuleCardLocator>();
  }

  ModuleTransition animate(BuildContext context, double value) {
    return this.onAnimate(context, value);
  }

  @override
  bool updateShouldNotify(ModuleCardLocator old) => false;
}

class ModuleTransition {

  Rect page;
  Widget card;

  double cardShadow;
  double clipRadius;
  double pageOpacity;


  ModuleTransition(this.page, this.card, double value) {
    this.cardShadow = min(0.2, value);
    this.clipRadius = (1 - Curves.easeIn.transformRange(value, r: Range(0.7, 1))) * 20;
    this.pageOpacity = Curves.easeInOut.transformRange(value, r: Range(0.1, 0.6));
  }
}

class Range {
  final double start;
  final double end;

  const Range(this.start, this.end) : assert(start < end);
}

extension RangedCurve on Curve {
  double transformRange(double t, {Range r = const Range(0, 1)}) {
    return this.transform(max(0, min(1, (t - r.start) / (r.end - r.start))));
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null)?.getTranslation();
    if (translation != null && renderObject.paintBounds != null) {
      return renderObject.paintBounds.shift(Offset(translation.x, translation.y));
    } else {
      return Rect.zero;
    }
  }
}

extension RectTransformUtil on Rect {
  Rect transform(RectTransform rectTransform) {
    return Rect.fromCenter(
      center: this.center + rectTransform.translate,
      width: this.width * rectTransform.scale,
      height: this.height * rectTransform.scale,
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
