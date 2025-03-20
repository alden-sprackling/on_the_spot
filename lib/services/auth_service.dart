// services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/exceptions.dart';

class AuthService {
  final String baseUrl;
  final FlutterSecureStorage secureStorage;

  AuthService({
    required this.baseUrl,
    FlutterSecureStorage? secureStorage,
  }) : secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Sends the verification code to the given phone number.
  /// Returns the confirmation message from the server.
  Future<String> sendVerificationCode(String phoneNumber) async {
    _validatePhoneNumber(phoneNumber); // Validate phone number format (10 digits)
    final url = Uri.parse('$baseUrl/auth/phone/send');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phoneNumber}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        final errorMessage = data['error'] ?? 'An unknown error occurred';
        throw AuthenticationException(AuthenticationErrorType.sendFailed, errorMessage);
      } else {
        final confirmationMessage = data['confirmation'] ?? 'Verification code sent successfully';
        return confirmationMessage;
      }
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException(AuthenticationErrorType.unknown, e.toString());
    }
  }

  /// Verifies the provided code and, if successful, stores both the access and refresh tokens.
  /// Returns the access token.
  Future<String> verifyCode(String phoneNumber, String code) async {
    final url = Uri.parse('$baseUrl/auth/phone/verify');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phoneNumber, 'code': code}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        if (accessToken == null || refreshToken == null) {
          throw AuthenticationException(
              AuthenticationErrorType.verifyFailed, 'Token not found in response');
        }
        // Securely store both tokens for future use.
        await secureStorage.write(key: 'auth_token', value: accessToken);
        await secureStorage.write(key: 'refresh_token', value: refreshToken);
        return accessToken;
      } else {
        final errorMessage = jsonDecode(response.body)['error'] ?? 'Verification failed';
        throw AuthenticationException(AuthenticationErrorType.verifyFailed, errorMessage);
      }
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException(AuthenticationErrorType.unknown, e.toString());
    }
  }

  /// Retrieves the stored access token.
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'auth_token');
  }

  /// Retrieves the stored refresh token.
  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: 'refresh_token');
  }

  /// Clears the stored tokens (e.g., on logout).
  Future<void> clearTokens() async {
    await secureStorage.delete(key: 'auth_token');
    await secureStorage.delete(key: 'refresh_token');
  }

  /// Uses the provided refresh token to obtain new tokens.
  /// Returns a map containing the new 'accessToken' and 'refreshToken'.
  Future<Map<String, String>> refreshToken(String refreshToken) async {
    final url = Uri.parse('$baseUrl/auth/refresh');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];
        if (newAccessToken == null || newRefreshToken == null) {
          throw AuthenticationException(
              AuthenticationErrorType.unknown, 'Failed to refresh token');
        }
        // Update stored tokens.
        await secureStorage.write(key: 'auth_token', value: newAccessToken);
        await secureStorage.write(key: 'refresh_token', value: newRefreshToken);
        return {
          'accessToken': newAccessToken,
          'refreshToken': newRefreshToken,
        };
      } else {
        final errorMessage = jsonDecode(response.body)['error'] ?? 'Failed to refresh token';
        throw AuthenticationException(AuthenticationErrorType.unknown, errorMessage);
      }
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException(AuthenticationErrorType.unknown, e.toString());
    }
  }

  /// Validates the phone number format.
  /// Throws an [InvalidPhoneNumberException] if the format is invalid.
  void _validatePhoneNumber(String phone) {
    if (phone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(phone)) {
      throw InvalidPhoneNumberException();
    }
  }
}
