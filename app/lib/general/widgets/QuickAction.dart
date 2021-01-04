part of widgets;

class QuickAction extends ModuleWidget {
  final IconData icon;
  final String text;
  QuickAction({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: Icon(icon),
        ),
        Text(text),
      ],
    );
  }

  @override
  Widget buildPlaceholder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
        ),
        Container(
          width: 100,
          height: 20,
          color: Colors.black,
        ),
      ],
    );
  }
}
