// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../exceptions/exceptions.dart';
import 'auth_storage_service.dart';

class AuthService {
  final String _baseUrl = baseURL;
  final AuthStorageService _authStorageService = AuthStorageService();

  /// Sends an SMS code to the provided [phoneNumber] for authentication.
  /// Returns true if the SMS code is sent successfully.
  /// Throws an [AuthenticationException] if the request fails.
  Future<bool> sendSMSCode(String phoneNumber) async {
    final url = Uri.parse('$_baseUrl/auth/sendSMSCode');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone_number': phoneNumber}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw AuthenticationException(AuthenticationErrorType.failedToSend);
    }
  }

  /// Verifies the SMS authentication code for the given [phoneNumber] and [code].
  /// On success, this method saves the session and refresh tokens in secure storage
  /// and returns true.
  /// Throws an [AuthenticationException] if the verification fails.
  Future<bool> verifySMSCode(String phoneNumber, String code) async {
    final url = Uri.parse('$_baseUrl/auth/verifySMSCode');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone_number': phoneNumber,
        'code': code,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final sessionToken = data['access_token'];
      final refreshToken = data['refresh_token'];

      // Save tokens securely.
      return await _authStorageService.saveTokens(sessionToken, refreshToken);
    } else {
      throw AuthenticationException(AuthenticationErrorType.failedToVerify);
    }
  }

  /// Refreshes the session token using the provided [savedRefreshToken].
  /// On success, saves the new session and refresh tokens in secure storage
  /// and returns the new session token.
  /// Throws an [AuthServiceException] if the refresh operation fails.
  Future<String> refreshSessionToken(String savedRefreshToken) async {
    final url = Uri.parse('$_baseUrl/auth/refreshSessionToken');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refresh_token': savedRefreshToken}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newSessionToken = data['access_token'];
      final newRefreshToken = data['refresh_token'];
      await _authStorageService.saveTokens(newSessionToken, newRefreshToken);
      return newSessionToken;
    } else {
      throw AuthServiceException(AuthServiceErrorType.refreshFailed);
    }
  }

  /// Validates the stored session token.
  /// If the current session token is expired (HTTP 401), attempts to refresh it
  /// using the stored refresh token.
  /// Returns true if the token is valid or successfully refreshed.
  /// Throws an [AuthServiceException] if the refresh fails.
  Future<bool> validateSessionToken() async {
    final savedSessionToken = await _authStorageService.getSessionToken();
    final savedRefreshToken = await _authStorageService.getRefreshToken();
    final url = Uri.parse('$_baseUrl/auth/validateSessionToken');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $savedSessionToken'}); 
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSessionToken(savedRefreshToken);
        return true;
      } catch (e) {
        throw AuthServiceException(AuthServiceErrorType.refreshFailed);
      }
    } else {
      throw AuthServiceException(AuthServiceErrorType.signInFailed);
    }
  }
}