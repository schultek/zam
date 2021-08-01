import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TemplateNavigator extends StatefulWidget {
  final Widget home;
  const TemplateNavigator({required this.home, Key? key}) : super(key: key);

  @override
  _TemplateNavigatorState createState() => _TemplateNavigatorState();
}

class _TemplateNavigatorState extends State<TemplateNavigator> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !(await _navigatorKey.currentState?.maybePop() ?? true),
      child: Navigator(
        key: _navigatorKey,
        onGenerateInitialRoutes: (_, __) => [
          MaterialPageRoute(builder: (context) => widget.home),
        ],
      ),
    );
  }
}
