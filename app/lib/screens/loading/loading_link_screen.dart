import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../widgets/ju_background.dart';

class LoadingLinkScreen extends StatelessWidget {
  const LoadingLinkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
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
