//
// class ColorfulTheme extends ThemeState {
//   static const base = Colors.white;
//   static final colors = <Color>[
//     Colors.red,
//     Colors.blue,
//     Colors.green,
//     Colors.yellow,
//     Colors.purple,
//     Colors.pink,
//     Colors.orange,
//   ];
//
//   final List<Color> belowColors;
//   ColorfulTheme([List<Color>? colors])
//       : belowColors = colors ?? [base],
//         assert(colors?.isNotEmpty ?? true);
//
//   @override
//   Color get baseColor => base;
//
//   @override
//   Color get currentFillColor => belowColors.last;
//
//   @override
//   ColorfulTheme computeFillColor(
//       {required BuildContext context, ColorPreference? preference, bool matchTextColor = false}) {
//     if (belowColors.last == base) {
//       if (belowColors.length >= 2) {
//         var secToLast = belowColors[belowColors.length - 2];
//
//         var secToLastIndex = colors.indexOf(secToLast);
//         return ColorfulTheme([...belowColors, colors[(secToLastIndex + 1) % colors.length]]);
//       } else {
//         if (preference != null && preference.id != null) {
//           var colorIndex = preference.id.hashCode % colors.length;
//
//           return ColorfulTheme([...belowColors, colors[colorIndex]]);
//         } else {
//           return ColorfulTheme([...belowColors, colors[0]]);
//         }
//       }
//     } else {
//       return ColorfulTheme([...belowColors, base]);
//     }
//   }
//
//   @override
//   Color computeTextColor({ColorPreference? preference}) {
//     if (belowColors.last == base) {
//       return Colors.black;
//     } else {
//       return base;
//     }
//   }
//
//   @override
//   ColorfulTheme copy() => ColorfulTheme([...belowColors]);
// }
