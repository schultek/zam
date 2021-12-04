import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'theme_model.dart';

class ColorPreference {
  final bool usePrimaryColor;

  ColorPreference({this.usePrimaryColor = false});
}

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
  final bool usePrimaryColor;

  factory TripThemeData.fromModel(ThemeModel model) {
    return TripThemeData(FlexScheme.values[model.schemeIndex], model.dark);
  }

  TripThemeData(this.scheme, [this.dark = false, this.elevation = 0, this.usePrimaryColor = false]);

  TripThemeData computeSurfaceTheme({required BuildContext context, ColorPreference? preference}) {
    if (preference?.usePrimaryColor ?? false) {
      return TripThemeData(scheme, dark, 0, true);
    }

    if (usePrimaryColor) {
      return TripThemeData(scheme, dark, 0, false);
    }

    return TripThemeData(scheme, dark, elevation + 1);
  }

  Color get onSurfaceColor {
    if (usePrimaryColor) {
      return themeData.colorScheme.onPrimary;
    } else {
      return themeData.colorScheme.onSurface;
    }
  }

  Color get surfaceColor {
    if (usePrimaryColor) {
      return themeData.colorScheme.primary;
    } else if (elevation == 0) {
      return themeData.backgroundColor;
    } else {
      return Color.alphaBlend(themeData.colorScheme.primary.withAlpha((elevation - 1) * 8), themeData.cardColor);
    }
  }

  TripThemeData copy() => TripThemeData(scheme, dark, elevation, usePrimaryColor);
}
