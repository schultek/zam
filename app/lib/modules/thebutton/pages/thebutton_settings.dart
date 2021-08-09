import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/themes.dart';
import '../thebutton_provider.dart';
import '../widgets/clip_layer.dart';
import '../widgets/expand_clipper.dart';

class TheButtonSettings extends StatefulWidget {
  const TheButtonSettings({required Key key}) : super(key: key);

  @override
  _TheButtonSettingsState createState() => _TheButtonSettingsState();
}

class _TheButtonSettingsState extends State<TheButtonSettings> {
  bool settingsOpen = false;
  bool resetOpen = false;
  bool confirmOpen = false;
  bool? isResettingHealth;

  final scrollController = ScrollController();

  final options = ["0:10", "0:20", "0:30", "0:45", "1", "2", "5", "10", "24"];
  int selectedIndex = 0;

  void animateSnap({double? pixel, required double itemSize}) {
    int cardIndex = ((pixel! - itemSize / 2) / itemSize).ceil();
    cardIndex = max(0, min(options.length - 1, cardIndex));

    selectIndex(cardIndex, itemSize);
  }

  void selectIndex(int index, double itemSize, {bool animate = true}) {
    setState(() {
      selectedIndex = index;
    });

    var offset = index * itemSize;
    Future.delayed(Duration.zero, () {
      if (animate) {
        scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        scrollController.jumpTo(offset);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          settingsButton(context, constraints),
          settingsPage(constraints),
        ],
      ),
    );
  }

  String? asOption(double? aliveHours) {
    if (aliveHours == null) return null;
    var h = aliveHours.floor();
    var m = ((aliveHours - h) * 60).round();
    return h == 0 ? "0:$m" : "$h";
  }

  Widget settingsButton(BuildContext context, BoxConstraints constraints) {
    return Positioned(
      top: 0,
      right: 0,
      child: IconButton(
        visualDensity: VisualDensity.compact,
        icon: Icon(Icons.settings, size: 20, color: context.getTextColor()),
        onPressed: () => setState(() {
          settingsOpen = true;
          selectIndex(
            options.indexOf(asOption(context.read(theButtonProvider).aliveHours) ?? options[0]),
            constraints.maxHeight * 0.2,
            animate: false,
          );
        }),
      ),
    );
  }

  Widget settingsPage(BoxConstraints constraints) {
    return ClipLayer(
      matchColor: true,
      corner: Corner.topRight,
      isOpen: settingsOpen,
      child: Stack(
        children: [
          focusShade(constraints),
          timerIcon(),
          hourIcon(),
          timeScroller(constraints),
          submitButton(),
          resetButton(),
          resetLayer(),
          confirmLayer(),
          closeButton(),
        ],
      ),
    );
  }

  Widget focusShade(BoxConstraints constraints) {
    return Positioned(
      top: constraints.maxHeight * 0.35,
      bottom: constraints.maxHeight * 0.35,
      left: 0,
      right: 0,
      child: FillColor(
        builder: (context, fillColor) => Container(color: fillColor),
      ),
    );
  }

  Widget timerIcon() {
    return const Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      width: 50,
      child: Opacity(
        opacity: 0.3,
        child: Center(
          child: Icon(Icons.timer),
        ),
      ),
    );
  }

  Widget hourIcon() {
    return Positioned(
      top: 0,
      bottom: 0,
      width: 80,
      right: 0,
      child: Opacity(
        opacity: 0.3,
        child: Center(
          child: Text(
            "h",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5!.apply(fontSizeFactor: 1.2),
          ),
        ),
      ),
    );
  }

  Widget timeScroller(BoxConstraints constraints) {
    return Positioned.fill(
      child: FillColor(
        builder: (context, fillColor) => NotificationListener(
          onNotification: (n) {
            if (n is ScrollEndNotification) {
              animateSnap(
                pixel: n.metrics.pixels,
                itemSize: constraints.maxHeight * 0.2,
              );
            }
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListWheelScrollView(
              controller: scrollController,
              itemExtent: constraints.maxHeight * 0.2,
              diameterRatio: 1.5,
              useMagnifier: true,
              magnification: 1.5,
              physics: const BouncingScrollPhysics(),
              children: [
                for (var option in options)
                  Center(
                    child: Text(
                      option,
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget closeButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: Builder(
        builder: (context) => IconButton(
          splashRadius: 20,
          visualDensity: VisualDensity.compact,
          icon: Icon(Icons.close, size: 20, color: context.getTextColor()),
          onPressed: () {
            setState(() {
              settingsOpen = false;
              resetOpen = false;
              confirmOpen = false;
            });
          },
        ),
      ),
    );
  }

  Widget submitButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: IconButton(
        splashRadius: 20,
        visualDensity: VisualDensity.compact,
        icon: const Icon(Icons.check, size: 20, color: Colors.green),
        onPressed: () {
          setState(() {
            context.read(theButtonLogicProvider).setAlive(options[selectedIndex]);
            settingsOpen = false;
          });
        },
      ),
    );
  }

  Widget resetButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Builder(
        builder: (context) => IconButton(
          splashRadius: 20,
          visualDensity: VisualDensity.compact,
          icon: Icon(Icons.settings_backup_restore, size: 20, color: context.getTextColor()),
          onPressed: () {
            setState(() {
              resetOpen = true;
            });
          },
        ),
      ),
    );
  }

  Widget resetLayer() {
    return ClipLayer(
      isOpen: resetOpen,
      corner: Corner.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  setState(() {
                    confirmOpen = true;
                    isResettingHealth = true;
                  });
                },
                child: Text(
                  "Reset\nHealth",
                  style: TextStyle(color: context.getTextColor()),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  setState(() {
                    confirmOpen = true;
                    isResettingHealth = false;
                  });
                },
                child: Text(
                  "Reset\nLeaderboard",
                  style: TextStyle(color: context.getTextColor()),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget confirmLayer() {
    return ClipLayer(
      isOpen: confirmOpen,
      corner: Corner.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Do you want to\nreset the ${isResettingHealth == true ? 'health' : 'leaderboard'}?",
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: IconButton(
                      icon: const Icon(Icons.check, color: Colors.green, size: 30),
                      onPressed: () {
                        if (isResettingHealth == true) {
                          context.read(theButtonLogicProvider).resetHealth();
                        } else if (isResettingHealth == false) {
                          context.read(theButtonLogicProvider).resetLeaderboard();
                        }
                        setState(() {
                          settingsOpen = false;
                          confirmOpen = false;
                          resetOpen = false;
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red, size: 30),
                      onPressed: () {
                        setState(() {
                          settingsOpen = false;
                          confirmOpen = false;
                          resetOpen = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
