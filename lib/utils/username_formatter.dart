import 'package:flutter/services.dart';

class UsernameFormatter extends TextInputFormatter {
  final int maxLength;

  UsernameFormatter({this.maxLength = 12});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.toUpperCase().replaceAll(' ', '');
    if (newText.length > maxLength) {
      newText = newText.substring(0, maxLength);
    }
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}