import 'package:flutter/material.dart';

import 'trip_theme_data.dart';
import 'widgets/trip_theme.dart';

extension ThemeColorsContext on BuildContext {
  Color get surfaceColor {
    return tripTheme.surfaceColor;
  }

  Color get onSurfaceColor {
    return tripTheme.onSurfaceColor;
  }

  Color onSurfaceColorWith(ColorPreference preference) {
    return tripTheme.onSurfaceColorWith(preference);
  }

  Color get onSurfaceHighlightColor {
    return onSurfaceColorWith(const ColorPreference(useHighlightColor: true));
  }

  TripThemeData get tripTheme {
    return TripTheme.of(this, listen: false)!.theme;
  }

  ThemeData get theme {
    return Theme.of(this);
  }
}
