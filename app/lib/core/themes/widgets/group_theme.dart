import 'package:flutter/material.dart';

import '../group_theme_data.dart';

class GroupTheme extends InheritedWidget {
  final GroupThemeData theme;

  GroupTheme({Key? key, required Widget child, required this.theme})
      : super(key: key, child: Theme(data: theme.themeData, child: child));

  static GroupTheme? of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<GroupTheme>();
    } else {
      var element = context.getElementForInheritedWidgetOfExactType<GroupTheme>();
      return element?.widget as GroupTheme?;
    }
  }

  @override
  bool updateShouldNotify(GroupTheme oldWidget) {
    var notify = oldWidget.theme != theme;
    return notify;
  }
}
