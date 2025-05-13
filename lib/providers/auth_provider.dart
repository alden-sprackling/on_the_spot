// lib/src/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_the_spot/models/errors.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user.dart';

/// Manages authentication state and user profile via AuthService and UserService
/// Catches and rethrows generic ApiError for UI to handle.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  /// Send an SMS verification code to the given phone number.
  Future<void> sendCode(String phone) async {
    _setLoading(true);
    try {
      await _authService.sendCode(phone);
    } catch (e) {
      throw ApiError('Failed to send code');
    } finally {
      _setLoading(false);
    }
  }

  /// Verify the SMS code and sign in the user.
  Future<void> verifyCode(String phone, String code) async {
    _setLoading(true);
    try {
      final result = await _authService.verifyCode(phone, code);
      _user = result.user;
      notifyListeners();
    } catch (e) {
      throw ApiError('Failed to verify code');
    } finally {
      _setLoading(false);
    }
  }

  /// Attempt to auto-login by refreshing tokens and fetching profile.
  Future<void> loadUserFromStorage() async {
    _setLoading(true);
    try {
      final refresh = await _storage.read(key: 'refresh_token');
      if (refresh == null) {
        throw ApiError('No stored credentials');
      }
      await _authService.refreshTokens(refresh);
      _user = await _userService.getProfile();
      notifyListeners();
    } catch (e) {
      throw ApiError('Failed to load user');
    } finally {
      _setLoading(false);
    }
  }

  /// Clear authentication and stored tokens.
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      _user = null;
      notifyListeners();
    } catch (e) {
      throw ApiError('Logout failed');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
