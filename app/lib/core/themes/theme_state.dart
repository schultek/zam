part of themes;

abstract class ThemeState with ChangeNotifier {
  Color get currentFillColor;

  Color get baseColor;

  ThemeState computeFillColor(
      {required BuildContext context, ColorPreference? preference, bool matchTextColor = false});

  Color computeTextColor({ColorPreference? preference});

  Widget getBackgroundWidget(BuildContext context, Widget child) => child;

  Widget getContainerWidget(BuildContext context, Widget child, {required bool filled}) => child;

  ThemeState copy();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeState && runtimeType == other.runtimeType && currentFillColor == other.currentFillColor;

  @override
  int get hashCode => currentFillColor.hashCode;
}
