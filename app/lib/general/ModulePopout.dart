part of module;

class ModuleController extends StatefulWidget {

  final Widget child;

  ModuleController({this.child});

  @override
  _ModuleControllerState createState() => _ModuleControllerState();
}

class _ModuleControllerState extends State<ModuleController> {
  List<Widget> popoutWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ModuleCardPopout(
            child: widget.child,
            onPopout: onPopout
          ),
        ),
        ...popoutWidgets
      ],
    );
  }

  void onPopout(List<Widget> widgets) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        popoutWidgets = widgets;
      });
    });
  }

}

class ModuleCardPopout extends InheritedWidget {

  final Widget child;
  final void Function(List<Widget> widgets) onPopout;

  ModuleCardPopout({
    this.child, this.onPopout
  })  : super(child: child);

  static ModuleCardPopout of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ModuleCardPopout>();
  }

  void setPopout(List<Widget> child) {
    this.onPopout(child);
  }

  @override
  bool updateShouldNotify(ModuleCardPopout old) => false;
}