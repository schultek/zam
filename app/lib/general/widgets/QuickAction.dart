part of widgets;

class QuickAction extends ModuleWidget {
  final IconData icon;
  final String text;
  QuickAction({this.icon, this.text}) : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return ModuleWidgetBuilder<QuickAction>(
      key: key,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              child: Icon(icon),
            ),
            Text(text, style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
      placeholderBuilder: (context) => buildPlaceholder(context),
    );
  }

  @override
  Widget buildPlaceholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10),
            child: Icon(Icons.circle, color: Colors.grey.shade300),
          ),
          Container(
            width: 40,
            height: 16,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
