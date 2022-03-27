import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../module/module_context.dart';
import '../route/route.dart';
import 'module_element.dart';
import 'widgets/module_element_builder.dart';

class ContentSegment extends ModuleElement with ModuleElementBuilder<ContentSegment> {
  final WidgetBuilder builder;
  final WidgetBuilder? onNavigate;
  final void Function(BuildContext context)? onTap;
  final SegmentSize size;
  final void Function(BuildContext context)? whenRemoved;

  ContentSegment({
    required ModuleContext module,
    required this.builder,
    this.onNavigate,
    this.onTap,
    this.size = SegmentSize.square,
    this.whenRemoved,
    SettingsBuilder? settings,
  }) : super(module: module, settings: settings);

  factory ContentSegment.text({
    required ModuleContext module,
    required WidgetBuilder builder,
  }) {
    return ContentSegment(
      module: module,
      builder: (context) => ContentSegmentText(builder),
      size: SegmentSize.wide,
    );
  }

  factory ContentSegment.items({
    required ModuleContext module,
    required ItemsBuilder itemsBuilder,
    required ItemsLayoutBuilder builder,
    SettingsBuilder? settings,
  }) {
    return ContentSegment(
      module: module,
      builder: (context) => ContentSegmentItems(builder, itemsBuilder),
      size: SegmentSize.wide,
      settings: settings,
    );
  }

  factory ContentSegment.list({
    required ModuleContext module,
    required List<Widget> Function(BuildContext context) builder,
    required double spacing,
    SettingsBuilder? settings,
  }) {
    return ContentSegment.items(
      module: module,
      itemsBuilder: builder,
      builder: (context, items) => LayoutBuilder(
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
      settings: settings,
    );
  }

  factory ContentSegment.grid({
    required ModuleContext module,
    required List<Widget> Function(BuildContext context) builder,
    required double spacing,
    SettingsBuilder? settings,
  }) {
    return ContentSegment.items(
      module: module,
      itemsBuilder: builder,
      builder: (context, items) => LayoutBuilder(
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
      settings: settings,
    );
  }

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
