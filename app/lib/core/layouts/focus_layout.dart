import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../helpers/extensions.dart';
import '../../main.mapper.g.dart';
import '../../providers/groups/logic_provider.dart';
import '../areas/areas.dart';
import '../elements/elements.dart';
import '../themes/themes.dart';
import '../widgets/layout_preview.dart';
import '../widgets/select_image_list_tile.dart';
import 'layout_model.dart';
import 'widgets/fill_overscroll.dart';

@MappableClass(discriminatorValue: 'focus')
class FocusLayoutModel extends LayoutModel {
  const FocusLayoutModel({
    this.showActions = true,
    this.showInfo = true,
    this.coverUrl,
    this.invertHeader = false,
  }) : super();

  final bool showActions;
  final bool showInfo;
  final String? coverUrl;
  final bool invertHeader;

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
      SelectImageListTile(
        label: context.tr.custom_cover_image,
        hasImage: coverUrl != null,
        onImageSelected: (bytes) async {
          var link =
              await context.read(groupsLogicProvider).uploadFile('layouts/${generateRandomId(4)}/cover.png', bytes);
          update(copyWith(coverUrl: link));
        },
        onDelete: () {
          update(copyWith(coverUrl: null));
        },
      ),
      SwitchListTile(
        title: Text(context.tr.invert_header_color),
        value: invertHeader,
        onChanged: (value) => update(copyWith(invertHeader: value)),
      ),
    ];
  }

  @override
  PreviewPage preview({Widget? header}) => PreviewPage(
        layers: [
          PreviewLayer(
            segments: [
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
            ],
          ),
        ],
      );
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
        color: context.groupTheme
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
              builder: (context, color) => Stack(fit: StackFit.passthrough, children: [
                Positioned.fill(
                  child: FocusBackground(widget.model, color),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.layoutContext.header != null) //
                      if (widget.model.invertHeader)
                        ThemedSurface(builder: (_, __) => widget.layoutContext.header!)
                      else
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
                            decorator: widget.model.coverUrl != null
                                ? const GlassContentElementDecorator()
                                : const ClippedContentElementDecorator(),
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
              ]),
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

class FocusBackground extends StatelessWidget {
  const FocusBackground(this.model, this.color, {Key? key}) : super(key: key);

  final FocusLayoutModel model;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: FocusBackgroundClipper(),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          image: model.coverUrl != null
              ? DecorationImage(
                  image: CachedNetworkImageProvider(model.coverUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: model.coverUrl != null ? Container(color: color.withOpacity(0.4)) : null,
      ),
    );
    // return CustomPaint(painter: FocusBackgroundPainter(context, color));
  }
}

class FocusBackgroundClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    var r = size.height * 0.92;
    return Rect.fromLTWH(size.width / 4 - r, -r, r * 2, r * 2);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}

class FocusBackgroundPainter extends CustomPainter {
  final BuildContext context;
  final Color color;
  final ui.Image? image;

  FocusBackgroundPainter(this.context, this.color, [this.image]);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.drawCircle(Offset(size.width / 4, 0.0), size.height * 0.92, Paint()..color = color);
    if (image != null) {
      canvas.drawImage(image!, Offset.zero, Paint());
    }
  }

  @override
  bool shouldRepaint(covariant FocusBackgroundPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
