import 'package:flutter/material.dart';

class NestedWillPopScope extends StatefulWidget {
  const NestedWillPopScope({
    Key? key,
    required this.child,
    required this.onWillPop,
  }) : super(key: key);

  final Widget child;
  final WillPopCallback onWillPop;

  @override
  _NestedWillPopScopeState createState() => _NestedWillPopScopeState();

  static _NestedWillPopScopeState? of(BuildContext context) {
    return context.findAncestorStateOfType<_NestedWillPopScopeState>();
  }
}

class _NestedWillPopScopeState extends State<NestedWillPopScope> with WidgetsBindingObserver {
  ModalRoute<dynamic>? _route;
  bool isRoot = false;

  _NestedWillPopScopeState? _descendant;
  void setDescendant(_NestedWillPopScopeState state) {
    _descendant = state;
    updateRouteCallback();
  }

  Future<bool> onWillPop() async {
    bool? willPop;
    if (_descendant != null) {
      willPop = await _descendant!.onWillPop();
    }
    if (willPop == null || willPop) {
      willPop = await widget.onWillPop();
    }
    return willPop;
  }

  @override
  Future<bool> didPopRoute() async {
    return isRoot && !(await onWillPop());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  void updateRouteCallback() {
    _route?.removeScopedWillPopCallback(onWillPop);
    _route = ModalRoute.of(context);
    _route?.addScopedWillPopCallback(onWillPop);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var parentGuard = NestedWillPopScope.of(context);
    isRoot = parentGuard == null;
    if (parentGuard != null) {
      parentGuard.setDescendant(this);
    }
    updateRouteCallback();
  }

  @override
  void dispose() {
    _route?.removeScopedWillPopCallback(onWillPop);
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
