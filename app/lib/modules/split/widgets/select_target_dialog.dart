import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';

class SelectTargetDialog extends StatefulWidget {
  const SelectTargetDialog({required this.target, required this.amount, required this.currency, Key? key})
      : super(key: key);

  final ExpenseTarget? target;
  final double amount;
  final Currency currency;

  @override
  State<SelectTargetDialog> createState() => _SelectTargetDialogState();

  static Future<ExpenseTarget?> show(BuildContext context, ExpenseTarget? target, double amount, Currency currency) {
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) => SelectTargetDialog(target: target, amount: amount, currency: currency),
    );
  }
}

class _SelectTargetDialogState extends State<SelectTargetDialog> {
  late Map<String, double> amounts;
  late Map<String, FocusNode> focusNodes;
  late ExpenseTargetType type;

  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    if (widget.target == null) {
      amounts = {};
      focusNodes = {};
      type = ExpenseTargetType.percent;
    } else {
      amounts = {...widget.target!.amounts};
      focusNodes = amounts.map((key, _) => MapEntry(key, createFocusNode(key)));
      type = widget.target!.type;
    }
  }

  final _currentEdited = <String>{};

  FocusNode createFocusNode(String key) {
    var focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasPrimaryFocus) {
        var value = textControllerFor(key).text;
        if (value.isEmpty) {
          textControllerFor(key).text = amountString(amounts[key]!);
        } else {
          onChangedAmount(key, double.parse(value));
        }

        var isStillEditing = focusNodes.values.any((f) => f.hasPrimaryFocus);
        if (!isStillEditing) {
          _currentEdited.clear();
        }
      } else {
        var controller = textControllerFor(key);
        controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      }
    });
    return focusNode;
  }

  double get equalSplitAmount {
    return widget.amount / context.watch(selectedGroupProvider)!.users.length;
  }

  TextEditingController textControllerFor(String id) {
    return controllers[id] ??= TextEditingController(text: amountString(amounts[id]!));
  }

  void addUserToTargets(String id) {
    var amount = 0.0;
    if (amounts.isEmpty) {
      if (type == ExpenseTargetType.percent) {
        amount = 100;
      } else if (type == ExpenseTargetType.shares) {
        amount = 1;
      } else {
        amount = widget.amount;
      }
    } else {
      var length = amounts.length;
      if (type == ExpenseTargetType.percent) {
        amount = 100 / (length + 1);
        var delta = amount / length;
        for (var key in amounts.keys) {
          updateAmount(key, amounts[key]! - delta);
        }
      } else if (type == ExpenseTargetType.shares) {
        amount = 1;
      } else {
        amount = widget.amount / (length + 1);
        var delta = amount / length;
        for (var key in amounts.keys) {
          updateAmount(key, amounts[key]! - delta);
        }
      }
    }
    updateAmount(id, amount);
  }

  void deleteUserFromTargets(String id) {
    var amount = amounts[id]!;
    setState(() {
      amounts.remove(id);
      focusNodes.remove(id);
      _currentEdited.remove(id);
    });
    if (amounts.isNotEmpty) {
      var length = amounts.length;
      if (type == ExpenseTargetType.percent) {
        var delta = amount / length;
        for (var key in amounts.keys) {
          updateAmount(key, amounts[key]! + delta);
        }
      } else if (type == ExpenseTargetType.amount) {
        var delta = amount / length;
        for (var key in amounts.keys) {
          updateAmount(key, amounts[key]! + delta);
        }
      }
    }
  }

  void onChangedAmount(String id, double value) {
    _currentEdited.add(id);

    var unedited = amounts.keys.where((k) => !_currentEdited.contains(k));
    var edited = _currentEdited.where((k) => k != id);

    if (type == ExpenseTargetType.percent) {
      value = min(100, max(0, value));
      var available = 100.0 - edited.fold(0.0, (v, k) => v + amounts[k]!);
      var rest = available - value;
      if (rest < 0) {
        value = available;
        rest = 0;
      }
      if (unedited.isNotEmpty) {
        var currSum = unedited.fold<double>(0.0, (v, k) => v + amounts[k]!);
        for (var key in unedited) {
          if (currSum == 0) {
            updateAmount(key, rest / unedited.length);
          } else {
            var factor = amounts[key]! / currSum;
            updateAmount(key, rest * factor);
          }
        }
      } else if (rest != 0) {
        value = available;
      }
    } else if (type == ExpenseTargetType.shares) {
      value = max(0, value).roundToDouble();
    } else {
      value = min(widget.amount, max(0, value));
      var available = widget.amount - edited.fold(0.0, (v, k) => v + amounts[k]!);
      var rest = available - value;
      if (rest < 0) {
        value = available;
        rest = 0;
      }
      if (unedited.isNotEmpty) {
        var currSum = unedited.fold<double>(0.0, (v, k) => v + amounts[k]!);
        for (var key in unedited) {
          if (currSum == 0) {
            updateAmount(key, rest / unedited.length);
          } else {
            var factor = amounts[key]! / currSum;
            updateAmount(key, rest * factor);
          }
        }
      } else if (rest != 0) {
        value = available;
      }
    }
    updateAmount(id, value);
  }

  void updateAmount(String id, double value) {
    setState(() {
      value = round1000(value);
      amounts[id] = value;
      controllers[id]?.text = amountString(value);
      if (!focusNodes.containsKey(id)) {
        focusNodes[id] = createFocusNode(id);
      }
    });
  }

  void updateType(ExpenseTargetType type) {
    var currType = this.type;
    setState(() {
      this.type = type;
    });
    if (amounts.isEmpty) {
      return;
    }
    if (type == ExpenseTargetType.percent) {
      if (currType == ExpenseTargetType.shares) {
        var sumShares = amounts.values.reduce((a, b) => a + b);
        for (var key in amounts.keys) {
          updateAmount(key, amounts[key]! / sumShares * 100);
        }
      } else {
        for (var key in amounts.keys) {
          updateAmount(key, amounts[key]! / widget.amount * 100);
        }
      }
    } else if (type == ExpenseTargetType.shares) {
      var factor = mgcd(amounts.values.map((v) => (v * 100).floor()).toList());
      for (var key in amounts.keys) {
        updateAmount(key, factor == 0 ? 1 : (amounts[key]! * 100).floor() / factor);
      }
    } else {
      if (type == ExpenseTargetType.percent) {
        for (var key in amounts.keys) {
          updateAmount(key, widget.amount * amounts[key]! / 100);
        }
      } else {
        var sumShares = amounts.values.reduce((a, b) => a + b);
        for (var key in amounts.keys) {
          updateAmount(key, widget.amount * amounts[key]! / sumShares);
        }
      }
    }
  }

  String amountString(num amount) {
    if (type == ExpenseTargetType.percent || type == ExpenseTargetType.amount) {
      return amount.toStringAsFixed(2);
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  void saveTarget() {
    Navigator.of(context).pop(ExpenseTarget(amounts: amounts, type: type));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 400),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
                    child: Material(
                      color: Theme.of(context).dialogBackgroundColor,
                      elevation: 24,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      type: MaterialType.card,
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        width: 400,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                              child: AnimatedSize(
                                alignment: Alignment.topCenter,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: Form(
                                  child: ListView(
                                    padding: const EdgeInsets.only(top: 8),
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      if (amounts.isEmpty)
                                        Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              showAddUserDialog();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(30),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(context.tr.for_everyone, style: context.theme.textTheme.caption),
                                                  Text(
                                                    '${equalSplitAmount.toStringAsFixed(2)} ${widget.currency.symbol}',
                                                    style: context.theme.textTheme.headline6,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      for (var key in amounts.keys)
                                        Builder(builder: (context) {
                                          var user = context.read(groupUserByIdProvider(key))!;
                                          return ListTile(
                                            contentPadding:
                                                const EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 8),
                                            title: Row(
                                              children: [
                                                Flexible(
                                                  fit: FlexFit.tight,
                                                  child: Text(user.nickname ?? context.tr.anonymous),
                                                ),
                                                Flexible(
                                                  child: TextField(
                                                    controller: textControllerFor(key),
                                                    focusNode: focusNodes[key],
                                                    inputFormatters: [
                                                      TextInputFormatter.withFunction((old, newVal) => TextEditingValue(
                                                          text: newVal.text.replaceAll(',', '.'),
                                                          selection: newVal.selection)),
                                                    ],
                                                    decoration: InputDecoration(
                                                      border: const OutlineInputBorder(),
                                                      isDense: true,
                                                      suffixIcon: Text(type == ExpenseTargetType.percent
                                                          ? '%'
                                                          : type == ExpenseTargetType.amount
                                                              ? widget.currency.symbol
                                                              : ''),
                                                      suffixIconConstraints: const BoxConstraints(minWidth: 20),
                                                    ),
                                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                    textInputAction:
                                                        amounts.keys.last == key ? null : TextInputAction.next,
                                                    onSubmitted: (value) {
                                                      if (amounts.keys.last != key) {
                                                        focusNodes[amounts.keys
                                                                .elementAt(amounts.keys.toList().indexOf(key) + 1)]
                                                            ?.requestFocus();
                                                      }
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                IconButton(
                                                  splashRadius: 25,
                                                  onPressed: () {
                                                    deleteUserFromTargets(key);
                                                  },
                                                  icon: const Icon(Icons.delete),
                                                ),
                                              ],
                                            ),
                                            leading: UserAvatar(id: key, small: true),
                                            minLeadingWidth: 10,
                                          );
                                        }),
                                      if (context.read(selectedGroupProvider)!.users.length > amounts.length)
                                        ListTile(
                                          contentPadding: const EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 8),
                                          title: Row(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                    width: 50,
                                                    height: 16,
                                                    color: context.onSurfaceColor.withOpacity(0.1),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Opacity(
                                                  opacity: 0.8,
                                                  child: TextField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      border: const OutlineInputBorder(),
                                                      isDense: true,
                                                      suffixIcon: Text(
                                                        type == ExpenseTargetType.percent
                                                            ? '%'
                                                            : type == ExpenseTargetType.amount
                                                                ? widget.currency.symbol
                                                                : '',
                                                        style:
                                                            TextStyle(color: context.onSurfaceColor.withOpacity(0.5)),
                                                      ),
                                                      suffixIconConstraints: const BoxConstraints(minWidth: 20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              IconButton(
                                                splashRadius: 25,
                                                onPressed: showAddUserDialog,
                                                icon: const Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                          leading: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: context.onSurfaceColor.withOpacity(0.1),
                                          ),
                                          minLeadingWidth: 10,
                                          onTap: showAddUserDialog,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    splashRadius: 25,
                                    icon: const Icon(Icons.bookmarks),
                                    onPressed: showTemplateDialog,
                                  ),
                                  IconButton(
                                    splashRadius: 25,
                                    icon: const Icon(Icons.bookmark_add),
                                    onPressed: amounts.isNotEmpty ? showSaveTemplateDialog : null,
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    child: Text(context.tr.save),
                                    onPressed: saveTarget,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Material(
                  color: Colors.transparent,
                  child: ThemedSurface(
                    builder: (context, color) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _modeToggle(
                          label: context.tr.percent,
                          icon: Icons.percent,
                          selected: type == ExpenseTargetType.percent,
                          onSelect: () {
                            updateType(ExpenseTargetType.percent);
                          },
                        ),
                        const SizedBox(width: 16),
                        _modeToggle(
                          label: context.tr.shares,
                          icon: Icons.onetwothree,
                          selected: type == ExpenseTargetType.shares,
                          onSelect: () {
                            updateType(ExpenseTargetType.shares);
                          },
                        ),
                        const SizedBox(width: 16),
                        _modeToggle(
                          label: context.tr.amount,
                          icon: Icons.numbers,
                          selected: type == ExpenseTargetType.amount,
                          onSelect: () {
                            updateType(ExpenseTargetType.amount);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeToggle({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onSelect,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.theme.textTheme.caption!.copyWith(
            color: context.groupTheme.dark ? context.onSurfaceColor : context.surfaceColor,
          ),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          shape: selected ? CircleBorder(side: BorderSide(color: context.onSurfaceHighlightColor, width: 2)) : null,
          backgroundColor: context.surfaceColor,
          foregroundColor: context.onSurfaceHighlightColor,
          child: Icon(icon),
          onPressed: onSelect,
        ),
      ],
    );
  }

  void showAddUserDialog() {
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.antiAlias,
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 400,
          child: StatefulBuilder(
            builder: (context, setState) => AnimatedSize(
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  for (var user in context.read(selectedGroupProvider)!.users.entries)
                    if (!amounts.containsKey(user.key))
                      ListTile(
                        leading: UserAvatar(id: user.key, small: true),
                        title: Text(user.value.nickname ?? context.tr.anonymous),
                        trailing: IconButton(
                          splashRadius: 25,
                          onPressed: () {
                            addUserToTargets(user.key);
                            setState(() {});
                            if (!context.read(selectedGroupProvider)!.users.keys.any((k) => !amounts.containsKey(k))) {
                              Navigator.of(context).pop();
                            }
                          },
                          icon: Icon(Icons.add, color: context.onSurfaceColor),
                        ),
                        minLeadingWidth: 10,
                        onTap: () {
                          addUserToTargets(user.key);
                          setState(() {});
                          if (!context.read(selectedGroupProvider)!.users.keys.any((k) => !amounts.containsKey(k))) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text(context.tr.ok),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void showSaveTemplateDialog() {
    String name = '';

    Future<void> save() async {
      await context
          .read(splitLogicProvider)
          .addNewTemplate(SplitTemplate(name, ExpenseTarget(amounts: {...amounts}, type: type)));
    }

    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          title: Text(context.tr.save_as_template),
          content: TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: context.tr.name,
            ),
            onChanged: (value) {
              setState(() => name = value);
            },
            onSubmitted: (_) async {
              await save();
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              child: Text(context.tr.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(context.tr.save),
              onPressed: name.isNotEmpty
                  ? () async {
                      await save();

                      Navigator.pop(context);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void showTemplateDialog() async {
    var template = await showDialog<SplitTemplate>(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.antiAlias,
        title: Text(context.tr.select_template),
        titlePadding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 400,
          child: AnimatedSize(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                for (var template
                    in context.watch(splitProvider.select((s) => s.value?.templates ?? <SplitTemplate>[])))
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 8),
                    leading: const Icon(Icons.bookmark),
                    title: Text(template.name),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      if (template.target.amounts.length == 1) ...[
                        Text(context.watch(groupUserByIdProvider(template.target.amounts.keys.first))?.nickname ??
                            context.tr.anonymous),
                        const SizedBox(width: 10),
                        UserAvatar(id: template.target.amounts.keys.first, small: true),
                      ] else
                        Text('${template.target.amounts.length} ${context.tr.persons}'),
                      const SizedBox(width: 5),
                      IconButton(
                        splashRadius: 25,
                        icon: Icon(Icons.delete, color: context.onSurfaceColor),
                        onPressed: () {
                          context.read(splitLogicProvider).removeTemplate(template);
                        },
                      )
                    ]),
                    minLeadingWidth: 10,
                    onTap: () {
                      Navigator.pop(context, template);
                    },
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text(context.tr.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );

    if (template != null) {
      setState(() {
        _currentEdited.clear();
        focusNodes.clear();
        amounts.clear();
        for (var e in template.target.amounts.entries) {
          updateAmount(e.key, e.value);
        }
        type = template.target.type;
      });
    }
  }
}
