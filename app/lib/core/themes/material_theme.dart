part of themes;

class MaterialTheme extends ThemeState {
  @override
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

  MaterialTheme(this.scheme, [this.dark = false, this.elevation = -1]);

  @override
  MaterialTheme computeFillColor({required BuildContext context, ColorPreference? preference}) {
    return MaterialTheme(scheme, dark, elevation + 1);
  }

  @override
  Color computeTextColor({ColorPreference? preference}) {
    return themeData.colorScheme.onSurface;
  }

  @override
  Color get currentFillColor {
    if (elevation == -1) {
      return themeData.backgroundColor;
    } else if (elevation == 0) {
      return themeData.cardColor;
    } else {
      return Color.alphaBlend(themeData.colorScheme.primary.withAlpha(elevation * 8), themeData.cardColor);
    }
  }

  @override
  MaterialTheme copy() => MaterialTheme(scheme, dark, elevation);
}
