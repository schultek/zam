import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rive/rive.dart';

import '../../core/module/module.dart';
import 'thebutton_animation_controller.dart';
import 'thebutton_repository.dart';

@Module()
class TheButtonModule {
  ModuleData moduleData;
  TheButtonModule(this.moduleData);

  @ModuleItem(id: "thebutton")
  ContentSegment getButtonCard() {
    var buttonKey = GlobalKey();
    return ContentSegment(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(), //TheButton(moduleData.trip.id),
            ),
          ),
          Positioned.fill(child: TheButtonHelp(key: buttonKey)),
        ],
      ),
    );
  }
}

class TheButtonHelp extends StatefulWidget {
  const TheButtonHelp({required Key key}) : super(key: key);

  @override
  _TheButtonHelpState createState() => _TheButtonHelpState();
}

class _TheButtonHelpState extends State<TheButtonHelp> {
  bool helpOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.help, size: 20, color: context.getTextColor()),
            onPressed: () => setState(() => helpOpen = true),
          ),
        ),
        Positioned.fill(
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: helpOpen ? 1.0 : 0.0),
            builder: (context, double value, _) {
              return ClipOval(
                clipper: ExpandClipper(value),
                child: FillColor(
                  builder: (context, fillColor) => Material(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: fillColor,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "The Button",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Text(
                                  "The Button is a social game where you have to keep the button alive.",
                                  style: Theme.of(context).textTheme.caption,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: Icon(Icons.close, size: 20, color: context.getTextColor()),
                            onPressed: () {
                              setState(() {
                                helpOpen = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ExpandClipper extends CustomClipper<Rect> {
  double value;

  ExpandClipper(this.value);

  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
      center: const Offset(20, 20),
      width: size.width * 2 * sqrt(2) * value,
      height: size.height * 2 * sqrt(2) * value,
    );
  }

  @override
  bool shouldReclip(ExpandClipper oldClipper) => oldClipper.value != value;
}

class TheButton extends StatelessWidget {
  final String tripId;
  const TheButton(this.tripId);

  @override
  Widget build(BuildContext context) {
    return Provider<TheButtonRepository>(
      create: (context) => TheButtonRepository(tripId),
      dispose: (context, repo) => repo.dispose(),
      builder: (context, _) {
        var repo = Provider.of<TheButtonRepository>(context);

        return ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const CircleBorder()),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            backgroundColor: MaterialStateProperty.all(Colors.black26),
            elevation: MaterialStateProperty.all(8),
          ),
          onPressed: () {
            repo.resetState();
          },
          child: TheButtonAnimation(repo),
        );
      },
    );
  }
}

class TheButtonAnimation extends StatefulWidget {
  final TheButtonRepository repo;
  const TheButtonAnimation(this.repo);

  @override
  _TheButtonAnimationState createState() => _TheButtonAnimationState();
}

class _TheButtonAnimationState extends State<TheButtonAnimation> {
  static Future<Artboard> animationFuture = rootBundle.load('assets/animations/the_button.riv').then((data) async {
    var file = RiveFile.import(data);

    var artboard = file.mainArtboard;

    var waveController = SimpleAnimation("Wave");
    artboard.addController(waveController);
    waveController.instance!.animation.speed = 0.1;

    return artboard;
  });

  static Artboard? artboard;

  @override
  void initState() {
    super.initState();
    if (artboard == null) {
      loadAnimation().catchError((e) {});
    }
  }

  Future<void> loadAnimation() async {
    artboard = await animationFuture;

    var fillController = TheButtonAnimationController();
    artboard!.addController(fillController);

    SimpleAnimation deadController, deadEntryController;

    void runDeadAnimation() {
      deadController = SimpleAnimation("Dead");
      artboard!.addController(deadController);

      deadEntryController = SimpleAnimation("Dead Entry");
      artboard!.addController(deadEntryController);
    }

    var initialValue = await widget.repo.getValue();

    fillController.jumpTo(initialValue);
    if (initialValue >= 1) {
      runDeadAnimation();
    }

    widget.repo.buttonState.listen((value) {
      if (value < 1) {
        fillController.animateTo(value);
      } else {
        runDeadAnimation();
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (artboard != null) {
      return Rive(artboard: artboard!);
    } else {
      return Container();
    }
  }
}
