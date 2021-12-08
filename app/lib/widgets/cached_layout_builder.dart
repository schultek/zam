import 'package:flutter/material.dart';

class CachedLayoutBuilder extends StatefulWidget {
  const CachedLayoutBuilder({Key? key, required this.builder}) : super(key: key);

  final LayoutWidgetBuilder builder;

  @override
  _CachedLayoutBuilderState createState() => _CachedLayoutBuilderState();
}

class _CachedLayoutBuilderState extends State<CachedLayoutBuilder> {
  bool acceptsNewConstraints = true;
  BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (acceptsNewConstraints) {
          this.constraints = constraints;
          acceptsNewConstraints = false;
        }
        return widget.builder(context, this.constraints!);
      },
    );
  }
}
