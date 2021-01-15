// ignore: import_of_legacy_library_into_null_safe
import 'package:rive/rive.dart';

class TheButtonAnimationController extends RiveAnimationController<RuntimeArtboard> {
  late LinearAnimationInstance _instance;
  double targetTime = 0;

  TheButtonAnimationController();

  void jumpTo(double target) {
    _instance.time = target;
    animateTo(target);
  }

  void animateTo(double target) {
    targetTime = target;
    isActive = true;
  }

  @override
  bool init(RuntimeArtboard artboard) {
    var animation = artboard.animations.firstWhere((a) => a.name == "Fill");
    _instance = LinearAnimationInstance(animation as LinearAnimation);
    return isActive = true;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    _instance.animation.apply(_instance.time, coreContext: artboard);

    if (targetTime == _instance.time) {
      isActive = false;
      return;
    } else if (targetTime < _instance.time) {
      _instance.direction = -1;
      _instance.animation.speed = 1;
    } else if (targetTime > _instance.time) {
      _instance.direction = 1;
      _instance.animation.speed = 0.1;
    }

    _instance.advance(elapsedSeconds);
    if (_instance.direction == -1 && _instance.time <= targetTime) {
      jumpTo(targetTime);
    } else if (_instance.direction == 1 && _instance.time >= targetTime) {
      jumpTo(targetTime);
    }
  }

  @override
  void dispose() {}

  @override
  void onActivate() {}

  @override
  void onDeactivate() {}
}
