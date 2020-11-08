import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jufa/general/Module.dart';
import 'package:jufa/modules/thebutton/TheButtonRepository.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'TheButtonAnimationController.dart';

class TheButtonModule extends Module {
  @override
  List<ModuleCard> getCards(ModuleData data) {
    return [
      ModuleCard(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: TheButton(data.trip.id),
              ),
            ),
            Positioned.fill(child: TheButtonHelp()),
          ],
        ),
      ),
    ];
  }
}

class TheButtonHelp extends StatefulWidget {
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
            icon: Icon(Icons.help, size: 20, color: Colors.black26),
            onPressed: () {
              setState(() {
                this.helpOpen = true;
              });
            },
          ),
        ),
        Positioned.fill(
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: this.helpOpen ? 1.0 : 0.0),
            builder: (context, double value, _) {
              return ClipOval(
                clipper: ExpandClipper(value),
                child: Material(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.grey,
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("The Button", style: Theme.of(context).textTheme.bodyText2),
                                  Text("The Button is a social game where you have to keep the button alive.",
                                      style: Theme.of(context).textTheme.caption, textAlign: TextAlign.center)
                                ],
                              ))),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(Icons.close, size: 20, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              this.helpOpen = false;
                            });
                          },
                        ),
                      ),
                    ],
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
        center: Offset(20, 20), width: size.width * 2 * sqrt(2) * this.value, height: size.height * 2 * sqrt(2) * this.value);
  }

  @override
  bool shouldReclip(ExpandClipper oldClipper) => oldClipper.value != value;
}

class TheButton extends StatelessWidget {

  String tripId;

  TheButton(this.tripId);

  @override
  Widget build(BuildContext context) {
    return Provider<TheButtonRepository>(
      create: (context) => TheButtonRepository(tripId),
      dispose: (context, repo) => repo.dispose(),
      builder: (context, _) {
        var repo = Provider.of<TheButtonRepository>(context);

        return RaisedButton(
            child: FutureBuilder<Artboard>(
              future: rootBundle.load('lib/assets/animations/the_button.riv').then((data) async {
                var file = RiveFile();
                file.import(data);

                var artboard = file.mainArtboard;

                var waveController = SimpleAnimation("Wave");
                artboard.addController(waveController);
                waveController.instance.animation.speed = 0.1;

                var fillController = TheButtonAnimationController();
                artboard.addController(fillController);

                fillController.jumpTo(await repo.buttonState.first);
                repo.buttonState.listen((value) {
                  fillController.animateTo(value);
                });

                return artboard;
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Rive(artboard: snapshot.data);
                } else {
                  return Container();
                }
              },
            ),
            shape: CircleBorder(),
            padding: EdgeInsets.zero,
            color: Colors.black26,
            elevation: 8,
            onPressed: () {
              repo.resetState();
            });
      },
    );
  }
}
