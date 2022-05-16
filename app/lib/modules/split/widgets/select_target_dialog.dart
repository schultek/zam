import 'dart:math';

import 'package:flutter/material.dart';
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
  late ExpenseTargetType type;

  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    if (widget.target == null) {
      amounts = {};
      type = ExpenseTargetType.percent;
    } else {
      amounts = {...widget.target!.amounts};
      type = widget.target!.type;
    }
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
    var currValue = amounts[id]!;
    if (type == ExpenseTargetType.percent) {
      value = min(100, max(0, value));
      var rest = 100 - value;
      var factor = rest == 0 ? 0 : rest / (100 - currValue);
      for (var key in amounts.keys) {
        updateAmount(key, amounts[key]! * factor);
      }
    } else if (type == ExpenseTargetType.shares) {
      value = max(0, value).roundToDouble();
    } else {
      value = min(widget.amount, max(0, value));
      var rest = widget.amount - value;
      var factor = rest == 0 ? 0 : rest / (widget.amount - currValue);
      for (var key in amounts.keys) {
        updateAmount(key, amounts[key]! * factor);
      }
    }
    updateAmount(id, value);
  }

  void updateAmount(String id, double value) {
    setState(() {
      value = round1000(value);
      amounts[id] = value;
      controllers[id]?.text = amountString(value);
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
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              addUserToTargets(user.key);
                              setState(() {});
                            },
                            icon: const Icon(Icons.add),
                          ),
                          minLeadingWidth: 10,
                          onTap: () {
                            addUserToTargets(user.key);
                            setState(() {});
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
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
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
        ),
        AlertDialog(
          alignment: Alignment.center,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          clipBehavior: Clip.antiAlias,
          content: SizedBox(
            width: 400,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 400),
              child: AnimatedSize(
                alignment: Alignment.topCenter,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Form(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      if (amounts.isEmpty)
                        Center(
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
                      for (var key in amounts.keys)
                        Builder(builder: (context) {
                          var user = context.read(groupUserByIdProvider(key))!;
                          return ListTile(
                            title: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(user.nickname ?? context.tr.anonymous),
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: textControllerFor(key),
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
                                    onSubmitted: (value) {
                                      if (value.isEmpty) {
                                        textControllerFor(key).text = amountString(amounts[key]!);
                                      } else {
                                        onChangedAmount(key, double.parse(value));
                                      }
                                      if (amounts.keys.last != key) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    textInputAction: amounts.keys.last == key ? null : TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                IconButton(
                                  splashRadius: 25,
                                  visualDensity: VisualDensity.compact,
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              splashRadius: 25,
              icon: const Icon(Icons.add),
              onPressed: () {
                showAddUserDialog();
              },
            ),
            TextButton(
              child: Text(context.tr.save),
              onPressed: saveTarget,
            )
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
        ),
      ],
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
        Text(label, style: context.theme.textTheme.caption),
        const SizedBox(height: 8),
        FloatingActionButton(
          shape: selected ? CircleBorder(side: BorderSide(color: context.onSurfaceHighlightColor)) : null,
          backgroundColor: context.surfaceColor,
          foregroundColor: context.onSurfaceHighlightColor,
          child: Icon(icon),
          onPressed: onSelect,
        ),
      ],
    );
  }
}
