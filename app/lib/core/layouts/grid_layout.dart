import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../areas/areas.dart';
import '../widgets/layout_preview.dart';
import 'layout_model.dart';

@MappableClass(discriminatorValue: 'grid')
class GridLayoutModel extends LayoutModel {
  const GridLayoutModel() : super();

  @override
  String get name => 'Grid Layout';

  @override
  Widget builder(LayoutContext context) => GridLayout(context);

  @override
  PreviewPage preview({Widget? header}) => PreviewPage(segments: [
        PreviewSection(
          fill: false,
          child: Column(
            children: [
              if (header != null) header else const SizedBox(height: 10),
              const PreviewGrid(),
            ],
          ),
        ),
      ]);
}

class GridLayout extends StatefulWidget {
  final LayoutContext layoutContext;

  const GridLayout(this.layoutContext, {Key? key}) : super(key: key);

  @override
  State<GridLayout> createState() => _GridLayoutState();
}

class _GridLayoutState extends State<GridLayout> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      slivers: [
        if (widget.layoutContext.header != null) //
          SliverToBoxAdapter(child: widget.layoutContext.header!)
        else
          SliverPadding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
        SliverPadding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          sliver: SliverToBoxAdapter(
            child: MixedGridArea(
              id: widget.layoutContext.id + '_grid',
              scrollController: _scrollController,
            ),
          ),
        ),
        SliverPadding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)),
      ],
    );
  }
}
