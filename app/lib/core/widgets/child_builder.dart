import 'package:flutter/cupertino.dart';

class ChildBuilder extends StatelessWidget {
  const ChildBuilder({required this.child, required this.builder, Key? key}) : super(key: key);

  final Widget child;
  final Widget Function(BuildContext context, Widget child) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
