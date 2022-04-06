import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../thebutton.module.dart';

class TheButtonSettings extends StatefulWidget {
  const TheButtonSettings({required this.onChanged, Key? key}) : super(key: key);

  final void Function(String) onChanged;

  @override
  _TheButtonSettingsState createState() => _TheButtonSettingsState();
}

class _TheButtonSettingsState extends State<TheButtonSettings> {
  late final ScrollController scrollController;

  final options = ['0:10', '0:20', '0:30', '0:45', '1', '2', '5', '10', '24'];
  int selectedIndex = 0;

  final double height = 200;

  @override
  void initState() {
    super.initState();
    var currentHours = context.read(theButtonProvider).value?.aliveHours ?? 0;
    var currentOption = valueToOption(currentHours);
    var currentIndex = options.indexOf(currentOption);
    if (currentIndex != -1) {
      selectedIndex = currentIndex;
      scrollController = ScrollController(initialScrollOffset: currentIndex * height * 0.2);
    } else {
      scrollController = ScrollController();
    }
  }

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
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height),
      child: Stack(
        children: [
          focusShade(),
          timerIcon(),
          hourIcon(),
          timeScroller(),
          submitButton(),
        ],
      ),
    );
  }

  String? asOption(double? aliveHours) {
    if (aliveHours == null) return null;
    var h = aliveHours.floor();
    var m = ((aliveHours - h) * 60).round();
    return h == 0 ? '0:$m' : '$h';
  }

  Widget focusShade() {
    return Positioned(
      top: height * 0.35,
      bottom: height * 0.35,
      left: 0,
      right: 0,
      child: ThemedSurface(
        builder: (context, fillColor) => Container(color: fillColor),
      ),
    );
  }

  Widget timerIcon() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      width: 50,
      child: Opacity(
        opacity: 0.3,
        child: Center(
          child: Builder(
            builder: (context) => Icon(
              Icons.timer,
              color: context.onSurfaceColor,
            ),
          ),
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
          child: Builder(
            builder: (context) => Text(
              'h',
              textAlign: TextAlign.center,
              style: context.theme.textTheme.headline5!.apply(fontSizeFactor: 1.2, color: context.onSurfaceColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget timeScroller() {
    return Positioned.fill(
      child: ThemedSurface(
        builder: (context, fillColor) => NotificationListener(
          onNotification: (n) {
            if (n is ScrollEndNotification) {
              animateSnap(
                pixel: n.metrics.pixels,
                itemSize: height * 0.2,
              );
            }
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListWheelScrollView(
              controller: scrollController,
              itemExtent: height * 0.2,
              diameterRatio: 1.5,
              useMagnifier: true,
              magnification: 1.5,
              physics: const BouncingScrollPhysics(),
              children: [
                for (var option in options)
                  Center(
                    child: Text(
                      option,
                      style: context.theme.textTheme.headline5!
                          .copyWith(color: context.onSurfaceColor, fontSize: height / 8),
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

  Widget submitButton() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: IconButton(
        splashRadius: 30,
        visualDensity: VisualDensity.compact,
        icon: Icon(Icons.check, size: 30, color: context.theme.colorScheme.primary),
        onPressed: () {
          widget.onChanged(options[selectedIndex]);
        },
      ),
    );
  }
}
