import 'package:flutter/material.dart';

import '../themes/themes.dart';

class PreviewPage extends StatelessWidget {
  final List<Widget> layers;
  final double scale;
  const PreviewPage({required this.layers, this.scale = 1, Key? key}) : super(key: key);

  PreviewPage apply({double? scale}) {
    return PreviewPage(layers: layers, scale: scale ?? this.scale, key: key);
  }

  PreviewPage addLayer(Widget layer) {
    return PreviewPage(layers: [...layers, layer], scale: scale, key: key);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: SizedBox(
        height: 208,
        width: 108,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: layers,
            ),
          ),
        ),
      ),
    );
  }
}

class PreviewLayer extends StatelessWidget {
  final List<Widget> segments;
  const PreviewLayer({required this.segments, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: segments,
      ),
    );
  }
}

class PreviewSection extends StatelessWidget {
  final Widget child;
  final bool fill;
  const PreviewSection({required this.child, this.fill = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemedSurface(
      preference: const ColorPreference(deltaElevation: 5),
      builder: (context, color) => Container(
        color: fill ? color : null,
        child: child,
      ),
    );
  }
}

class PreviewCard extends StatelessWidget {
  final double? width, height;
  final double radius;

  const PreviewCard({this.width, this.height, this.radius = 5, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemedSurface(
      preference: const ColorPreference(deltaElevation: 5),
      builder: (context, color) => Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        width: width,
        height: height,
      ),
    );
  }
}

class PreviewGrid extends StatelessWidget {
  const PreviewGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 5; i++) ...[
            if (i == 1)
              const PreviewCard(width: 80, height: 25)
            else
              Row(
                children: const [
                  PreviewCard(width: 38, height: 38),
                  SizedBox(width: 4),
                  PreviewCard(width: 38, height: 38),
                ],
              ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

class PreviewBox extends StatelessWidget {
  final Widget preview;
  final double padding;

  const PreviewBox({required this.preview, this.padding = 5, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: context.onSurfaceColor.withOpacity(0.3),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: FittedBox(
          child: preview,
        ),
      ),
    );
  }
}
