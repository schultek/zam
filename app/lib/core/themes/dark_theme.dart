part of themes;

class DarkTheme extends ThemeState {
  final List<Color> belowColors;
  DarkTheme([List<Color>? colors])
      : belowColors = colors ?? [dark],
        assert(colors?.isNotEmpty ?? true);

  static final dark = Colors.grey.shade900;
  static final dark2 = Colors.grey.shade800;
  static final light = Colors.grey.shade200;

  @override
  DarkTheme computeFillColor({required BuildContext context, ColorPreference? preference}) {
    if (belowColors.last == dark) {
      return DarkTheme([...belowColors, dark2]);
    } else if (belowColors.last == dark2) {
      return DarkTheme([...belowColors, light]);
    } else {
      return DarkTheme([...belowColors, dark]);
    }
  }

  @override
  Color computeTextColor({ColorPreference? preference}) {
    if (belowColors.last == dark || belowColors.last == dark2) {
      return light;
    } else {
      return dark;
    }
  }

  @override
  Color get baseColor => dark;

  @override
  Color get currentFillColor => belowColors.last;

  @override
  DarkTheme copy() => DarkTheme([...belowColors]);
}
