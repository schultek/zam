library themes;

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

part 'colorful_theme.dart';
part 'dark_theme.dart';
part 'image_theme.dart';
part 'theme_state.dart';

class InheritedThemeState extends InheritedWidget {
  final bool reuseTheme;
  final ThemeState theme;

  const InheritedThemeState({Key? key, required Widget child, required this.theme, this.reuseTheme = false})
      : super(key: key, child: child);

  static InheritedThemeState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedThemeState>();
  }

  @override
  bool updateShouldNotify(InheritedThemeState oldWidget) {
    var notify = oldWidget.theme != theme;
    return notify;
  }

  ThemeState computeFillColor(BuildContext context, {ColorPreference? preference}) {
    return theme.computeFillColor(
      context: context,
      preference: preference,
    );
  }
}

class TripTheme extends StatelessWidget {
  final ThemeState theme;
  final Widget child;

  const TripTheme({required this.theme, required this.child, Key? key}) : super(key: key);

  factory TripTheme.of(BuildContext context, {required Widget child}) {
    return TripTheme(
      theme: InheritedThemeState.of(context)!.theme,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InheritedThemeState(
      theme: theme,
      child: Theme(
        data: theme.themeData.copyWith(
          scaffoldBackgroundColor: theme.currentFillColor,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: theme.computeTextColor()),
            hintStyle: TextStyle(color: theme.computeTextColor().withOpacity(0.3)),
            fillColor: theme.computeTextColor(),
            focusColor: theme.computeTextColor(),
            hoverColor: theme.computeTextColor(),
          ),
          checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(theme.currentFillColor),
            fillColor: MaterialStateProperty.all(theme.computeTextColor()),
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: theme.computeTextColor(),
          ),
          child: child,
        ),
      ),
    );
  }
}

class FillColor extends StatefulWidget {
  final ColorPreference? preference;
  final bool filled;
  final bool matchTextColor;
  final Widget Function(BuildContext context, Color fillColor) builder;
  final ValueNotifier<ThemeState?>? themeNotifier;

  const FillColor(
      {required this.builder,
      this.preference,
      this.filled = true,
      this.matchTextColor = false,
      this.themeNotifier,
      Key? key})
      : super(key: key);

  @override
  _FillColorState createState() => _FillColorState();
}

class _FillColorState extends State<FillColor> {
  late ThemeState theme;

  @override
  void didChangeDependencies() {
    var inheritedTheme = InheritedThemeState.of(context)!;
    if (inheritedTheme.reuseTheme) {
      theme = inheritedTheme.theme.copy();
    } else {
      theme = inheritedTheme.theme
          .computeFillColor(context: context, preference: widget.preference, matchTextColor: widget.matchTextColor);
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
    return InheritedThemeState(
      theme: theme.copy(),
      reuseTheme: !widget.filled,
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

class ThemedContainer extends StatefulWidget {
  final bool filled;
  final Widget child;
  final ValueNotifier<ThemeState?>? themeNotifier;

  const ThemedContainer({this.filled = false, required this.child, Key? key, this.themeNotifier}) : super(key: key);

  @override
  _ThemedContainerState createState() => _ThemedContainerState();
}

class _ThemedContainerState extends State<ThemedContainer> {
  @override
  Widget build(BuildContext context) {
    var theme = InheritedThemeState.of(context)!.theme;
    return FillColor(
      themeNotifier: widget.themeNotifier,
      filled: widget.filled,
      builder: (context, fillColor) => theme.getContainerWidget(
        context,
        widget.child,
        filled: widget.filled,
      ),
    );
  }
}

class ThemedBackground extends StatefulWidget {
  final Widget child;
  const ThemedBackground({required this.child, Key? key}) : super(key: key);

  @override
  _ThemedBackgroundState createState() => _ThemedBackgroundState();
}

class _ThemedBackgroundState extends State<ThemedBackground> {
  @override
  Widget build(BuildContext context) {
    return InheritedThemeState.of(context)!.theme.getBackgroundWidget(context, widget.child);
  }
}

extension ThemeColorsContext on BuildContext {
  Color getFillColor() {
    return InheritedThemeState.of(this)!.theme.currentFillColor;
  }

  Color getTextColor([ColorPreference? preference]) {
    var inheritedTheme = InheritedThemeState.of(this)!;
    return inheritedTheme.theme.computeTextColor(preference: preference);
  }
}

enum Brightness { veryDark, dark, mediumDart, medium, mediumLight, light, veryLight }

enum Contrast { veryLow, low, mediumLow, medium, mediumHigh, high, veryHigh }

enum Denotation { primary, secondary, success, info, error }

class ColorPreference {
  final Brightness? brightness;
  final Contrast? contrast;
  final Denotation? denotation;

  final String? id;

  ColorPreference({this.brightness, this.contrast, this.denotation, this.id})
      : assert(brightness == null || contrast == null);
}
