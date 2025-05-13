// lib/src/providers/user_provider.dart

import 'package:flutter/material.dart';
import 'package:on_the_spot/models/errors.dart';
import '../services/user_service.dart';
import '../models/user.dart';

/// Manages fetching and updating the authenticated user's profile via UserService
class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  /// Fetches the current user's profile
  Future<void> fetchProfile() async {
    _setLoading(true);
    try {
      _user = await _userService.getProfile();
      notifyListeners();
    } catch (e) {
      throw ApiError('Failed to load profile');
    } finally {
      _setLoading(false);
    }
  }

  /// Updates the current user's profile and returns the updated User
  Future<void> updateProfile({
    String? name,
    String? profilePic,
    int? iq,
  }) async {
    _setLoading(true);
    try {
      _user = await _userService.updateProfile(
        name: name,
        profilePic: profilePic,
        iq: iq,
      );
      notifyListeners();
    } catch (e) {
      throw ApiError('Failed to update profile');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
