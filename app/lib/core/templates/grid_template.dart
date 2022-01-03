import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/trips/selected_trip_provider.dart';
import '../areas/mixed_grid_area.dart';
import '../themes/theme_context.dart';
import 'template_model.dart';
import 'widget_template.dart';
import 'widgets/reorder_toggle.dart';
import 'widgets/sliver_template_header.dart';
import 'widgets/trip_selector.dart';

@MappableClass(discriminatorValue: 'grid')
class GridTemplateModel extends TemplateModel {
  GridTemplateModel({String? type}) : super(type ?? 'grid');

  @override
  String get name => 'Grid Template';
  @override
  WidgetTemplate<TemplateModel> builder() => GridTemplate(this);
}

class GridTemplate extends WidgetTemplate<GridTemplateModel> {
  GridTemplate(GridTemplateModel model, {Key? key}) : super(model, key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetTemplateState state) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverTemplateHeader(
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 20, right: 20, bottom: 10),
              child: Consumer(
                builder: (context, ref, _) {
                  var trip = ref.watch(selectedTripProvider)!;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TripSelectorButton(),
                      Text(
                        trip.name,
                        style: context.theme.textTheme.headline5!.apply(color: context.onSurfaceColor),
                      ),
                      const SizedBox(width: 50, child: ReorderToggle()),
                    ],
                  );
                },
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
