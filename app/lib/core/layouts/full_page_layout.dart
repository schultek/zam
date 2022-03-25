import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../areas/full_page_area.dart';
import '../widgets/layout_preview.dart';
import 'layout_model.dart';

@MappableClass(discriminatorValue: 'page')
class FullPageLayoutModel extends LayoutModel {
  const FullPageLayoutModel({String? type}) : super(type ?? 'page');

  @override
  String get name => 'Full Page Layout';

  @override
  Widget builder(LayoutContext context) => FullPageLayout(context);

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

  const FullPageLayout(this.layoutContext, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (layoutContext.header != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          layoutContext.header!,
          Expanded(
            child: FullPageArea(id: layoutContext.id + '_page'),
          )
        ],
      );
    } else {
      return SafeArea(
        child: FullPageArea(id: layoutContext.id + '_page'),
      );
    }
  }
}
