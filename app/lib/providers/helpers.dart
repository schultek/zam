import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamNotifier<T> extends StateNotifier<T> {
  late final StreamSubscription<T> _subscription;

  StreamNotifier.from(
    Stream<T> stream, {
    required T initialValue,
    void Function(T)? onValue,
  }) : super(initialValue) {
    onValue?.call(initialValue);
    _subscription = stream.listen((value) {
      onValue?.call(value);
      state = value;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class CombinedStream<A, B, R> extends StreamView<R> {
  CombinedStream(
    Stream<A> streamOne,
    Stream<B> streamTwo,
    R Function(A a, B b) combiner,
  ) : super(_buildController([streamOne, streamTwo], (List<dynamic> values) => combiner(values[0] as A, values[1] as B))
            .stream);

  static StreamController<R> _buildController<T, R>(
    Iterable<Stream<T>> streams,
    R Function(List<T> values) combiner,
  ) {
    if (streams.isEmpty) {
      return StreamController<R>()..close();
    }

    var len = streams.length;
    late List<StreamSubscription<dynamic>> subscriptions;
    late StreamController<R> controller;

    return controller = StreamController<R>(
      sync: true,
      onListen: () {
        var values = List<T?>.filled(len, null);
        var triggered = 0, completed = 0, index = 0;

        bool allHaveEvent() => triggered == len;

        void onDone() {
          if (++completed == len) controller.close();
        }

        void Function(T value) onUpdate(int index) => (T value) => values[index] = value;

        subscriptions = streams.map((stream) {
          var onUpdateForStream = onUpdate(index++);
          var hasFirstEvent = false;

          return stream.listen(
            (T value) {
              onUpdateForStream(value);

              if (!hasFirstEvent) {
                hasFirstEvent = true;
                triggered++;
              }

              if (allHaveEvent()) {
                try {
                  controller.add(combiner(List<T>.unmodifiable(values)));
                } catch (e, s) {
                  controller.addError(e, s);
                }
              }
            },
            onError: controller.addError,
            onDone: onDone,
          );
        }).toList(growable: false);
      },
      onPause: () {
        for (var s in subscriptions) {
          s.pause();
        }
      },
      onResume: () {
        for (var s in subscriptions) {
          s.resume();
        }
      },
      onCancel: () => Future.wait<dynamic>(subscriptions.map((subscription) => subscription.cancel())),
    );
  }
}
