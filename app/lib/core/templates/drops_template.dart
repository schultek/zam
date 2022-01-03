import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../helpers/extensions.dart';
import '../../main.mapper.g.dart';
import '../../modules/labels/labels_module.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../areas/horizontal_scroll_area.dart';
import '../areas/single_widget_area.dart';
import '../elements/content_segment.dart';
import '../elements/decorators/clipped_content_segment_decorator.dart';
import '../themes/theme_context.dart';
import '../themes/trip_theme_data.dart';
import '../themes/widgets/themed_surface.dart';
import 'template_model.dart';
import 'widget_template.dart';
import 'widgets/reorder_toggle.dart';
import 'widgets/trip_selector.dart';

export '../elements/content_segment.dart' show IdProvider;

@MappableClass()
class DropModel implements IdProvider {
  final String id;
  final String? label;
  final bool isHidden;

  DropModel({required this.id, this.label, this.isHidden = false});

  @override
  void provide(BuildContext context, String encodedLabel) {
    var model = (WidgetTemplate.of(context, listen: false).widget.config as DropsTemplateModel);
    var label = utf8.decode(base64.decode(encodedLabel));
    model.update(context, (model) => model.copyWith.drops.at(model.drops.indexOf(this)).call(label: label));
  }
}

@MappableClass(discriminatorValue: 'drops')
class DropsTemplateModel extends TemplateModel {
  DropsTemplateModel({String? type, this.drops = const []}) : super(type ?? 'drops');

  final List<DropModel> drops;

  @override
  String get name => 'Drops Template';
  @override
  WidgetTemplate<TemplateModel> builder() => DropsTemplate(this);
}

class DropsTemplate extends WidgetTemplate<DropsTemplateModel> {
  DropsTemplate(DropsTemplateModel model, {Key? key}) : super(model, key: key);

  final _scrollController = ScrollController();

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
              builder: (context, color) => Container(
                color: color,
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 10, right: 10, bottom: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TripSelectorButton(),
                          Text(
                            context.watch(selectedTripProvider.select((trip) => trip!.name)),
                            style: context.theme.textTheme.headline5!.apply(color: context.onSurfaceColor),
                          ),
                          SizedBox(width: 50, child: context.watch(isOrganizerProvider) ? const ReorderToggle() : null),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(
                      height: 200,
                      child: SingleWidgetArea(id: 'focus', decorator: ClippedContentSegmentDecorator()),
                    ),
                  ],
                ),
              ),
            ),
          ),
          for (var drop in config.drops)
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
                            idProvider: drop,
                          ),
                        ),
                        if (context.read(isOrganizerProvider)) ...[
                          const SizedBox(width: 10),
                          IconButton(
                            icon: Icon(drop.isHidden ? Icons.visibility_off : Icons.visibility,
                                color: context.onSurfaceHighlightColor),
                            onPressed: () {
                              config.update(
                                context,
                                (m) {
                                  return m.copyWith.drops.at(m.drops.indexOf(drop)).call(isHidden: !drop.isHidden);
                                },
                              );
                            },
                          ),
                          if (state.isEditing)
                            IconButton(
                              icon: Icon(Icons.delete, color: context.theme.errorColor),
                              onPressed: () {
                                config.update(context, (m) {
                                  return m.copyWith.drops.where((d) => d.id != drop.id);
                                });
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
                    child: HorizontalScrollArea(drop.id),
                  ),
                ),
              ),
            ],
          if (state.isEditing)
            SliverPadding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              sliver: SliverToBoxAdapter(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(20)),
                  child: const Text('Add Area'),
                  onPressed: () {
                    config.update(context, (model) => model.copyWith.drops.add(DropModel(id: generateRandomId())));
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
