import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../split.module.dart';

class EditRatesDialog extends StatefulWidget {
  const EditRatesDialog({required this.rates, Key? key}) : super(key: key);

  final BillingRates? rates;

  @override
  State<EditRatesDialog> createState() => _EditRatesDialogState();

  static Future<BillingRates?> show(BuildContext context, BillingRates? rates) {
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) => EditRatesDialog(rates: rates),
    );
  }
}

class RateEntry {
  Currency currency;
  double sourceAmount;
  double targetAmount;

  RateEntry(this.currency, this.sourceAmount, this.targetAmount);
}

class _EditRatesDialogState extends State<EditRatesDialog> {
  late Currency target;
  List<RateEntry> rates = [];

  @override
  void initState() {
    super.initState();
    if (widget.rates != null) {
      target = widget.rates!.target;
      rates = widget.rates!.rates.entries.map((e) => RateEntry(e.key, e.value, 1)).toList();
    } else {
      target = Currency.euro;
    }
  }

  bool get canAddRate => rates.length < Currency.values.length - 1;

  List<Currency> get availableCurrencies => Currency.values.where((c) => rates.every((r) => r.currency != c)).toList();

  void addNewRate() {
    var nextCurr = availableCurrencies.firstWhere((c) => c != target);
    setState(() {
      rates.add(RateEntry(nextCurr, 1, 1));
    });
  }

  void saveRates() {
    Navigator.of(context).pop(BillingRates(target, {
      for (var rate in rates)
        if (rate.sourceAmount != 0 && rate.targetAmount != 0) //
          rate.currency: rate.sourceAmount / rate.targetAmount
    }));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(4),
      content: SizedBox(
        width: 300,
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
                for (var rate in rates)
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 8),
                    title: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: TextFormField(
                            initialValue: rate.sourceAmount.toString(),
                            inputFormatters: [
                              TextInputFormatter.withFunction((old, newVal) => TextEditingValue(
                                  text: newVal.text.replaceAll(',', '.'), selection: newVal.selection)),
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (value) {
                              setState(() {
                                rate.sourceAmount = double.tryParse(value) ?? 1;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        PopupMenuButton<Currency>(
                          initialValue: rate.currency,
                          onSelected: (newCurr) {
                            if (newCurr != rate.currency) {
                              if (newCurr == target) {
                                target = rate.currency;
                              }
                              setState(() {
                                rate.currency = newCurr;
                              });
                            }
                          },
                          itemBuilder: (context) => [
                            for (var currency in availableCurrencies)
                              PopupMenuItem(
                                value: currency,
                                child: Text('${currency.symbol} (${currency.name.toUpperCase()})'),
                              )
                          ],
                          child: Container(
                            height: 51,
                            width: 38,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            child: Text(rate.currency.symbol),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.arrow_forward),
                        const SizedBox(width: 5),
                        Flexible(
                          fit: FlexFit.tight,
                          child: TextFormField(
                            initialValue: rate.targetAmount.toString(),
                            inputFormatters: [
                              TextInputFormatter.withFunction((old, newVal) => TextEditingValue(
                                  text: newVal.text.replaceAll(',', '.'), selection: newVal.selection)),
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (value) {
                              setState(() {
                                rate.targetAmount = double.tryParse(value) ?? 1;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        PopupMenuButton<Currency>(
                          initialValue: target,
                          onSelected: (newCurr) {
                            setState(() {
                              target = newCurr;
                            });
                          },
                          itemBuilder: (context) => [
                            for (var currency in availableCurrencies)
                              PopupMenuItem(
                                value: currency,
                                child: Text('${currency.symbol} (${currency.name.toUpperCase()})'),
                              )
                          ],
                          child: Container(
                            height: 51,
                            width: 38,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            child: Text(target.symbol),
                          ),
                        ),
                        IconButton(
                          splashRadius: 25,
                          onPressed: () {
                            setState(() {
                              rates.remove(rate);
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                if (canAddRate)
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 8),
                    title: Row(
                      children: [
                        Flexible(
                          child: Opacity(
                            opacity: 0.8,
                            child: TextField(
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              style: TextStyle(color: context.onSurfaceColor.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Opacity(
                          opacity: 0.4,
                          child: Container(
                            height: 51,
                            width: 38,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            child: Text(availableCurrencies.firstWhere((c) => c != target).symbol),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.arrow_forward),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Opacity(
                            opacity: 0.8,
                            child: TextField(
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              style: TextStyle(color: context.onSurfaceColor.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Opacity(
                          opacity: 0.4,
                          child: Container(
                            height: 51,
                            width: 38,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(),
                            ),
                            alignment: Alignment.center,
                            child: Text(target.symbol),
                          ),
                        ),
                        IconButton(
                          splashRadius: 25,
                          onPressed: addNewRate,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    onTap: addNewRate,
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(context.tr.save),
          onPressed: saveRates,
        ),
      ],
    );
  }
}
