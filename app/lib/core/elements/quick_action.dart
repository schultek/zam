part of elements;

@ModuleWidgetReflectable()
class QuickAction extends ModuleElement with ModuleElementBuilder<QuickAction> {
  final IconData icon;
  final String text;
  QuickAction({required this.icon, required this.text}) : super(key: UniqueKey());

  @override
  Widget buildElement(BuildContext context) {
    return buildAction(context, 0);
  }

  @override
  Widget buildPlaceholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.3),
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 10),
            child: const Icon(Icons.circle, color: Colors.transparent),
          ),
          Container(
            width: 40,
            height: 16,
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  @override
  Widget decorationBuilder(Widget child, double opacity) {
    return Builder(builder: (context) => buildAction(context, opacity));
  }

  Widget buildAction(BuildContext context, double decorationOpacity) {
    var textColor = context.getTextColor();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FillColor(
            preference: ColorPreference(id: id),
            builder: (context, fillColor) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fillColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: textColor.withOpacity(decorationOpacity * 0.5),
                  )
                ],
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              child: Icon(
                icon,
                color: context.getTextColor(),
              ),
            ),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1!.apply(
              color: textColor,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: textColor.withOpacity(decorationOpacity * 0.5),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
