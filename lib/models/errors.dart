class AuthenticationError implements Exception {
  final String message;
  AuthenticationError(this.message);
  @override String toString() => 'AuthenticationError: $message';
}

class ApiError implements Exception {
  final String message;
  ApiError(this.message);
  @override String toString() => 'ApiError: $message';
}

class NetworkError implements Exception {
  final String message;
  NetworkError(this.message);
  @override String toString() => 'NetworkError: $message';
}

class InputError implements Exception {
  final String message;
  InputError(this.message);
  @override String toString() => 'InputError: $message';
}