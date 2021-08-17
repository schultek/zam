import 'package:flutter/material.dart';

import '../../widgets/ju_background.dart';

class LoadingLinkScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(child: LoadingLinkScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: JuBackground(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Fast geschafft.\n\nWir bereiten alles für dich vor...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
