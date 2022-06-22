import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';

class PotIcon extends StatelessWidget {
  const PotIcon({required this.id, Key? key}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    var pot = context.watch(splitPotProvider(id))!;
    if (pot.icon == null) {
      return Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(Icons.savings, size: 24, color: context.onSurfaceColor),
      );
    } else {
      return SizedBox(
        width: 30,
        height: 30,
        child: Center(
          child: Text(
            pot.icon!,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }
}
