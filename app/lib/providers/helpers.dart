import 'package:flutter_riverpod/flutter_riverpod.dart';

extension CachedAsyncValueProvider<T> on AlwaysAliveProviderBase<AsyncValue<T>> {
  Provider<AsyncValue<T>> get cached {
    return Provider<AsyncValue<T>>((ref) {
      ref.listen<AsyncValue<T>>(this, (_, value) {
        if (value is! AsyncLoading) {
          ref.state = value;
        }
      });

      return ref.read(this);
    });
  }
}
