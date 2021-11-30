import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/trips/selected_trip_provider.dart';
import '../areas/body_widget_area.dart';
import '../themes/widgets/trip_theme.dart';
import 'template_model.dart';
import 'widget_template.dart';
import 'widgets/reorder_toggle.dart';
import 'widgets/sliver_template_header.dart';

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
                      const SizedBox(width: 50),
                      Text(
                        trip.name,
                        style: Theme.of(context).textTheme.headline5!.apply(color: context.getTextColor()),
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
            sliver: SliverToBoxAdapter(child: BodyWidgetArea(_scrollController)),
          ),
          if (state.isEditing) SliverToBoxAdapter(child: Container(height: 130)),
        ],
      ),
    );
  }
}
