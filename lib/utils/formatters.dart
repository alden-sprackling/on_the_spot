import 'package:flutter/services.dart';

class AuthCodeFormatter extends TextInputFormatter {
  final int maxLength;

  AuthCodeFormatter({this.maxLength = 6});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {

    // Remove any non-numeric characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit the length to maxLength
    if (newText.length > maxLength) {
      newText = newText.substring(0, maxLength);
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  final int maxLength = 10;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, 
    TextEditingValue newValue
  ) {
    // Remove all non-digit characters.
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit to 10 digits.
    if (digitsOnly.length > maxLength) {
      digitsOnly = digitsOnly.substring(0, maxLength);
    }

    String formatted = "";
    final len = digitsOnly.length;
    if (len == 0) {
      formatted = "";
    } else if (len < 4) {
      formatted = "($digitsOnly";
    } else if (len < 7) {
      formatted = "(${digitsOnly.substring(0,3)}) ${digitsOnly.substring(3)}";
    } else {
      formatted = "(${digitsOnly.substring(0,3)}) ${digitsOnly.substring(3,6)}-${digitsOnly.substring(6)}";
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class UsernameFormatter extends TextInputFormatter {
  final int maxLength = 12;

  UsernameFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {

    // Remove spaces and convert to uppercase
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