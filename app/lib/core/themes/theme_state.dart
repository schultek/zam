part of themes;

abstract class ThemeState with ChangeNotifier {
  Color get currentFillColor;

  ThemeData get themeData;

  ThemeState computeFillColor({required BuildContext context, ColorPreference? preference});

  Color computeTextColor({ColorPreference? preference});

  ThemeState copy();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeState && runtimeType == other.runtimeType && currentFillColor == other.currentFillColor;

  @override
  int get hashCode => currentFillColor.hashCode;
}
