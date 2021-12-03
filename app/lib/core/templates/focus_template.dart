import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/trips/selected_trip_provider.dart';
import '../areas/areas.dart';
import '../areas/body_widget_area.dart';
import '../elements/decorators/card_quick_action_decorator.dart';
import '../themes/widgets/trip_theme.dart';
import 'template_model.dart';
import 'widget_template.dart';
import 'widgets/reorder_toggle.dart';
import 'widgets/sliver_template_header.dart';
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
          SliverTemplateHeader(
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 20, right: 20, bottom: 10),
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
                        style: Theme.of(context).textTheme.headline5!.apply(color: context.getTextColor()),
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
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            sliver: SliverToBoxAdapter(child: QuickActionRowArea('actions')),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            sliver: SliverToBoxAdapter(child: QuickActionRowArea('infos', decorator: CardQuickActionDecorator())),
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
