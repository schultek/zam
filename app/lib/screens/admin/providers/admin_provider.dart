import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/providers.dart';

final adminApiProvider = Provider((ref) => ref.watch(apiProvider).admin);
