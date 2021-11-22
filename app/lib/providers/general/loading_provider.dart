import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../links/links_provider.dart';
import '../trips/trips_provider.dart';
import 'preferences_provider.dart';

final isLoadingProvider = Provider((ref) {
  return ref.watch(tripsProvider.select((t) => t is AsyncLoading)) ||
      ref.watch(sharedPreferencesProvider.select((p) => p is AsyncLoading)) ||
      ref.watch(linkStateProvider.select((s) => s is LoadingLinkState));
});
