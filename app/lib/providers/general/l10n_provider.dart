import 'dart:io';
import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final l10nFutureProvider = FutureProvider<AppLocalizations>((ref) {
  var locale = Locale(Platform.localeName.split('_')[0]);
  try {
    return AppLocalizations.delegate.load(locale);
  } catch (_) {
    return AppLocalizations.delegate.load(const Locale('de'));
  }
});

final l10nStateProvider = StateProvider<AppLocalizations?>((ref) => ref.watch(l10nFutureProvider).value);
final l10nProvider = Provider<AppLocalizations>((ref) => ref.watch(l10nStateProvider)!);
