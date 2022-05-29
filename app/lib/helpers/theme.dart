import 'dart:ui';

const juGreen = Color(0xff57b95f);
const juOrange = Color(0xfff2a24a);
const juBlue = Color(0xff399ff7);
const juDarkGrey = Color(0xff323f43);

Color? decodeColor(String? value) {
  return value == null ? null : Color(int.parse('ff${value.substring(1)}', radix: 16));
}

String? encodeColor(Color? value) {
  return value == null ? null : "#${(value.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}";
}
