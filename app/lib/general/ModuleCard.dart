part of module;

class ModuleData {
  Trip trip;

  ModuleData({this.trip});
}

class TransformListener<T, U> {
  T value;
  U Function(T value) listener;

  TransformListener(this.value);

  U apply(T value) {
    this.value = value;
    if (this.listener != null) {
      return this.listener(value);
    } else {
      return null;
    }
  }

  void onValue(U Function(T value) listener) {
    this.listener = listener;
    listener(this.value);
  }
}

class ModuleCardLocator extends InheritedWidget {
  final TransformListener<double, ModuleTransition> listener;

  ModuleCardLocator({Widget child, this.listener})
      : super(
          child: AnimatedModuleCard(
            listener: listener,
            child: child,
          ),
        );

  static ModuleCardLocator of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ModuleCardLocator>();
  }

  ModuleTransition animate(double value) {
    return this.listener.apply(value);
  }

  @override
  bool updateShouldNotify(ModuleCardLocator old) => false;
}

class ModuleCard {
  final Widget Function(BuildContext context) builder;

  ModuleCard({this.builder});

  Widget build() {
    return ModuleCardLocator(
      listener: TransformListener(0.0),
      child: Builder(
        builder: (context) => Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.grey[300],
          child: this.builder(context),
        ),
      ),
    );
  }
}

class AnimatedModuleCard extends StatefulWidget {
  final Widget child;
  final TransformListener<double, ModuleTransition> listener;

  AnimatedModuleCard({this.child, this.listener});

  @override
  _AnimatedModuleCardState createState() => _AnimatedModuleCardState();
}

class _AnimatedModuleCardState extends State<AnimatedModuleCard> with SingleTickerProviderStateMixin {
  Rect fullRect;
  final containerKey = GlobalKey();

  bool childVisible = true;

  Rect get moduleRect => this.containerKey.globalPaintBounds;

  RectTransform _moduleTransform;

  @override
  void initState() {
    super.initState();
    _moduleTransform = RectTransform(Offset.zero, 1);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fullRect = Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
      widget.listener.onValue((double value) {
        var dxCurve = Curves.easeIn;
        var dyCurve = Curves.easeOut;
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

        var transition = ModuleTransition(pageRect, value);

        ModuleCardPopout.of(context).onPopout(value > 0
            ? [
                Positioned.fromRect(
                  rect: pageRect,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(transition.cardShadow),
                        )
                      ],
                      borderRadius: BorderRadius.circular(transition.clipRadius),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: cardRect,
                  child: widget.child,
                ),
              ]
            : []);

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted)
            setState(() {
              childVisible = value == 0;
            });
        });

        return transition;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: containerKey,
      child: Stack(
        children: [
          HeroModuleBuilder(child: widget.child),
          childVisible
              ? Container()
              : SizedBox.fromSize(
                  size: moduleRect.size,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade100,
                    ),
                  ),
                ),
          childVisible
              ? Container()
              : Transform(
                  transform: _moduleTransform.toMatrix4(),
                  child: widget.child,
                ),
        ],
      ),
    );
  }
}

class ModuleHero extends StatelessWidget {
  final Object tag;
  final HeroPlaceholderBuilder placeholderBuilder;
  final Widget child;

  const ModuleHero({
    Key key,
    @required this.tag,
    this.placeholderBuilder,
    @required this.child,
  })  : assert(tag != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var transitional = HeroModuleBuilder.of(context);
    if (transitional != null) {
      return Hero(tag: tag, placeholderBuilder: placeholderBuilder, child: child);
    } else {
      return Container();
    }
  }
}

class HeroModuleBuilder extends InheritedWidget {
  const HeroModuleBuilder({
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  static HeroModuleBuilder of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HeroModuleBuilder>();
  }

  @override
  bool updateShouldNotify(HeroModuleBuilder old) => false;
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
