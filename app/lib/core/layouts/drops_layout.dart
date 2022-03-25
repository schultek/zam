import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../helpers/extensions.dart';
import '../../main.mapper.g.dart';
import '../../modules/labels/widgets/label_widget.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../areas/horizontal_scroll_area.dart';
import '../areas/single_widget_area.dart';
import '../elements/decorators/clipped_content_segment_decorator.dart';
import '../templates/widget_template.dart';
import '../themes/themes.dart';
import '../widgets/layout_preview.dart';
import 'layout_model.dart';
import 'widgets/fill_overscroll.dart';

@MappableClass()
class DropModel {
  final String id;
  final String? label;
  final bool isHidden;

  const DropModel({required this.id, this.label, this.isHidden = false});
}

@MappableClass(discriminatorValue: 'drops')
class DropsLayoutModel extends LayoutModel {
  const DropsLayoutModel({String? type, this.drops = const []}) : super(type ?? 'drops');

  final List<DropModel> drops;

  @override
  String get name => 'Drops Layout';

  @override
  Widget builder(LayoutContext context) => DropsLayout(context, this);

  @override
  PreviewPage preview({Widget? header}) => PreviewPage(
        segments: [
          PreviewSegment(
            child: Column(
              children: [
                if (header != null) header else const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: PreviewCard(width: 70, height: 40),
                ),
              ],
            ),
          ),
          PreviewSegment(
            fill: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < 3; i++) ...[
                    const SizedBox(height: 5),
                    const PreviewCard(width: 40, height: 8),
                    const SizedBox(height: 5),
                    SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < 3; i++) ...[
                            const PreviewCard(width: 30, height: 30),
                            const SizedBox(width: 5),
                          ]
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      );
}

class DropsLayout extends StatefulWidget {
  final LayoutContext layoutContext;
  final DropsLayoutModel model;

  const DropsLayout(this.layoutContext, this.model, {Key? key}) : super(key: key);

  @override
  State<DropsLayout> createState() => _DropsLayoutState();
}

class _DropsLayoutState extends State<DropsLayout> {
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
              builder: (context, color) => Material(
                color: color,
                child: Column(
                  children: [
                    if (widget.layoutContext.header != null) //
                      widget.layoutContext.header!
                    else
                      SizedBox(height: MediaQuery.of(context).padding.top + 10),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: SizedBox(
                        height: 200,
                        child: SingleWidgetArea(
                          id: widget.layoutContext.id + '_focus',
                          decorator: const ClippedContentSegmentDecorator(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          for (var drop in widget.model.drops)
            if (!drop.isHidden || context.read(isOrganizerProvider)) ...[
              SliverPadding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                sliver: SliverToBoxAdapter(
                  child: Opacity(
                    opacity: drop.isHidden ? 0.7 : 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: LabelWidget(
                            label: drop.label,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            onChanged: (value) {
                              widget.layoutContext.update(widget.model.copyWith.drops //
                                  .at(widget.model.drops.indexOf(drop))
                                  .call(label: value));
                            },
                          ),
                        ),
                        if (context.read(isOrganizerProvider)) ...[
                          const SizedBox(width: 10),
                          IconButton(
                            icon: Icon(drop.isHidden ? Icons.visibility_off : Icons.visibility,
                                color: context.onSurfaceHighlightColor),
                            onPressed: () {
                              widget.layoutContext.update(widget.model.copyWith.drops //
                                  .at(widget.model.drops.indexOf(drop))
                                  .call(isHidden: !drop.isHidden));
                            },
                          ),
                          if (WidgetTemplate.of(context).isEditing)
                            IconButton(
                              icon: Icon(Icons.delete, color: context.theme.errorColor),
                              onPressed: () {
                                widget.layoutContext.update(widget.model.copyWith.drops //
                                    .where((d) => d.id != drop.id));
                              },
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 10),
                sliver: SliverToBoxAdapter(
                  child: Opacity(
                    opacity: drop.isHidden ? 0.5 : 1,
                    child: HorizontalScrollArea(widget.layoutContext.id + '_' + drop.id),
                  ),
                ),
              ),
            ],
          if (WidgetTemplate.of(context).isEditing)
            SliverPadding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              sliver: SliverToBoxAdapter(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Add Section'),
                  onPressed: () {
                    widget.layoutContext.update(widget.model.copyWith.drops //
                        .add(DropModel(id: generateRandomId())));
                  },
                ),
              ),
            ),
          SliverPadding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)),
        ],
      ),
    );
  }
}
