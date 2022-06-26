import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/themes/theme_model.dart';
import '../../helpers/capture_widget.dart';
import '../../main.mapper.g.dart';
import '../general/preferences_provider.dart';
import '../groups/selected_group_provider.dart';

final shortcutsProvider = Provider((ref) => ShortcutsLogic(ref));
final launchThemeProvider = StateProvider<LaunchTheme?>((ref) => null);
final delaySplashScreenProvider = StateProvider<bool>((ref) => false);

@MappableClass()
class LaunchTheme with Mappable {
  final String name;
  final ThemeModel theme;

  LaunchTheme(this.name, this.theme);
}

class ShortcutsLogic {
  final Ref ref;
  ShortcutsLogic(this.ref) {
    channel.setMethodCallHandler(this);
  }

  final channel = const MethodChannel('de.schultek.jufa.shortcuts');

  Future<void> pinShortcut(
      {required String id, required String name, required ThemeModel theme, required Widget widget}) async {
    var data = await CaptureWidget.offStage(widget);
    var prefs = await ref.read(sharedPreferencesProvider.future);
    prefs.setString('shortcut-$id', Mapper.toJson(LaunchTheme(name, theme)));
    await channel.invokeMethod('pinShortcut', {'id': id, 'name': name, 'iconData': data});
  }

  Future<void> checkIsLaunchedFromShortcut() async {
    var value = await channel.invokeMethod<String>('isLaunchedFromShortcut');
    if (value is String) {
      await onShortcutLaunched(value);
    }
    FlutterNativeSplash.remove();
  }

  Future<void> onShortcutLaunched(String value) async {
    var uri = Uri.parse(value);
    if (uri.scheme == 'jufa' && uri.host == 'shortcut' && uri.queryParameters['id'] != null) {
      var id = uri.queryParameters['id']!;
      var prefs = await ref.read(sharedPreferencesProvider.future);

      var shortcutData = prefs.getString('shortcut-$id');
      if (shortcutData != null) {
        var launchTheme = Mapper.fromJson<LaunchTheme>(shortcutData);
        ref.read(launchThemeProvider.notifier).state = launchTheme;
        ref.read(delaySplashScreenProvider.notifier).state = true;
        unawaited(Future.delayed(const Duration(milliseconds: 1000), () {
          ref.read(delaySplashScreenProvider.notifier).state = false;
        }));
      }

      unawaited(Future.microtask(() {
        ref.read(selectedGroupIdProvider.notifier).state = id;
      }));
    }
  }

  Future<dynamic> call(MethodCall call) async {
    switch (call.method) {
      case 'shortcutLaunched':
        var value = call.arguments;
        if (value is String) onShortcutLaunched(value);
    }
  }
}
