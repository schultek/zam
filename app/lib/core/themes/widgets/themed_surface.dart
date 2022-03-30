// ignore: must_be_immutable
import 'package:flutter/material.dart';

import '../group_theme_data.dart';
import 'group_theme.dart';

// ignore: must_be_immutable
class ThemeKey extends Key {
  ThemeKey() : super.empty();

  GroupThemeData? _theme;
  GroupThemeData? get theme => _theme;
}

class ThemedSurface extends StatefulWidget {
  final ColorPreference? preference;
  final Widget Function(BuildContext context, Color fillColor) builder;

  @override
  // ignore: overridden_fields
  final ThemeKey? key;

  const ThemedSurface({required this.builder, this.preference, this.key}) : super(key: key);

  @override
  _ThemedSurfaceState createState() => _ThemedSurfaceState();
}

class _ThemedSurfaceState extends State<ThemedSurface> {
  late GroupThemeData theme;

  @override
  void didChangeDependencies() {
    var inheritedTheme = GroupTheme.of(context)!;
    theme = inheritedTheme.theme.computeSurfaceTheme(context: context, preference: widget.preference);
    widget.key?._theme = theme.copy();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GroupTheme(
      theme: theme.copy(),
      child: DefaultTextStyle(
        style: TextStyle(color: theme.onSurfaceColor),
        child: Builder(
          builder: (context) => widget.builder(context, theme.surfaceColor),
        ),
      ),
    );
  }
}
