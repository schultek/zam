import 'dart:ui';

import 'package:flutter/material.dart';

import 'ju_background.dart';

class JuLayout extends StatelessWidget {
  const JuLayout({required this.header, required this.body, this.height = 320, Key? key}) : super(key: key);

  final Widget header;
  final Widget body;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: JuBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - height,
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: header,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom - height,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    color: Colors.white30,
                    child: body,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
