import 'package:on_the_spot/models/errors.dart';

String validatePhoneNumber(String phoneNumber) {
  // Remove all non-digit characters.
  String digitsOnly = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  final phoneRegex = RegExp(r'^\d{10}$');

  if (!phoneRegex.hasMatch(digitsOnly)) {
    throw InputError("Phone number must be 10 digits long");
  }

  return '+1$digitsOnly';
}

String validateUsername(String username) {
  // Check if the username is < 3 or > 12 characters long
  if (username.length < 3 || username.length > 12) {
    throw InputError("Username must be between 3 and 12 characters long");
  }

  // Check if the username contains spaces
  if (username.contains(' ')) {
    throw InputError("Username cannot contain spaces");
  }

  // If valid, return the username
  return username;
}

