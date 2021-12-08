import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../../widgets/cached_layout_builder.dart';
import '../areas/widget_area.dart';
import '../module/module_context.dart';
import '../route/route.dart';
import 'module_element.dart';
import 'widgets/module_element_builder.dart';

class IdProvider {
  String? _id;

  void provide(BuildContext context, String id) {
    _id = id;
    WidgetArea.of<ContentSegment>(context)!.updateWidgetsInTrip();
  }

  String? _getId(String id) {
    return _id != null ? id.split('/').take(1).followedBy([_id!]).join('/') : id;
  }
}

class ContentSegment extends ModuleElement with ModuleElementBuilder<ContentSegment> {
  final WidgetBuilder builder;
  final WidgetBuilder? onNavigate;
  final void Function(BuildContext context)? onTap;
  final SegmentSize size;
  final IdProvider? idProvider;
  final void Function(BuildContext context)? whenRemoved;

  ContentSegment({
    required ModuleContext context,
    required this.builder,
    this.onNavigate,
    this.onTap,
    this.size = SegmentSize.square,
    this.idProvider,
    this.whenRemoved,
  }) : super(key: UniqueKey(), context: context);

  factory ContentSegment.text({
    required ModuleContext context,
    required WidgetBuilder builder,
    IdProvider? idProvider,
  }) {
    return ContentSegment(
      context: context,
      builder: (context) => ContentSegmentText(builder),
      size: SegmentSize.wide,
      idProvider: idProvider,
    );
  }

  factory ContentSegment.items({
    required ModuleContext context,
    required ItemsBuilder itemsBuilder,
    required ItemsLayoutBuilder builder,
  }) {
    return ContentSegment(
      context: context,
      builder: (context) => ContentSegmentItems(builder, itemsBuilder),
      size: SegmentSize.wide,
    );
  }

  factory ContentSegment.list({
    required ModuleContext context,
    required List<Widget> Function(BuildContext context) builder,
    required double spacing,
  }) {
    var layoutKey = GlobalKey();
    return ContentSegment.items(
      context: context,
      itemsBuilder: builder,
      builder: (context, items) => CachedLayoutBuilder(
        key: layoutKey,
        builder: (context, constraints) => ListView(
          scrollDirection: constraints.hasBoundedWidth ? Axis.vertical : Axis.horizontal,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: items
              .intersperse(SizedBox(
                height: constraints.hasBoundedWidth ? spacing : null,
                width: constraints.hasBoundedWidth ? null : spacing,
              ))
              .toList(),
        ),
      ),
    );
  }

  factory ContentSegment.grid({
    required ModuleContext context,
    required List<Widget> Function(BuildContext context) builder,
    required double spacing,
  }) {
    var layoutKey = GlobalKey();
    return ContentSegment.items(
      context: context,
      itemsBuilder: builder,
      builder: (context, items) => CachedLayoutBuilder(
        key: layoutKey,
        builder: (context, constraints) {
          if (constraints.hasBoundedWidth) {
            var compSpacing = constraints.maxWidth > 300 ? spacing : spacing / 2;
            return GridView.count(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: compSpacing,
              crossAxisSpacing: compSpacing,
              children: items,
            );
          } else {
            return ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children:
                  items.intersperse(SizedBox(width: constraints.maxHeight > 300 ? spacing : spacing / 2)).toList(),
            );
          }
        },
      ),
    );
  }

  @override
  String get id => idProvider?._getId(super.id) ?? super.id;

  @override
  void onRemoved(BuildContext context) => whenRemoved?.call(context);

  @override
  ContentSegment get element => this;

  @override
  Widget buildElement(BuildContext context) {
    var child = decorator(context).decorateElement(context, this, builder(context));
    if (onTap != null || onNavigate != null) {
      child = GestureDetector(
        onTap: () {
          onTap?.call(context);
          if (onNavigate != null) {
            Navigator.of(context).push(ModulePageRoute(context, child: onNavigate!(context)));
          }
        },
        child: child,
      );
    }
    return child;
  }
}

typedef ItemsBuilder = List<Widget> Function(BuildContext);
typedef ItemsLayoutBuilder = Widget Function(BuildContext, List<Widget>);

class ContentSegmentItems extends StatelessWidget {
  final ItemsLayoutBuilder builder;
  final ItemsBuilder itemsBuilder;
  const ContentSegmentItems(this.builder, this.itemsBuilder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    throw UnsupportedError('ContentSegmentItems build() should never be used directly!');
  }
}

class ContentSegmentText extends StatelessWidget {
  final WidgetBuilder builder;
  const ContentSegmentText(this.builder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    throw UnsupportedError('ContentSegmentText build() should never be used directly!');
  }
}
