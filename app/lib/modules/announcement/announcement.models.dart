part of announcement_module;

@MappableClass()
class Announcement {
  final String? title;
  final String message;
  final Color? textColor;
  final Color? backgroundColor;
  final bool isDismissible;

  Announcement({this.title, required this.message, this.textColor, this.backgroundColor, this.isDismissible = false});
}

@CustomMapper()
class ColorMapper extends SimpleMapper<Color> {
  @override
  Color decode(dynamic value) {
    return Color(int.parse('ff${value.substring(1)}', radix: 16));
  }

  @override
  dynamic encode(Color self) {
    return "#${(self.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}";
  }
}
