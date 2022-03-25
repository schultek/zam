import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../areas/areas.dart';
import '../areas/single_widget_area.dart';
import '../elements/decorators/card_quick_action_decorator.dart';
import '../elements/decorators/clipped_content_segment_decorator.dart';
import '../elements/decorators/default_quick_action_decorator.dart';
import '../themes/themes.dart';
import '../widgets/layout_preview.dart';
import 'layout_model.dart';
import 'widgets/fill_overscroll.dart';

@MappableClass(discriminatorValue: 'focus')
class FocusLayoutModel extends LayoutModel {
  const FocusLayoutModel({String? type}) : super(type ?? 'focus');

  @override
  String get name => 'Focus Layout';

  @override
  Widget builder(LayoutContext context) => FocusLayout(context);

  @override
  PreviewPage preview({Widget? header}) => PreviewPage(segments: [
        PreviewSegment(
          fill: false,
          child: Column(
            children: [
              if (header != null) header else const SizedBox(height: 10),
              const Center(child: PreviewCard(width: 40, height: 40)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  children: const [
                    PreviewCard(width: 20, height: 20),
                    SizedBox(width: 5),
                    PreviewCard(width: 20, height: 20),
                    SizedBox(width: 5),
                    PreviewCard(width: 20, height: 20),
                  ],
                ),
              ),
              const PreviewGrid(),
            ],
          ),
        ),
      ]);
}

class FocusLayout extends StatefulWidget {
  final LayoutContext layoutContext;

  const FocusLayout(this.layoutContext, {Key? key}) : super(key: key);

  @override
  State<FocusLayout> createState() => _FocusLayoutState();
}

class _FocusLayoutState extends State<FocusLayout> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FillOverscroll(
      fill: Container(
        color: context.tripTheme
            .computeSurfaceTheme(context: context, preference: const ColorPreference(useHighlightColor: true))
            .surfaceColor,
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ThemedSurface(
              preference: const ColorPreference(useHighlightColor: true),
              builder: (context, color) => CustomPaint(
                painter: FocusBackgroundPainter(context, color),
                child: Column(
                  children: [
                    if (widget.layoutContext.header != null) //
                      widget.layoutContext.header!
                    else
                      SizedBox(height: MediaQuery.of(context).padding.top + 20),
                    SizedBox(
                      height: 250,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: SingleWidgetArea(
                            id: widget.layoutContext.id + '_focus',
                            decorator: const ClippedContentSegmentDecorator(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
                      child: ThemedSurface(
                        builder: (context, color) => Container(
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [BoxShadow(blurRadius: 10, spreadRadius: -4)]),
                          padding: const EdgeInsets.all(5),
                          child: QuickActionRowArea(
                            widget.layoutContext.id + '_actions',
                            decorator: const DefaultQuickActionDecorator(ColorPreference(useHighlightColor: true)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: QuickActionRowArea(
                        widget.layoutContext.id + '_infos',
                        decorator: const CardQuickActionDecorator(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            sliver: SliverToBoxAdapter(
                child: MixedGridArea(id: widget.layoutContext.id + '_grid', scrollController: _scrollController)),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)),
        ],
      ),
    );
  }
}

class FocusBackgroundPainter extends CustomPainter {
  final BuildContext context;
  final Color color;

  FocusBackgroundPainter(this.context, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.drawCircle(Offset(size.width / 4, 0.0), size.height * 0.92, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant FocusBackgroundPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
