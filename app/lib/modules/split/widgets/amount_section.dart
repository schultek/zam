import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../split.module.dart';

class AmountSection extends StatelessWidget {
  const AmountSection({
    this.title,
    required this.amount,
    required this.currency,
    required this.onAmountChanged,
    required this.onCurrencyChanged,
    Key? key,
  }) : super(key: key);

  final String? title;
  final double amount;
  final Currency? currency;

  final ValueChanged<double> onAmountChanged;
  final ValueChanged<Currency> onCurrencyChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(title: title, children: [
      ListTile(
        title: Row(
          children: [
            Text(context.tr.amount),
            Expanded(
              child: TextFormField(
                initialValue: amount != 0 ? amount.toStringAsFixed(2) : null,
                inputFormatters: [
                  TextInputFormatter.withFunction((old, newVal) =>
                      TextEditingValue(text: newVal.text.replaceAll(',', '.'), selection: newVal.selection)),
                ],
                decoration: InputDecoration(
                  hintText: '0.00',
                  border: InputBorder.none,
                  suffixText: currency?.symbol,
                  filled: false,
                ),
                textAlign: TextAlign.end,
                onChanged: (value) {
                  onAmountChanged(double.parse(value));
                },
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
      ),
      PopupMenuButton<Currency>(
        itemBuilder: (context) => [
          for (var currency in Currency.values)
            PopupMenuItem(
              value: currency,
              child: Text('${currency.symbol} (${currency.name.toUpperCase()})'),
            ),
        ],
        onSelected: (value) {
          onCurrencyChanged(value);
        },
        child: ListTile(
          title: Text(context.tr.currency),
          trailing: currency != null ? Text('${currency!.symbol} (${currency!.name.toUpperCase()})') : null,
        ),
      ),
    ]);
  }
}
