import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../widgets/ju_background.dart';

class LoadingLinkScreen extends StatefulWidget {
  const LoadingLinkScreen({Key? key}) : super(key: key);

  @override
  State<LoadingLinkScreen> createState() => _LoadingLinkScreenState();
}

class _LoadingLinkScreenState extends State<LoadingLinkScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1700), vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return JuBackground(
            transform: Curves.elasticOut.transform(_controller.value),
            child: child!,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'JUFA',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Fast geschafft.\nWir bereiten alles für dich vor...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 18,
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
