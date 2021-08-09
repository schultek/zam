import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'item_animation.dart';

final itemTranslationProvider = StateProvider.family((ref, Key key) => const ItemAxisAnimation(null, null));

final itemAnimationProvider = Provider.family(
    (ref, Key key) => ItemOffsetAnimation(axisAnimation: ref.watch(itemTranslationProvider(key)).state));
