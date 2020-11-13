import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import 'general/Module.dart';
import 'general/ModuleRegistry.dart';
import 'models/Trip.dart';
import 'service/AppService.dart';
import 'providers/AppState.dart';
import 'pages/TripHome.dart';
import 'pages/NoTrip.dart';

void main() {
  ModuleRegistry.registerModules();
  runApp(ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      builder: (context, _) {
        var state = Provider.of<AppState>(context, listen: false);
        return MyApp(state);
      }));
}

class MyApp extends StatefulWidget {
  AppState state;
  MyApp(this.state);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    AppService.initApp(this.widget.state).then((_) => setState(() => isLoaded = true));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jufa',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(
        color: Colors.white,
        child: AnimatedSwitcher(
          switchInCurve: Curves.linear,
          switchOutCurve: Curves.easeOutExpo,
          duration: Duration(milliseconds: 600),
          child: isLoaded
              ? Selector<AppState, Trip>(
                  selector: (context, state) => state.getSelectedTrip(),
                  shouldRebuild: (previous, next) => previous == null || next == null || previous.id != next.id,
                  builder: (BuildContext context, Trip trip, _) {
                    if (trip != null) {
                      return TripHome(trip);
                    } else {
                      return NoTrip();
                    }
                  },
                )
              : LoadingScreen(),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("", style: Theme.of(context).textTheme.headline5),
                Container(height: 20),
                Expanded(
                  child: AnimationLimiter(
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      crossAxisCount: 2,
                      children: List.generate(6, (int index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 300),
                          delay: const Duration(milliseconds: 100),
                          columnCount: 2,
                          child: ScaleAnimation(
                            scale: 0.7,
                            child: FadeInAnimation(
                              child: ModuleCard(builder: (context) => Container()),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
