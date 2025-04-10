import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({
    required AuthService authService,
  }) : _authService = authService;

  /// Verifies the authentication state by checking the validity of the stored token.
  /// On success, the authentication state is confirmed.
  /// Throws an exception if token validation fails.
  Future<void> verifyAuthentication() async {
    try {
      await _authService.validateSessionToken();
    } catch (e) {
      rethrow;
    }
  }

  /// Sends an SMS code to the provided [phoneNumber] for authentication.
  /// Returns true if the SMS code is sent successfully.
  /// Throws an exception if the SMS code sending fails.
  Future<bool> sendSMSCode(String phoneNumber) async {
    try {
      await _authService.sendSMSCode(phoneNumber);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// Verifies the SMS code for the given [phoneNumber] and [code].
  /// On success, the SMS code is confirmed.
  /// Throws an exception if the SMS code verification fails.
  Future<void> verifySMSCode(String phoneNumber, String code) async {
    try {
      await _authService.verifySMSCode(phoneNumber, code);
    } catch (e) {
      rethrow;
    }
  }
}
