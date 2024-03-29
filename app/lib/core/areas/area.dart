import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../modules/modules.dart';
import '../../providers/groups/logic_provider.dart';
import '../../providers/groups/selected_group_provider.dart';
import '../editing/editing_providers.dart';
import '../editing/selected_area_provider.dart';
import '../elements/elements.dart';
import '../module/module_context.dart';
import '../reorderable/items_provider.dart';
import '../templates/templates.dart';
import '../themes/themes.dart';

class InheritedArea<T extends ModuleElement> extends InheritedWidget {
  final AreaState<Area<T>, T> state;

  const InheritedArea({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedArea oldWidget) => true;
}

final areaModulesProvider = Provider.family<List<String>, String>(
  (ref, String id) {
    var group = ref.watch(selectedGroupProvider);
    var modules = (group?.modules[id] ?? [])
        .where((id) => !(group?.moduleBlacklist ?? []).contains(ModuleContext.getModuleId(id)))
        .toList();
    return DeepEqualityList(modules);
  },
);

class DeepEqualityList<T> extends DelegatingList<T> {
  DeepEqualityList(List<T> base) : super(base);

  @override
  bool operator ==(Object other) => const DeepCollectionEquality().equals(this, other);

  @override
  int get hashCode => const DeepCollectionEquality().hash(this);
}

abstract class Area<T extends ModuleElement> extends StatefulWidget {
  final String id;
  const Area(this.id, {Key? key}) : super(key: key);

  static AreaState<Area<T>, T>? of<T extends ModuleElement>(BuildContext context) {
    assert(T != ModuleElement, 'WidgetArea.of was called with default type parameter. This is probably not right.');

    if (context is StatefulElement && context.state is AreaState<Area<T>, T>) {
      return context.state as AreaState<Area<T>, T>;
    }

    var element = context.getElementForInheritedWidgetOfExactType<InheritedArea<T>>();
    return element != null ? (element.widget as InheritedArea<T>).state : null;
  }
}

abstract class AreaState<U extends Area<T>, T extends ModuleElement> extends State<U>
    with AutomaticKeepAliveClientMixin {
  bool _isInitialized = false;

  String get id => widget.id;

  final _areaKey = GlobalKey();

  RenderBox? _areaRenderBox;

  bool get hasSize => _areaRenderBox != null;
  Size get areaSize => _areaRenderBox!.size;
  Offset get areaOffset => _areaRenderBox!.localToGlobal(Offset.zero);

  GroupThemeData get theme => context.groupTheme;
  TemplateState get template => Template.of(context, listen: false);

  bool get isActive => _isActive;
  bool _isActive = true;

  @override
  bool get wantKeepAlive => false;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool get isEditing => context.watch(isEditingProvider);
  bool get isSelected => isEditing && context.watch(isAreaSelectedProvider(id));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    _isInitialized = true;
    reload();
    context.listen(areaModulesProvider(id), (_, __) {
      Future.microtask(reload);
    });
  }

  @override
  void activate() {
    super.activate();
    _isActive = true;
  }

  @override
  void deactivate() {
    _isActive = false;
    super.deactivate();
  }

