import 'package:flutter/material.dart';

class CustomPageController {
  CustomPageController({this.initialPage});

  final int? initialPage;

  _CustomPageViewState? _state;

  int get page {
    if (_state?.controller.hasClients ?? false) {
      return _state?.controller.page?.round() ?? initialPage ?? 0;
    } else {
      return initialPage ?? 0;
    }
  }

  void animateToPage(int page,
      {Duration duration = const Duration(milliseconds: 300), Curve curve = Curves.easeInOut}) {
    _state?.controller.animateToPage(page, duration: duration, curve: curve);
  }

  void animateToPageDelta(int pageDelta) {
    animateToPage(page + pageDelta);
  }
}

class CustomPageView extends StatefulWidget {
  const CustomPageView({this.controller, required this.children, this.onPageChanged, Key? key}) : super(key: key);

  final CustomPageController? controller;
  final void Function(int)? onPageChanged;
  final List<Widget> children;

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
    controller = PageController(initialPage: widget.controller?.initialPage ?? 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomPageView oldWidget) {
    widget.controller?._state = this;

    var oldIndex = controller.page?.round() ?? 0;
    var oldKey = oldWidget.children[oldIndex].key;

    if (oldKey != null) {
      var newIndex = widget.children.indexWhere((c) => c.key == oldKey);
      if (newIndex != -1 && newIndex != oldIndex) {
        controller.jumpToPage(newIndex);
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const BouncingScrollPhysics(),
      controller: controller,
      onPageChanged: widget.onPageChanged,
      children: widget.children,
    );
  }
}
