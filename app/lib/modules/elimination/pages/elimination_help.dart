import 'package:flutter/material.dart';

import '../../../core/themes/themes.dart';
import '../../thebutton/widgets/clip_layer.dart';

class EliminationHelp extends StatefulWidget {
  const EliminationHelp({required Key key}) : super(key: key);

  @override
  _EliminationHelpState createState() => _EliminationHelpState();
}

class _EliminationHelpState extends State<EliminationHelp> {
  bool helpOpen = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          helpButton(context, constraints),
          helpPage(constraints),
        ],
      ),
    );
  }

  Widget helpButton(BuildContext context, BoxConstraints constraints) {
    return Positioned(
      top: 0,
      left: 0,
      child: IconButton(
        visualDensity: VisualDensity.compact,
        icon: Icon(Icons.help, size: 20, color: context.getTextColor()),
        onPressed: () => setState(() {
          helpOpen = true;
        }),
      ),
    );
  }

  Widget helpPage(BoxConstraints constraints) {
    return ClipLayer(
      matchColor: true,
      isOpen: helpOpen,
      child: Stack(
        children: [
          helpLayer(),
          closeButton(),
        ],
      ),
    );
  }

  Widget helpLayer() {
    return Positioned.fill(
      child: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 10),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 10),
            physics: const BouncingScrollPhysics(),
            children: [
              Text(
                'How to play',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(color: context.getTextColor()),
              ),
              const SizedBox(height: 10),
              Text(
                'Eliminate your target by the agreed way in real live. Then add the elimination to the list and receive a new target, until everyone is eliminated.',
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.caption!.copyWith(color: context.getTextColor()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget closeButton() {
    return Positioned(
      top: 0,
      left: 0,
      child: Builder(
        builder: (context) => IconButton(
          visualDensity: VisualDensity.compact,
          icon: Icon(Icons.close, size: 20, color: context.getTextColor()),
          onPressed: () {
            setState(() {
              helpOpen = false;
            });
          },
        ),
      ),
    );
  }
}