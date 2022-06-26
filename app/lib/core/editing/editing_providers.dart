import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../templates/template.dart';

final toggleVisibilityProvider = StateProvider((ref) => true);
final templateVisibilityProvider = StateProvider((ref) => true);

final editProvider = StateNotifierProvider<EditNotifier, bool>((ref) => EditNotifier(ref));
final isEditingProvider = Provider((ref) => ref.watch(editProvider));

class EditNotifier extends StateNotifier<bool> {
  EditNotifier(this.ref) : super(false);

  final Ref ref;

  void toggleEdit() {
    if (!state) {
      _beginEdit();
    } else {
      _finishEdit();
    }
  }

  void endEditing() {
    if (state) {
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
    super.state = true;
    _startWiggle();
  }

  void _finishEdit() {
    if (state) {
      _stopWiggle();
    }

    super.state = false;
  }

  @override
  set state(bool value) {
    throw UnsupportedError('Do not set edit mode directly');
  }
}
