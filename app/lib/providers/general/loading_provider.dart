import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../groups/groups_provider.dart';
import '../links/links_provider.dart';
import '../links/shortcuts_provider.dart';
import 'preferences_provider.dart';

final isLoadingProvider = Provider((ref) {
  return ref.watch(groupsProvider.select((t) => t is AsyncLoading)) ||
      ref.watch(sharedPreferencesProvider.select((p) => p is AsyncLoading)) ||
      ref.watch(linkStateProvider.select((s) => s is LoadingLinkState)) ||
      ref.watch(delaySplashScreenProvider);
});
