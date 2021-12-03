// ignore: must_be_immutable
import 'package:flutter/material.dart';

import '../material_theme.dart';
import 'trip_theme.dart';

// ignore: must_be_immutable
class ThemeKey extends Key {
  ThemeKey() : super.empty();

  MaterialTheme? _theme;
  MaterialTheme? get theme => _theme;
}

class ThemedSurface extends StatefulWidget {
  final ColorPreference? preference;
  final bool opaque;
  final Widget Function(BuildContext context, Color fillColor) builder;

  @override
  // ignore: overridden_fields
  final ThemeKey? key;

  const ThemedSurface({required this.builder, this.preference, this.opaque = true, this.key}) : super(key: key);

  @override
  _ThemedSurfaceState createState() => _ThemedSurfaceState();
}

class _ThemedSurfaceState extends State<ThemedSurface> {
  late MaterialTheme theme;

  @override
  void didChangeDependencies() {
    var inheritedTheme = TripTheme.of(context)!;
    if (inheritedTheme.reuseTheme) {
      theme = inheritedTheme.theme.copy();
    } else {
      theme = inheritedTheme.theme.computeFillColor(context: context, preference: widget.preference);
    }
    widget.key?._theme = theme.copy();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TripTheme(
      theme: theme.copy(),
      reuseTheme: !widget.opaque,
      child: DefaultTextStyle(
        style: TextStyle(
          color: theme.computeTextColor(),
        ),
        child: Builder(
          builder: (context) => widget.builder(context, theme.currentFillColor),
        ),
      ),
    );
  }
}
