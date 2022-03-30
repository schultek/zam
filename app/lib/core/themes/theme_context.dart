import 'package:flutter/material.dart';

import 'group_theme_data.dart';
import 'widgets/group_theme.dart';

extension ThemeColorsContext on BuildContext {
  Color get surfaceColor {
    return groupTheme.surfaceColor;
  }

  Color get onSurfaceColor {
    return groupTheme.onSurfaceColor;
  }

  Color onSurfaceColorWith(ColorPreference preference) {
    return groupTheme.onSurfaceColorWith(preference);
  }

  Color get onSurfaceHighlightColor {
    return onSurfaceColorWith(const ColorPreference(useHighlightColor: true));
  }

  GroupThemeData get groupTheme {
    return GroupTheme.of(this, listen: true)!.theme;
  }

  ThemeData get theme {
    return Theme.of(this);
  }
}
