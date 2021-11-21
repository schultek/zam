import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../modules/modules.dart';
import '../../widgets/nested_will_pop_scope.dart';

class TemplateNavigator extends StatefulWidget {
  final Widget home;
  const TemplateNavigator({required this.home, Key? key}) : super(key: key);

  @override
  _TemplateNavigatorState createState() => _TemplateNavigatorState();
}

class _TemplateNavigatorState extends State<TemplateNavigator> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      registry.preloadModules(_navigatorKey.currentContext!);
    });
  }

  @override
  void dispose() {
    registry.disposeModules();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedWillPopScope(
      onWillPop: () async => !(await _navigatorKey.currentState?.maybePop() ?? true),
      child: Navigator(
        key: _navigatorKey,
        onGenerateInitialRoutes: (_, __) => [
          MaterialPageRoute(builder: (context) => widget.home),
          ...registry.generateInitialRoutes(context),
        ],
      ),
    );
  }
}
