import 'package:flutter/material.dart';

import '../material_theme.dart';

class TripTheme extends InheritedWidget {
  final bool reuseTheme;
  final MaterialTheme theme;

  TripTheme({Key? key, required Widget child, required this.theme, this.reuseTheme = false})
      : super(key: key, child: Theme(data: theme.themeData, child: child));

  static TripTheme? of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<TripTheme>();
    } else {
      var element = context.getElementForInheritedWidgetOfExactType<TripTheme>();
      return element?.widget as TripTheme?;
    }
  }

  @override
  bool updateShouldNotify(TripTheme oldWidget) {
    var notify = oldWidget.theme != theme;
    return notify;
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
