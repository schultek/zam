import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../templates/template.dart';

final toggleVisibilityProvider = StateProvider((ref) => true);
final templateVisibilityProvider = StateProvider((ref) => true);

final editProvider = StateNotifierProvider<EditNotifier, EditState>((ref) => EditNotifier(ref));
final isEditingProvider = Provider((ref) => ref.watch(editProvider) != EditState.inactive);

enum EditState { inactive, widgetMode, layoutMode }

class EditNotifier extends StateNotifier<EditState> {
  EditNotifier(this.ref) : super(EditState.inactive);

  final Ref ref;

  void toggleEdit() {
    if (state == EditState.inactive) {
      _beginEdit();
    } else {
      _finishEdit();
    }
  }

  void endEditing() {
    if (state != EditState.inactive) {
      _finishEdit();
    }
  }

  void _startWiggle() {
    TemplateState.wiggleController?.repeat();
  }

  void _stopWiggle() {
    TemplateState.wiggleController?.stop();
  }

  void _beginEdit() {
    super.state = EditState.widgetMode;
    _startWiggle();
  }

  void toggleLayoutMode() {
    if (state == EditState.inactive) return;
    if (state == EditState.layoutMode) {
      _startWiggle();
      super.state = EditState.widgetMode;
    } else {
      _stopWiggle();
      super.state = EditState.layoutMode;
    }
  }

  void _finishEdit() {
    if (state == EditState.widgetMode) {
      _stopWiggle();
    }

    super.state = EditState.inactive;
  }

  @override
  set state(EditState value) {
    throw UnsupportedError('Do not set edit mode directly');
  }
}

final currentPageProvider = StateProvider((ref) => 0);