  Future<void> reload() async {
    if (!mounted || !isActive) return;
    setState(() {});
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      if (!mounted || !isActive) return;
      var widgets = await _getWidgetsForArea();
      initArea(widgets);
      _isLoading = false;
      if (mounted) setState(() {});
    });
  }

  Future<List<T>> _getWidgetsForArea() async {
    var selectedModules = context.read(areaModulesProvider(widget.id));
    var elements = await Future.wait(selectedModules.map((id) async => await registry.getWidget<T>(context, id)));
    return elements.whereNotNull().toList();
  }

  void initArea(List<T> widgets);

  void updateAreaRenderBox(_) {
    var renderBox = _areaKey.currentContext?.findRenderObject();
    if (renderBox != null) _areaRenderBox = renderBox as RenderBox;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var templateState = Template.of(context, listen: false);
    templateState.registerArea(this);

    var highlightColor = context.onSurfaceHighlightColor;

    var backgroundColor = highlightColor.withOpacity(0.05);
    var borderColor = highlightColor.withOpacity(0.5);

    WidgetsBinding.instance!.addPostFrameCallback(updateAreaRenderBox);

    return InheritedArea(
      state: this,
      child: GestureDetector(
        key: ValueKey(id + '-listener'),
        behavior: HitTestBehavior.deferToChild,
        onTap: isEditing
            ? () {
                context.read(selectedAreaProvider.notifier).selectWidgetAreaById(id);
              }
            : null,
        child: Container(
          margin: getMargin(),
          decoration: BoxDecoration(
            color: isSelected ? backgroundColor : Colors.transparent,
            borderRadius: BorderRadius.all(getRadius()),
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned.fill(
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: isSelected || isEditing ? borderColor : Colors.transparent,
                  dashPattern: isSelected ? [100, 0] : [4, 8],
                  strokeWidth: 1,
                  radius: getRadius(),
                  child: Container(),
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Container(
                  key: _areaKey,
                  child: buildArea(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildArea(BuildContext context);

  EdgeInsets getMargin() => EdgeInsets.zero;
  EdgeInsets getPadding() => const EdgeInsets.all(10);
  Radius getRadius() => const Radius.circular(20);

  BoxConstraints constrainWidget(T? widget);

  void removeWidget(Key key) {
    setState(() {
      var widget = getWidgetFromKey(key);
      removeItem(key);
      widget.onRemoved(context);
    });
    updateWidgetsInGroup();
  }

  void removeWidgetWithParams(dynamic params) {
    for (var w in getWidgets().where((w) => ModuleId.equalParams(w.id, params))) {
      removeWidget(w.key);
    }
  }

  Future<void> updateWidgetsInGroup() async {
    context.read(groupsLogicProvider).updateGroup({
      'modules.$id': getWidgets().map((w) => w.id).toList(),
    });
  }

  void onDrop() {
    updateWidgetsInGroup();
  }

  void cancelDrop(Key key) {
    setState(() {
      removeItem(key);
    });
  }

  V callTyped<V>(V Function<E extends ModuleElement>() fn) {
    return fn<T>();
  }

  ReorderableItemLogic get _logic => context.read(reorderableItemProvider);

  Offset getOffset(Key key) => _logic.itemOffset(key);
  Size getSize(Key key) => _logic.itemSize(key);
  bool hasItem(Key key) => _logic.hasItem(key);
  void addOffset(Key key, Offset offset) => _logic.addArtificialOffset(key, offset);
  void translateX(Key key, double delta) => _logic.translateItemX(this, key, delta);
  void translateY(Key key, double delta) => _logic.translateItemY(this, key, delta);

  bool isOverArea(Offset offset, Size size) {
    var areaRect = Rect.fromLTWH(areaOffset.dx, areaOffset.dy, areaSize.width, areaSize.height);
    var itemRect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    return itemRect.overlaps(areaRect);
  }

  bool didInsertItem(Offset offset, T item, [bool force = false]) {
    if (!force && !isOverArea(offset, getSize(item.key))) {
      if (hasKey(item.key)) {
        cancelDrop(item.key);
      }
      return false;
    }

    if (hasKey(item.key)) {
      reorderItem(offset, item.key);
      return true;
    }

    if (!canInsertItem(item)) {
      return false;
    }

    insertItem(offset, item);
    reorderItem(offset, item.key);
    return true;
  }

  void reorderItem(Offset offset, Key key) {
    if (!hasKey(key)) {
      return;
    }

    Offset? reorderOffset;
    do {
      reorderOffset = didReorderItem(offset, key);
      if (reorderOffset != null) addOffset(key, reorderOffset);
    } while (reorderOffset != null);
  }

  List<T> getWidgets();
  T getWidgetFromKey(Key key);
  void removeItem(Key key);
  Offset? didReorderItem(Offset offset, Key itemKey);
  bool canInsertItem(T item) => true;
  void insertItem(Offset offset, T item);
  bool hasKey(Key key);

  ElementDecorator<T> get elementDecorator;

  Widget safeConstrainChild({T? element, required Widget child}) {
    if (hasSize) {
      return ConstrainedBox(
        constraints: constrainWidget(element),
        child: child,
      );
    } else {
      var completer = Completer();
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        completer.complete();
      });
      return FutureBuilder(
        future: completer.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return safeConstrainChild(element: element, child: child);
          } else {
            return const SizedBox(width: 10, height: 10);
          }
        },
      );
    }
  }
}
