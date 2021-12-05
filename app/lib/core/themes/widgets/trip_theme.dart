import 'package:flutter/material.dart';

import '../trip_theme_data.dart';

class TripTheme extends InheritedWidget {
  final TripThemeData theme;

  TripTheme({Key? key, required Widget child, required this.theme})
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
