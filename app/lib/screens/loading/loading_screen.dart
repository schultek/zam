import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

class LoadingScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(child: LoadingScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text("", style: Theme.of(context).textTheme.headline5),
            ),
          ),
          AnimationLimiter(
            child: GridView.count(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                      child: Shimmer.fromColors(
                        baseColor: Colors.black,
                        highlightColor: Colors.black54,
                        child: Material(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: Colors.black12,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
