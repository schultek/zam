library themes;

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'colorful_theme.dart';
part 'material_theme.dart';
part 'theme_state.dart';

@MappableClass()
class ThemeModel {
  final int schemeIndex;
  final bool dark;

  const ThemeModel({this.schemeIndex = 0, this.dark = false});
}

class TripTheme extends InheritedWidget {
  final bool reuseTheme;
  final ThemeState theme;

  TripTheme({Key? key, required Widget child, required this.theme, this.reuseTheme = false})
      : super(key: key, child: Theme(data: theme.themeData, child: child));

  static TripTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TripTheme>();
  }

  @override
  bool updateShouldNotify(TripTheme oldWidget) {
    var notify = oldWidget.theme != theme;
    return notify;
  }
}

class ThemedSurface extends StatefulWidget {
  final ColorPreference? preference;
  final bool opaque;
  final Widget Function(BuildContext context, Color fillColor) builder;
  final ValueNotifier<ThemeState?>? themeNotifier;

  const ThemedSurface({required this.builder, this.preference, this.opaque = true, this.themeNotifier, Key? key})
      : super(key: key);

  @override
  _ThemedSurfaceState createState() => _ThemedSurfaceState();
}

class _ThemedSurfaceState extends State<ThemedSurface> {
  late ThemeState theme;

  @override
  void didChangeDependencies() {
    var inheritedTheme = TripTheme.of(context)!;
    if (inheritedTheme.reuseTheme) {
      theme = inheritedTheme.theme.copy();
    } else {
      theme = inheritedTheme.theme.computeFillColor(context: context, preference: widget.preference);
      theme.addListener(() => setState(() {
            widget.themeNotifier?.value = theme.copy();
          }));
    }
    widget.themeNotifier?.value = theme.copy();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    theme.dispose();
    super.dispose();
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

extension ThemeColorsContext on BuildContext {
  Color getFillColor() {
    return TripTheme.of(this)!.theme.currentFillColor;
  }

  Color getTextColor([ColorPreference? preference]) {
    var inheritedTheme = TripTheme.of(this)!;
    return inheritedTheme.theme.computeTextColor(preference: preference);
  }

  ThemeData get theme {
    return Theme.of(this);
  }
}

class ColorPreference {
  ColorPreference();
}
