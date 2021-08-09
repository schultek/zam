import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';
import 'package:tuple/tuple.dart';

typedef ItemAxisAnimation = Tuple2<AnimationController?, AnimationController?>;

class ItemOffsetAnimation extends Animation<Offset>
    with AnimationLazyListenerMixin, AnimationLocalListenersMixin, AnimationLocalStatusListenersMixin {
  ItemOffsetAnimation({
    required this.axisAnimation,
  });

  final ItemAxisAnimation axisAnimation;

  @override
  Offset get value => Offset(
        axisAnimation.item1?.value ?? 0.0,
        axisAnimation.item2?.value ?? 0.0,
      );

  @override
  void didStartListening() {
    axisAnimation.item1?.addListener(_maybeNotifyListeners);
    axisAnimation.item1?.addStatusListener(_maybeNotifyStatusListeners);
    axisAnimation.item2?.addListener(_maybeNotifyListeners);
    axisAnimation.item2?.addStatusListener(_maybeNotifyStatusListeners);
  }

  @override
  void didStopListening() {
    axisAnimation.item1?.removeListener(_maybeNotifyListeners);
    axisAnimation.item1?.removeStatusListener(_maybeNotifyStatusListeners);
    axisAnimation.item2?.removeListener(_maybeNotifyListeners);
    axisAnimation.item2?.removeStatusListener(_maybeNotifyStatusListeners);
  }

  /// Gets the status of this animation based on the [first] and [next] status.
  ///
  /// The default is that if the [next] animation is moving, use its status.
  /// Otherwise, default to [first].
  @override
  AnimationStatus get status {
    if (axisAnimation.item2?.status == AnimationStatus.forward ||
        axisAnimation.item2?.status == AnimationStatus.reverse) {
      return axisAnimation.item2!.status;
    }
    return axisAnimation.item1?.status ?? AnimationStatus.completed;
  }

  AnimationStatus? _lastStatus;
  void _maybeNotifyStatusListeners(AnimationStatus _) {
    if (status != _lastStatus) {
      _lastStatus = status;
      notifyStatusListeners(status);
    }
  }

  Offset? _lastValue;
  void _maybeNotifyListeners() {
    if (value != _lastValue) {
      _lastValue = value;
      notifyListeners();
    }
  }
}
