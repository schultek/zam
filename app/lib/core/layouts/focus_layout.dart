import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../../main.mapper.g.dart';
import '../areas/areas.dart';
import '../elements/elements.dart';
import '../themes/themes.dart';
import '../widgets/layout_preview.dart';
import 'layout_model.dart';
import 'widgets/fill_overscroll.dart';

@MappableClass(discriminatorValue: 'focus')
class FocusLayoutModel extends LayoutModel {
  const FocusLayoutModel({this.showActions = true, this.showInfo = true}) : super();

  final bool showActions;
  final bool showInfo;

  @override
  String get name => 'Focus Layout';

  @override
  Widget builder(LayoutContext context) => FocusLayout(context, this);

  @override
  List<Widget> settings(BuildContext context, void Function(LayoutModel) update) {
    return [
      SwitchListTile(
        title: Text(context.tr.show_quick_actions),
        value: showActions,
        onChanged: (value) => update(copyWith(showActions: value)),
      ),
      SwitchListTile(
        title: Text(context.tr.show_info_cards),
        value: showInfo,
        onChanged: (value) => update(copyWith(showInfo: value)),
      ),
    ];
  }

  @override
  PreviewPage preview({Widget? header}) => PreviewPage(segments: [
        PreviewSection(
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
  final FocusLayoutModel model;

  const FocusLayout(this.layoutContext, this.model, {Key? key}) : super(key: key);

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
                          child: SingleElementArea(
                            id: widget.layoutContext.id + '_focus',
                            decorator: const ClippedContentElementDecorator(),
                          ),
                        ),
                      ),
                    ),
                    if (widget.model.showActions)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
                        child: ThemedSurface(
                          builder: (context, color) => Container(
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(blurRadius: 10, spreadRadius: -4)]),
                            padding: const EdgeInsets.all(5),
                            child: ActionRowArea(
                              widget.layoutContext.id + '_actions',
                              decorator: const DefaultActionDecorator(ColorPreference(useHighlightColor: true)),
                            ),
                          ),
                        ),
                      ),
                    if (widget.model.showInfo)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: ActionRowArea(
                          widget.layoutContext.id + '_infos',
                          decorator: const CardActionDecorator(),
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
