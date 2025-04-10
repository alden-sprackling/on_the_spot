import '../exceptions/exceptions.dart';

/// Validates a phone number input.
///
/// The phone number must:
/// - Contain exactly 10 digits.
/// - Contain no spaces or symbols.
///
/// On successful validation, prepends the U.S. country code "+1" to the phone number.
///
/// Parameters:
/// - [phoneNumber]: The phone number to validate.
///
/// Throws:
/// - An [InputException] if the phone number is invalid.
///
/// Returns:
/// - The validated phone number as a [String] with "+1" prepended.
String validatePhoneNumber(String phoneNumber) {
  final phoneRegex = RegExp(r'^\d{10}$');

  if (!phoneRegex.hasMatch(phoneNumber)) {
    throw InputException(InputErrorType.invalidPhoneNumberFormat);
  }

  return '+1$phoneNumber';
}

/// Validates a username.
/// 
/// The username must:
/// - Be 1 to 12 characters long.
/// - Contain no spaces.
/// 
/// Parameters:
/// - [username]: The username to validate.
/// 
/// Throws:
/// - An [InputException] if the username is invalid.
/// 
/// Returns:
/// - The validated [username] as a [String] if it is valid.
String validateUsername(String username) {
  // Check if the username is empty or exceeds the length limit
  if (username.isEmpty || username.length > 12) {
    throw InputException(
      InputErrorType.invalidUsernameLength,
    );
  }

  // Check if the username contains spaces
  if (username.contains(' ')) {
    throw InputException(
      InputErrorType.invalidUsernameFormat,
    );
  }

  // If valid, return the username
  return username;
}

