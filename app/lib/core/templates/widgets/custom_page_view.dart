import 'package:flutter/material.dart';

class CustomPageController {
  CustomPageController();

  _CustomPageViewState? _state;

  int get page => _state?.page ?? 0;

  void animateToPage(int page,
      {Duration duration = const Duration(milliseconds: 300), Curve curve = Curves.easeInOut}) {
    _state?.controller.animateToPage(page + _state!.anchorIndex, duration: duration, curve: curve);
  }

  void animateToPageDelta(int pageDelta) {
    animateToPage(page + pageDelta);
  }
}

class CustomPageView extends StatefulWidget {
  const CustomPageView({this.controller, required this.children, this.onPageChanged, this.anchor, Key? key})
      : super(key: key);

  final CustomPageController? controller;
  final void Function(int)? onPageChanged;
  final List<Widget> children;
  final Key? anchor;

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  late PageController controller;
  late int anchorIndex;
  int? _cachedPage;

  int get page {
    if (_cachedPage != null) {
      return _cachedPage!;
    }
    if (controller.hasClients && controller.position.hasPixels && controller.position.hasContentDimensions) {
      return controller.page!.round() - anchorIndex;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
    updateAnchorIndex();
    controller = PageController(initialPage: anchorIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomPageView oldWidget) {
    widget.controller?._state = this;

    var oldAnchorIndex = anchorIndex;
    var oldPage = page;
    updateAnchorIndex();
    if (oldAnchorIndex != anchorIndex) {
      controller.jumpToPage(oldPage + anchorIndex);
      _cachedPage = oldPage;
    }

    super.didUpdateWidget(oldWidget);
  }

  updateAnchorIndex() {
    var index = 0;
    for (var i = 0; i < widget.children.length; i++) {
      var child = widget.children[i];
      if (child.key == widget.anchor) {
        index = i;
        break;
      }
    }
    anchorIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const BouncingScrollPhysics(),
      controller: controller,
      onPageChanged: (page) {
        _cachedPage = null;
        widget.onPageChanged?.call(page - anchorIndex);
      },
      children: widget.children,
    );
  }
}
