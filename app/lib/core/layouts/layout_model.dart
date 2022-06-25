import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/groups/logic_provider.dart';
import '../templates/templates.dart';
import '../widgets/layout_preview.dart';
import 'drops_layout.dart';
import 'focus_layout.dart';
import 'full_page_layout.dart';
import 'grid_layout.dart';

@MappableClass(discriminatorKey: 'type')
abstract class LayoutModel {
  const LayoutModel();

  String get name;
  Widget builder(LayoutContext context);

  PreviewPage preview({Widget? header});

  List<Widget> settings(BuildContext context, void Function(LayoutModel) update) => [];

  String? getAreaIdToFocus();
  bool hasAreaId(String id);

  static List<LayoutModel> get all => const [
        GridLayoutModel(),
        FocusLayoutModel(),
        DropsLayoutModel(),
        FullPageLayoutModel(),
      ];
}

class LayoutContext {
  final String _id;
  final Widget? header;
  final BuildContext context;
  final TemplateModel Function(LayoutModel updated) onUpdate;

  LayoutContext({
    required String id,
    this.header,
    required this.context,
    required this.onUpdate,
  }) : _id = id;

  Future<void> update(LayoutModel updated) async {
    await context.read(groupsLogicProvider).updateTemplateModel(onUpdate(updated));
  }

  String idFor(String areaId) {
    return '${_id}_$areaId';
  }
}
