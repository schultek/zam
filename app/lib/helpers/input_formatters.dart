import 'package:flutter/services.dart';

final phoneNumberInputFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[+0-9]')),
  TextInputFormatter.withFunction(formatPhoneNumberInput),
];

TextEditingValue formatPhoneNumberInput(TextEditingValue oldValue, TextEditingValue newValue) {
  var text = '';
  var selection = newValue.selection.baseOffset;
  var newText = newValue.text.split('');
  var i = 0;
  while (newText.isNotEmpty) {
    var char = newText.removeAt(0);
    if (i == 0) {
      if (char == '+') {
        text += char;
      } else if (char == '0') {
        text += '+49';
        i += 2;
        selection += 2;
      } else {
        text += '+$char';
        i++;
        selection++;
      }
    } else {
      if (i == 3 || i == 7) {
        text += ' ';
        selection++;
      }

      if (char == '+') {
        i--;
        selection--;
      } else {
        text += char;
      }
    }
    i++;
  }
  return TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: selection),
  );
}
