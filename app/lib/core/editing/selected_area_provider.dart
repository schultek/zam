import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/chat/chat.module.dart';

final activeLayoutProvider = StateNotifierProvider<LayoutNotifier, LayoutIdModel?>((ref) {
  var group = ref.watch(selectedGroupProvider);
  var notifier = group?.template.activeLayout;
  return LayoutNotifier(notifier);
});

class LayoutNotifier extends StateNotifier<LayoutIdModel?> {
  LayoutNotifier(this.notifier) : super(notifier?.value) {
    notifier?.addListener(onLayoutChanged);
  }

  final ValueNotifier<LayoutIdModel?>? notifier;

  void onLayoutChanged() {
    state = notifier?.value;
  }

  @override
  void dispose() {
    notifier?.removeListener(onLayoutChanged);
    super.dispose();
  }
}

final selectedAreaProvider = StateNotifierProvider<SelectArea, String?>((ref) => SelectArea(ref));

final isAreaSelectedProvider =
    Provider.family((ref, String id) => ref.watch(selectedAreaProvider.select((area) => area == id)));

class SelectArea extends StateNotifier<String?> {
  SelectArea(this.ref) : super(null) {
    ref.listen<LayoutIdModel?>(activeLayoutProvider, (_, next) {
      if (next == null) {
        selectWidgetAreaById(null);
      } else if (state == null || !next.hasAreaId(state!)) {
        selectWidgetAreaById(next.getAreaIdToFocus());
      }
    }, fireImmediately: true);
  }

  final Ref ref;

  void selectWidgetAreaById(String? id) async {
    if (super.state == id) return;
    super.state = id;
  }

  @override
  set state(String? value) {
    throw UnsupportedError('Do not set selected area directly');
  }

  @override
  String? get state => super.state;
}
