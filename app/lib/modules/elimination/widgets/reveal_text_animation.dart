import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../elimination.module.dart';

class RevealTextAnimation extends StatefulWidget {
  final String text;
  const RevealTextAnimation({Key? key, required this.text}) : super(key: key);

  @override
  _RevealTextAnimationState createState() => _RevealTextAnimationState();
}

class _RevealTextAnimationState extends State<RevealTextAnimation> with TickerProviderStateMixin, GestureArenaMember {
  late List<int> range;
  late AnimationController controller;
  late List<Tween<double>> tweens;
  late String obscuredText;
  late int lenOff;

  Timer? delayTimer;
  GestureArenaEntry? revealEntry;

  static const obscureChars = '¿ɫɤɷʓʘʨʧʦʥʤΦΧΨΩΣϔϞϢϪϰϼϠϑϐξ';

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    initTweens();
  }

  @override
  void didUpdateWidget(RevealTextAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    initTweens();
  }

  void initTweens() {
    var rand = Random(widget.text.hashCode ^ context.read(userIdProvider)!.hashCode);
    var lenDelt = min(12, widget.text.length);
    var lenHalf = (lenDelt / 2).floor();
    lenOff = ((rand.nextInt(lenDelt + 1) - lenHalf) / 2).floor();
    range = List.generate(max(widget.text.length + lenOff * 2, widget.text.length), (index) => index);
    var offsets = [...range]..shuffle(rand);
    var overlap = 0.3;
    tweens = range.map((i) {
      var offset = offsets[i] * overlap;
      return Tween(begin: -offset, end: (1 + range.length * overlap) - offset);
    }).toList();
    obscuredText = List.generate(
      widget.text.length + lenOff * 2,
      (_) => obscureChars[rand.nextInt(obscureChars.length)],
    ).join();
  }

  @override
  void acceptGesture(int pointer) {
    revealEntry?.resolve(GestureDisposition.accepted);
    delayTimer?.cancel();
    revealEntry = null;
    controller.forward();
  }

  @override
  void rejectGesture(int pointer) {
    revealEntry?.resolve(GestureDisposition.rejected);
    delayTimer?.cancel();
    revealEntry = null;
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        revealEntry = GestureBinding.instance!.gestureArena.add(details.pointer, this);
        delayTimer = Timer(const Duration(milliseconds: 400), () {
          acceptGesture(details.pointer);
        });
      },
      onPointerUp: (details) {
        rejectGesture(details.pointer);
      },
      onPointerCancel: (details) {
        rejectGesture(details.pointer);
      },
      child: AbsorbPointer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${context.tr.eliminate}:',
              style: TextStyle(fontWeight: FontWeight.bold, color: context.onSurfaceColor),
            ),
            const SizedBox(height: 5),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40),
              child: LayoutBuilder(
                builder: (context, constraints) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i in range) _slideCharacter(i, constraints),
                  ],
                ),
              ),
            ),
            Text(
              context.tr.hold_to_reveal,
              style: context.theme.textTheme.caption!.apply(fontSizeFactor: 0.8, color: context.onSurfaceColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slideCharacter(int index, BoxConstraints constraints) {
    var textStyle = TextStyle(
      fontFamily: 'Cousine',
      fontSize: constraints.maxWidth / (max(range.length, 4)),
      height: 1.4,
      color: context.onSurfaceHighlightColor,
    );
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (index >= tweens.length) {
          return Container();
        }
        var tween = tweens[index];
        var value = tween.transform(controller.value).clamp(0.0, 1.0);
        if (controller.velocity > 0) {
          value = Curves.bounceOut.transform(value);
        } else {
          value = Curves.bounceIn.transform(value);
        }

        var obscureIndex = lenOff > 0 ? index : index + lenOff;
        var textIndex = lenOff < 0 ? index : index - lenOff;

        return ClipRect(
          child: Stack(
            children: [
              FractionalTranslation(
                translation: Offset(0, value),
                child: Text(
                  obscureIndex >= 0 && obscureIndex < obscuredText.length ? obscuredText[obscureIndex] : '',
                  style: textStyle,
                ),
              ),
              FractionalTranslation(
                translation: Offset(0, value - 1),
                child: Text(
                  textIndex >= 0 && textIndex < widget.text.length ? widget.text[textIndex] : '',
                  style: textStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
