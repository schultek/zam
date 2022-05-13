import 'dart:ui';

import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../themes/themes.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({
    required this.title,
    required this.content,
    this.actions = const [],
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    Key? key,
  }) : super(key: key);

  static Future<bool> confirm(BuildContext context, String text) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => SettingsDialog(
            title: Text(context.tr.confirm),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(text),
            ),
            actions: [
              TextButton(
                child: Text(context.tr.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(context.tr.confirm),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
            insetPadding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
          ),
          useRootNavigator: false,
          barrierColor: Colors.black26,
        ) ??
        false;
  }

  final Widget title;
  final Widget content;
  final List<Widget> actions;
  final EdgeInsets insetPadding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: insetPadding,
      child: ThemedSurface(
        preference: const ColorPreference(deltaElevation: 2),
        builder: (context, color) => ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: color.withOpacity(0.3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 20),
                    child: DefaultTextStyle(
                      style: DialogTheme.of(context).titleTextStyle ?? Theme.of(context).textTheme.headline6!,
                      child: title,
                    ),
                  ),
                  DefaultTextStyle(
                    style: DialogTheme.of(context).contentTextStyle ?? Theme.of(context).textTheme.subtitle1!,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: content,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions.intersperse(const SizedBox(width: 5)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
