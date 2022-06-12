import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import 'pot_icon.dart';
import 'select_source_dialog.dart';
import 'select_target_dialog.dart';

enum TargetsMode { fromPot, fromSourcetoSource, fromSourcetoTargets }

class TargetsSection extends StatelessWidget {
  const TargetsSection._({
    required this.mode,
    this.fromSource,
    this.toSource,
    this.toTarget,
    required this.onFromSourceChanged,
    this.onToSourceChanged,
    this.onToTargetChanged,
    this.amount,
    this.currency,
    Key? key,
  }) : super(key: key);

  factory TargetsSection.fromPot({
    final String? potId,
    required ValueChanged<String> onPotChanged,
  }) {
    return TargetsSection._(
      mode: TargetsMode.fromPot,
      fromSource: potId != null ? SplitSource.pot(potId) : null,
      onFromSourceChanged: (value) => onPotChanged(value.id),
    );
  }

  factory TargetsSection.fromToSource({
    final SplitSource? from,
    final SplitSource? to,
    required ValueChanged<SplitSource> onFromChanged,
    required ValueChanged<SplitSource> onToChanged,
  }) {
    return TargetsSection._(
      mode: TargetsMode.fromSourcetoSource,
      fromSource: from,
      onFromSourceChanged: onFromChanged,
      toSource: to,
      onToSourceChanged: onToChanged,
    );
  }

  factory TargetsSection.toTargets({
    final SplitSource? source,
    final ExpenseTarget? target,
    required ValueChanged<SplitSource> onSourceChanged,
    required ValueChanged<ExpenseTarget> onTargetsChanged,
    required double amount,
    required Currency currency,
  }) {
    return TargetsSection._(
      mode: TargetsMode.fromSourcetoTargets,
      fromSource: source,
      onFromSourceChanged: onSourceChanged,
      toTarget: target,
      onToTargetChanged: onTargetsChanged,
      amount: amount,
      currency: currency,
    );
  }

  final TargetsMode mode;
  final SplitSource? fromSource;
  final SplitSource? toSource;
  final ExpenseTarget? toTarget;
  final double? amount;
  final Currency? currency;

  final ValueChanged<SplitSource> onFromSourceChanged;
  final ValueChanged<SplitSource>? onToSourceChanged;
  final ValueChanged<ExpenseTarget>? onToTargetChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(children: [
      ListTile(
        title: Text(context.tr.from),
        trailing: fromSource != null
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                Text(context.watch(splitSourceLabelProvider(fromSource!))),
                const SizedBox(width: 10),
                if (fromSource!.isUser) UserAvatar(id: fromSource!.id, small: true) else PotIcon(id: fromSource!.id),
              ])
            : null,
        onTap: () async {
          var source = await SelectSourceDialog.show(
            context,
            fromSource,
            allowUsers: mode != TargetsMode.fromPot,
          );
          if (source != null) {
            onFromSourceChanged(source);
          }
        },
      ),
      if (mode == TargetsMode.fromSourcetoTargets)
        ListTile(
          title: Text(context.tr.to),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            if (toTarget!.amounts.isEmpty)
              Text('${context.watch(selectedGroupProvider.select((g) => g?.users.length ?? 0))} ${context.tr.persons}')
            else if (toTarget!.amounts.length == 1) ...[
              Text(
                  context.watch(groupUserByIdProvider(toTarget!.amounts.keys.first))?.nickname ?? context.tr.anonymous),
              const SizedBox(width: 10),
              UserAvatar(id: toTarget!.amounts.keys.first, small: true),
            ] else
              Text('${toTarget!.amounts.length} ${context.tr.persons}'),
          ]),
          onTap: () async {
            var target = await SelectTargetDialog.show(context, toTarget, amount!, currency!);
            if (target != null) {
              onToTargetChanged!(target);
            }
          },
        ),
      if (mode == TargetsMode.fromSourcetoSource)
        ListTile(
          title: Text(context.tr.to),
          trailing: toSource != null
              ? Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(context.watch(splitSourceLabelProvider(toSource!))),
                  const SizedBox(width: 10),
                  if (toSource!.isUser) UserAvatar(id: toSource!.id, small: true) else PotIcon(id: toSource!.id),
                ])
              : null,
          onTap: () async {
            var target = await SelectSourceDialog.show(context, toSource);
            if (target != null) {
              onToSourceChanged!(target);
            }
          },
        ),
    ]);
  }
}
