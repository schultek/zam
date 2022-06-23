import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/chat/chat.module.dart';

final activeLayoutProvider = Provider((ref) {
  var layoutNotifier = ref.watch(_activeLayoutNotifierProvider);
  return layoutNotifier?.value;
});

final _activeLayoutNotifierProvider = ChangeNotifierProvider((ref) {
  var group = ref.watch(selectedGroupProvider);
  return group?.template.activeLayout;
});

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
