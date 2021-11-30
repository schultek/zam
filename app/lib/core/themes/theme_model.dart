import 'package:dart_mappable/dart_mappable.dart';

@MappableClass()
class ThemeModel {
  final int schemeIndex;
  final bool dark;

  const ThemeModel({this.schemeIndex = 0, this.dark = false});
}
