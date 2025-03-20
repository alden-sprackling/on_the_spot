class EmptyUsernameException implements Exception {
  @override
  String toString() => "Username cannot be empty";
}

class InvalidUsernameFormatException implements Exception {
  @override
  String toString() => "Username must be in capital letters and contain no spaces";
}

class InvalidPhoneNumberException implements Exception {
  @override
  String toString() => "Phone number must be exactly 10 digits";
}

enum AuthenticationErrorType { sendFailed, verifyFailed, unknown }

class AuthenticationException implements Exception {
  final AuthenticationErrorType type;
  final String message;
  
  AuthenticationException(this.type, [this.message = '']);
  
  @override
  String toString() => message;
}
