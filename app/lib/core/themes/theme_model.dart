import 'package:dart_mappable/dart_mappable.dart';

@MappableClass()
class ThemeModel {
  final int schemeIndex;
  final bool dark;

  const ThemeModel({required this.schemeIndex, this.dark = false});
}
