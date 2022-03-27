import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../core.dart';
import '../widgets/layout_preview.dart';
import 'layout_model.dart';

@MappableClass(discriminatorValue: 'page')
class FullPageLayoutModel extends LayoutModel {
  const FullPageLayoutModel({this.backgroundPrimary = false}) : super();

  final bool backgroundPrimary;

  @override
  String get name => 'Full Page Layout';

  @override
  Widget builder(LayoutContext context) => FullPageLayout(context, this);

  @override
  List<Widget> settings(BuildContext context, void Function(LayoutModel) update) {
    return [
      SwitchListTile(
        title: Text(context.tr.primary_background),
        value: backgroundPrimary,
        onChanged: (value) => update(copyWith(backgroundPrimary: value)),
      ),
    ];
  }

  @override
  PreviewPage preview({Widget? header}) => PreviewPage(segments: [
        PreviewSegment(
          fill: false,
          child: Column(
            children: [
              if (header == null)
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: PreviewCard(width: 90, height: 190),
                )
              else ...[
                header,
                const Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  child: PreviewCard(width: 90, height: 165),
                ),
              ],
            ],
          ),
        ),
      ]);
}

class FullPageLayout extends StatelessWidget {
  final LayoutContext layoutContext;
  final FullPageLayoutModel model;

  const FullPageLayout(this.layoutContext, this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (layoutContext.header != null) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          layoutContext.header!,
          Expanded(
            child: FullPageArea(id: layoutContext.id + '_page'),
          )
        ],
      );
    } else {
      child = SafeArea(
        child: FullPageArea(id: layoutContext.id + '_page'),
      );
    }

    if (model.backgroundPrimary) {
      var inner = child;
      child = ThemedSurface(
        preference: const ColorPreference(useHighlightColor: true),
        builder: (context, color) => Container(color: color, child: inner),
      );
    }

    return child;
  }
}
