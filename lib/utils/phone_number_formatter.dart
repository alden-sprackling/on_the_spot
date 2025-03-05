import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  final int maxLength;

  PhoneNumberFormatter({this.maxLength = 10});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (newText.length > maxLength) {
      newText = newText.substring(0, maxLength);
    }
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}