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
