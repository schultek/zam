import 'package:flutter/material.dart';

import '../../core.dart';
import 'config_sheet.dart';

enum TabShape {
  corner,
  middle,
  invCorner,
}

class ConfigTabsPainter extends StatelessWidget {
  const ConfigTabsPainter(
      {required this.activeTab, required this.child, this.area, required this.onTabChanged, Key? key})
      : super(key: key);

  final ConfigTab activeTab;
  final Widget child;
  final AreaState? area;
  final ValueChanged<ConfigTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    var d = MediaQuery.of(context).size.width / 3;
    var r = WidgetSelector.dragHandleHeight / 2;

    return Stack(
      children: [
        if (activeTab != ConfigTab.settings)
          _inactiveTab(
            context,
            left: 0,
            width: d + r,
            leftShape: TabShape.corner,
            rightShape: activeTab == ConfigTab.layout ? TabShape.middle : TabShape.invCorner,
            label: 'SETTINGS',
            color: context.surfaceColor,
            textColor: context.onSurfaceColor,
            onPressed: () {
              onTabChanged(ConfigTab.settings);
            },
          ),
        if (activeTab != ConfigTab.layout)
          _inactiveTab(
            context,
            left: d + (activeTab == ConfigTab.settings ? -r : 0),
            width: d + r,
            leftShape: activeTab == ConfigTab.settings ? TabShape.middle : TabShape.corner,
            rightShape: activeTab == ConfigTab.settings ? TabShape.corner : TabShape.middle,
            label: 'LAYOUT',
            color: context.surfaceColor,
            textColor: context.onSurfaceColor,
            onPressed: () {
              onTabChanged(ConfigTab.layout);
            },
          ),
        if (activeTab != ConfigTab.widgets)
          _inactiveTab(
            context,
            left: d * 2 + -r,
            width: d + r,
            leftShape: activeTab == ConfigTab.settings ? TabShape.invCorner : TabShape.middle,
            rightShape: TabShape.corner,
            label: 'WIDGETS',
            color: area?.context.surfaceColor ??
                Color.alphaBlend(context.onSurfaceColor.withOpacity(0.04), context.surfaceColor),
            textColor: area?.context.onSurfaceColor.withOpacity(0.5) ??
                Color.alphaBlend(context.onSurfaceColor.withOpacity(0.08), context.surfaceColor),
            onPressed: () {
              onTabChanged(ConfigTab.widgets);
            },
          ),
        ClipPath(
          clipper: ActiveTabClipper(tab: activeTab),
          child: Material(
            color: activeTab == ConfigTab.widgets ? area!.context.surfaceColor : context.surfaceColor,
            child: Stack(
              children: [
                child,
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: WidgetSelector.dragHandleHeight,
                    child: IgnorePointer(
                      child: Container(
                        color: activeTab == ConfigTab.widgets ? area!.context.surfaceColor : context.surfaceColor,
                      ),
                    )),
              ],
            ),
          ),
        ),
        Positioned(
          left: activeTab == ConfigTab.settings
              ? 0
              : activeTab == ConfigTab.layout
                  ? d
                  : d * 2,
          width: d,
          top: 0,
          height: WidgetSelector.dragHandleHeight,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: (activeTab == ConfigTab.widgets ? area!.context.onSurfaceColor : context.onSurfaceColor)
                    .withOpacity(0.8),
              ),
              height: 4,
              width: 80,
            ),
          ),
        ),
      ],
    );
  }

  Widget _inactiveTab(
    BuildContext context, {
    required double left,
    required double width,
    required TabShape leftShape,
    required TabShape rightShape,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    var r = WidgetSelector.dragHandleHeight / 2;

    return Positioned(
      left: left,
      width: width,
      top: 0,
      height: WidgetSelector.dragHandleHeight,
      child: CustomPaint(
        painter: InactiveTabPainter(
          leftShape: leftShape,
          rightShape: rightShape,
          color: color,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: leftShape == TabShape.corner ? 0 : r,
            right: rightShape == TabShape.corner ? 0 : r,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed,
            child: Center(
              child: Text(
                label,
                style: context.theme.textTheme.caption!.copyWith(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InactiveTabPainter extends CustomPainter {
  InactiveTabPainter({required this.leftShape, required this.rightShape, required this.color});

  final TabShape leftShape;
  final TabShape rightShape;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var w = size.width, h = size.height;
    var r = h / 2;
    var rr = Radius.circular(r);

    var clipPath = Path();
    var shadowPath = Path();

    if (leftShape == TabShape.corner) {
      clipPath.moveTo(0, h);
      clipPath.lineTo(0, r);
      clipPath.arcToPoint(Offset(r, 0), radius: rr);

      shadowPath.moveTo(0, h * 2);
      shadowPath.lineTo(0, h);
    } else if (leftShape == TabShape.middle) {
      clipPath.moveTo(r * 2, h);
      clipPath.arcToPoint(Offset(r, r), radius: rr);
      clipPath.arcToPoint(Offset.zero, radius: rr, clockwise: false);

      shadowPath.moveTo(-w * 2, h * 2);
      shadowPath.lineTo(-w * 2, 0);
      shadowPath.lineTo(0, 0);
      shadowPath.arcToPoint(Offset(r, r), radius: rr);
      shadowPath.arcToPoint(Offset(r * 2, h), radius: rr, clockwise: false);
    } else {
      clipPath.moveTo(r, h);
      clipPath.lineTo(r, r);
      clipPath.arcToPoint(Offset.zero, radius: rr, clockwise: false);

      shadowPath.moveTo(-w * 2, h * 2);
      shadowPath.lineTo(-w * 2, 0);
      shadowPath.lineTo(0, 0);
      shadowPath.arcToPoint(Offset(r, r), radius: rr);
      shadowPath.lineTo(r, h);
    }

    if (rightShape == TabShape.corner) {
      clipPath.lineTo(w - r, 0);
      clipPath.arcToPoint(Offset(w, r), radius: rr);
      clipPath.lineTo(w, h);

      shadowPath.lineTo(w, h);
      shadowPath.lineTo(w, h * 2);
    } else if (rightShape == TabShape.middle) {
      clipPath.lineTo(w, 0);
      clipPath.arcToPoint(Offset(w - r, r), radius: rr, clockwise: false);
      clipPath.arcToPoint(Offset(w - r * 2, h), radius: rr);

      shadowPath.lineTo(w - r * 2, h);
      shadowPath.arcToPoint(Offset(w - r, r), radius: rr, clockwise: false);
      shadowPath.arcToPoint(Offset(w, 0), radius: rr);
      shadowPath.lineTo(w * 3, 0);
      shadowPath.lineTo(w * 3, h * 2);
    } else {
      clipPath.lineTo(w, 0);
      clipPath.arcToPoint(Offset(w - r, r), radius: rr, clockwise: false);
      clipPath.lineTo(w - r, h);

      shadowPath.lineTo(w - r, h);
      shadowPath.lineTo(w - r, r);
      shadowPath.arcToPoint(Offset(w, 0), radius: rr);
      shadowPath.lineTo(w * 3, 0);
      shadowPath.lineTo(w * 3, h * 2);
    }

    clipPath.close();
    canvas.clipPath(clipPath);

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = color);

    shadowPath.close();
    canvas.drawShadow(shadowPath.shift(const Offset(0, -3)), Colors.black87, 3, true);
  }

  @override
  bool shouldRepaint(covariant InactiveTabPainter oldDelegate) {
    return oldDelegate.leftShape != leftShape || oldDelegate.rightShape != rightShape || oldDelegate.color != color;
  }
}

class ActiveTabClipper extends CustomClipper<Path> {
  ActiveTabClipper({required this.tab});

  final ConfigTab tab;

  @override
  Path getClip(Size size) {
    var w = size.width, h = size.height;
    var d = w / 3;
    var r = WidgetSelector.dragHandleHeight / 2;
    var rr = Radius.circular(r);

    var path = Path();
    path.moveTo(0, h);
    path.lineTo(0, r * 2);

    if (tab == ConfigTab.settings) {
      path.lineTo(0, r);
      path.arcToPoint(Offset(r, 0), radius: rr);
      path.lineTo(d - r, 0);
      path.arcToPoint(Offset(d, r), radius: rr);
      path.arcToPoint(Offset(d + r, r * 2), radius: rr, clockwise: false);
    } else if (tab == ConfigTab.layout) {
      path.lineTo(d - r, r * 2);
      path.arcToPoint(Offset(d, r), radius: rr, clockwise: false);
      path.arcToPoint(Offset(d + r, 0), radius: rr);
      path.lineTo(d * 2 - r, 0);
      path.arcToPoint(Offset(d * 2, r), radius: rr);
      path.arcToPoint(Offset(d * 2 + r, r * 2), radius: rr, clockwise: false);
    } else {
      path.lineTo(d * 2 - r, r * 2);
      path.arcToPoint(Offset(d * 2, r), radius: rr, clockwise: false);
      path.arcToPoint(Offset(d * 2 + r, 0), radius: rr);
      path.lineTo(w - r, 0);
      path.arcToPoint(Offset(w, r), radius: rr);
    }

    path.lineTo(w, r * 2);
    path.lineTo(w, h);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant ActiveTabClipper oldClipper) {
    return oldClipper.tab != tab;
  }
}
