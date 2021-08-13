part of themes;

class DarkTheme extends ThemeState {
  final List<Color> belowColors;
  DarkTheme([List<Color>? colors])
      : belowColors = colors ?? [d[9]],
        assert(colors?.isNotEmpty ?? true);

  static final d = [
    Colors.grey.shade50,
    Colors.grey.shade100,
    Colors.grey.shade200,
    Colors.grey.shade300,
    Colors.grey.shade400,
    Colors.grey.shade500,
    Colors.grey.shade600,
    Colors.grey.shade700,
    Colors.grey.shade800,
    Colors.grey.shade900,
  ];

  @override
  ThemeData get themeData => ThemeData(
        primaryColor: d[2],
        brightness: ui.Brightness.dark,
      );

  @override
  DarkTheme computeFillColor(
      {required BuildContext context, ColorPreference? preference, bool matchTextColor = false}) {
    if (matchTextColor) {
      return _next(computeTextColor(preference: preference));
    }

    var c = belowColors.last;
    var i = d.indexOf(c);
    var contrast = preference?.contrast ?? Contrast.veryLow;

    int j = i + contrast.index + 1;
    if (j >= d.length) j = i - contrast.index - 1;
    return _next(d[j]);
  }

  DarkTheme _next(Color color) => DarkTheme([...belowColors, color]);

  @override
  Color computeTextColor({ColorPreference? preference}) {
    var c = belowColors.last;
    var i = d.indexOf(c);

    if (i > 5) {
      return d[2];
    } else {
      return d[9];
    }
  }

  @override
  Color get baseColor => d[9];

  @override
  Color get currentFillColor => belowColors.last;

  @override
  DarkTheme copy() => DarkTheme([...belowColors]);
}
