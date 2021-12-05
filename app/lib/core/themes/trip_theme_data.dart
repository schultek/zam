import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'theme_model.dart';

class ColorPreference {
  final bool useHighlightColor;

  const ColorPreference({this.useHighlightColor = false});
}

enum HighlightColor { primary, secondary, none }

class TripThemeData {
  late final themeData = dark
      ? FlexThemeData.dark(
          scheme: scheme,
          surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
          blendLevel: 24,
        )
      : FlexThemeData.light(
          scheme: scheme,
          surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
          blendLevel: 24,
        );

  final FlexScheme scheme;
  final bool dark;
  final int elevation;
  final HighlightColor useHighlightColor;

  factory TripThemeData.fromModel(ThemeModel model) {
    return TripThemeData(FlexScheme.values[model.schemeIndex], model.dark);
  }

  TripThemeData(this.scheme, [this.dark = false, this.elevation = -1, this.useHighlightColor = HighlightColor.none]);

  TripThemeData computeSurfaceTheme({required BuildContext context, ColorPreference? preference}) {
    if (preference?.useHighlightColor ?? false) {
      if (useHighlightColor == HighlightColor.primary) {
        return TripThemeData(scheme, dark, 0, HighlightColor.secondary);
      } else {
        return TripThemeData(scheme, dark, 0, HighlightColor.primary);
      }
    }

    if (useHighlightColor != HighlightColor.none) {
      return TripThemeData(scheme, dark, 0, HighlightColor.none);
    }

    if (elevation == -1) {
      return TripThemeData(scheme, dark, 1);
    }

    return TripThemeData(scheme, dark, elevation + 1);
  }

  Color get onSurfaceColor {
    switch (useHighlightColor) {
      case HighlightColor.primary:
        return themeData.colorScheme.onPrimary;
      case HighlightColor.secondary:
        return themeData.colorScheme.onSecondary;
      case HighlightColor.none:
        if (elevation <= 0) {
          return themeData.colorScheme.onBackground;
        } else {
          return themeData.colorScheme.onSurface;
        }
    }
  }

  Color onSurfaceColorWith(ColorPreference preference) {
    if (preference.useHighlightColor) {
      switch (useHighlightColor) {
        case HighlightColor.primary:
          return themeData.colorScheme.onPrimary;
        case HighlightColor.secondary:
          return themeData.colorScheme.onSecondary;
        case HighlightColor.none:
          return themeData.colorScheme.primary;
      }
    }
    return onSurfaceColor;
  }

  Color get surfaceColor {
    switch (useHighlightColor) {
      case HighlightColor.primary:
        return themeData.colorScheme.primary;
      case HighlightColor.secondary:
        return themeData.colorScheme.secondary;
      case HighlightColor.none:
        if (elevation == -1) {
          return themeData.scaffoldBackgroundColor;
        } else if (elevation == 0) {
          return themeData.backgroundColor;
        } else {
          return Color.alphaBlend(themeData.colorScheme.primary.withAlpha((elevation - 1) * 8), themeData.cardColor);
        }
    }
  }

  TripThemeData copy() => TripThemeData(scheme, dark, elevation, useHighlightColor);
}
