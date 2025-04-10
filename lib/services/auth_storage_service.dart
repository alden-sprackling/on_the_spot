import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions/exceptions.dart';

class AuthStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Saves the session and refresh tokens to secure storage using the provided
  /// [sessionToken] and [refreshToken].
  /// Returns true if both tokens are successfully saved.
  /// If an error occurs during the write operations, returns false.
  Future<bool> saveTokens(String sessionToken, String refreshToken) async {
    try {
      await _secureStorage.write(key: 'session_token', value: sessionToken);
      await _secureStorage.write(key: 'refresh_token', value: refreshToken);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the session token from secure storage.
  /// Returns the session token if it is found.
  /// Throws an [AuthServiceException] if the session token does not exist.
  Future<String> getSessionToken() async {
    final token = await _secureStorage.read(key: 'session_token');
    if (token == null) {
      throw AuthServiceException(AuthServiceErrorType.tokenNotFound);
    }
    return token;
  }

  /// Retrieves the refresh token from secure storage.
  /// Returns the refresh token if it is found.
  /// Throws an [AuthServiceException] if the refresh token does not exist.
  Future<String> getRefreshToken() async {
    final token = await _secureStorage.read(key: 'refresh_token');
    if (token == null) {
      throw AuthServiceException(AuthServiceErrorType.tokenNotFound);
    }
    return token;
  }

  /// Deletes the session and refresh tokens from secure storage.
  /// Returns true if both tokens are successfully deleted.
  /// If an error occurs during deletion, returns false.
  Future<bool> deleteTokens() async {
    try {
      await _secureStorage.delete(key: 'session_token');
      await _secureStorage.delete(key: 'refresh_token');
      return true;
    } catch (e) {
      return false;
    }
  }
}