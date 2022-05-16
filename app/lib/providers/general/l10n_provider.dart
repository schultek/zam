import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final l10nStateProvider = StateProvider<AppLocalizations?>((ref) => null);

final l10nProvider = Provider<AppLocalizations>((ref) => ref.watch(l10nStateProvider)!);
