import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/trips/selected_trip_provider.dart';
import '../areas/areas.dart';
import '../areas/mixed_grid_area.dart';
import '../areas/single_widget_area.dart';
import '../elements/decorators/card_quick_action_decorator.dart';
import '../elements/decorators/clipped_content_segment_decorator.dart';
import '../elements/decorators/default_quick_action_decorator.dart';
import '../themes/theme_context.dart';
import '../themes/trip_theme_data.dart';
import '../themes/widgets/themed_surface.dart';
import 'template_model.dart';
import 'widget_template.dart';
import 'widgets/reorder_toggle.dart';
import 'widgets/trip_selector.dart';

@MappableClass(discriminatorValue: 'focus')
class FocusTemplateModel extends TemplateModel {
  FocusTemplateModel({String? type}) : super(type ?? 'focus');

  @override
  String get name => 'Focus Template';
  @override
  WidgetTemplate<TemplateModel> builder() => FocusTemplate(this);

  @override
  List<Widget>? settings(BuildContext context) => FocusTemplate.settings(context, this);
}

class FocusTemplate extends WidgetTemplate<FocusTemplateModel> {
  FocusTemplate(FocusTemplateModel model, {Key? key}) : super(model, key: key);

  final _scrollController = ScrollController();

  static List<Widget> settings(BuildContext context, FocusTemplateModel model) {
    return [];
  }

  @override
  Widget build(BuildContext context, WidgetTemplateState state) {
    return Scaffold(
      body: CustomScrollView(
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
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 20, left: 20, right: 20, bottom: 10),
                      child: Consumer(
                        builder: (context, ref, _) {
                          var trip = ref.watch(selectedTripProvider)!;
                          var user = ref.watch(tripUserProvider)!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TripSelectorButton(),
                              Text(
                                trip.name,
                                style: context.theme.textTheme.headline5!.apply(color: context.onSurfaceColor),
                              ),
                              if (user.isOrganizer)
                                const SizedBox(
                                  width: 50,
                                  child: ReorderToggle(),
                                )
                              else
                                const SizedBox(width: 50),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 250,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: SingleWidgetArea(id: 'focus', decorator: ClippedContentSegmentDecorator()),
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
                          child: const QuickActionRowArea(
                            'actions',
                            decorator: DefaultQuickActionDecorator(ColorPreference(useHighlightColor: true)),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: QuickActionRowArea('infos', decorator: CardQuickActionDecorator()),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            sliver: SliverToBoxAdapter(child: MixedGridArea(id: 'body', scrollController: _scrollController)),
          ),
          if (state.isEditing) SliverToBoxAdapter(child: Container(height: 130)),
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
    canvas.drawCircle(Offset(size.width / 4, 0.0), size.height * 0.92, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant FocusBackgroundPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
