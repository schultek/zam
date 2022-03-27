import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final toggleVisibilityProvider = StateProvider((ref) => true);

final transitionControllerProvider = StateProvider<AnimationController?>((ref) => null);
final wiggleControllerProvider = StateProvider<AnimationController?>((ref) => null);

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

  void _startWiggle() {
    ref.read(wiggleControllerProvider)!.repeat();
    ref.read(transitionControllerProvider)!.forward();
  }

  void _stopWiggle(Function() onComplete) {
    ref.read(transitionControllerProvider)!.reverse().whenComplete(() {
      ref.read(wiggleControllerProvider)!.stop();
      onComplete();
    });
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
      _stopWiggle(() {
        super.state = EditState.layoutMode;
      });
    }
  }

  void _finishEdit() {
    if (state == EditState.widgetMode) {
      _stopWiggle(() {});
    }

    super.state = EditState.inactive;
  }

  @override
  set state(EditState value) {
    throw UnsupportedError('Do not set edit mode directly');
  }
}

final currentPageProvider = StateProvider((ref) => 0);
