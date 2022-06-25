import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/chat/chat.module.dart';

final activeLayoutProvider = StateProvider<LayoutIdModel?>((ref) => null);

final selectedAreaProvider = StateNotifierProvider<SelectArea, String?>((ref) => SelectArea(ref));

final isAreaSelectedProvider =
    Provider.family((ref, String id) => ref.watch(selectedAreaProvider.select((area) => area == id)));

class SelectArea extends StateNotifier<String?> {
  SelectArea(this.ref) : super(null) {
    ref.listen<LayoutIdModel?>(activeLayoutProvider, (_, next) {
      print("GOT LAYOUT ${next?.id}");
      if (next == null) {
        selectWidgetAreaById(null);
      } else if (state == null || !next.hasAreaId(state!)) {
        selectWidgetAreaById(next.getAreaIdToFocus());
      }
    }, fireImmediately: true);
  }

  final Ref ref;

  void selectWidgetAreaById(String? id) async {
    print("SELECT AREA $id");
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
