import 'package:flutter/material.dart';

class FillOverscroll extends StatefulWidget {
  const FillOverscroll({required this.child, required this.fill, Key? key}) : super(key: key);

  final Widget child;
  final Widget fill;

  @override
  State<FillOverscroll> createState() => _FillOverscrollState();
}

class _FillOverscrollState extends State<FillOverscroll> {
  double _overscrollSize = 0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels < 0) {
          setState(() {
            _overscrollSize = -notification.metrics.pixels;
          });
          return true;
        } else if (_overscrollSize != 0) {
          setState(() {
            _overscrollSize = 0;
          });
        }
        return false;
      },
      child: Stack(children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: _overscrollSize.ceilToDouble() + 1,
          child: widget.fill,
        ),
        widget.child,
      ]),
    );
  }
}
