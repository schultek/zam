import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth/claims_provider.dart';
import '../../widgets/ju_background.dart';
import '../create_trip/create_trip_screen.dart';

class NoTripScreen extends StatefulWidget {
  @override
  _NoTripScreenState createState() => _NoTripScreenState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => NoTripScreen());
  }

  static MaterialPage page() {
    return MaterialPage(child: NoTripScreen());
  }
}

class _NoTripScreenState extends State<NoTripScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: JuBackground(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: Consumer(
              builder: (context, watch, _) {
                var claims = watch(claimsProvider);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Dein Ausflug.\n\nSo wie du ihn willst.',
                      style: TextStyle(color: Colors.white, fontSize: 80, height: 1),
                    ),
                    if (claims.isOrganizer || claims.isAdmin)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoCard(
                            elevation: 8.0,
                            radius: const BorderRadius.all(Radius.circular(50.0)),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateTripScreen()));
                              },
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(28.0),
                                  child: Text(
                                    'Neuen Ausflug erstellen',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'oder Einladungslink verwenden.',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    else
                      CupertinoCard(
                        elevation: 8.0,
                        padding: const EdgeInsets.all(30.0),
                        radius: const BorderRadius.all(Radius.circular(80.0)),
                        child: const Center(
                            child: Text(
                          'Du benötigst einen Einladungslink von deinem Organisator.',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
