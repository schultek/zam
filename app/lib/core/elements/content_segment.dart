import 'package:flutter/material.dart';

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
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context)? onNavigate;
  final void Function()? onTap;
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
          onTap?.call();
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
