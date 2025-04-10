// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final UserService _userService;

  UserProvider({required UserService userService})
      : _userService = userService;

  /// Returns the current [User] object.
  User? get user => _user;

  /// Loads the user data from the backend.
  /// On success, updates the local [User] object and notifies listeners.
  /// Throws an exception if the user data fetch fails.
  Future<void> loadUser() async {
    try {
      _user = await _userService.getUser();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a new user on both the backend and frontend using the provided
  /// [username] and [profilePicture].
  /// On success, updates the local [User] object and notifies listeners.
  /// Throws an exception if user creation fails.
  Future<void> createUser(String username, ProfilePicture profilePicture) async {
    try {
      _user = await _userService.createUser(username, profilePicture);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Updates the user's username on both backend and frontend with [newUsername].
  /// On success, updates the local [User] object and notifies listeners.
  /// Throws an exception if the username update fails.
  Future<void> updateUsername(String newUsername) async {
    try {
      _user = await _userService.updateUsername(newUsername);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Updates the user's profile picture on both backend and frontend with 
  /// [newProfilePicture].
  /// On success, updates the local [User] object and notifies listeners.
  /// Throws an exception if the profile picture update fails.
  Future<void> updateProfilePicture(ProfilePicture newProfilePicture) async {
    try {
      _user = await _userService.updateProfilePicture(newProfilePicture);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Updates the user's IQ points on both backend and frontend with [newIqPoints].
  /// **Note:** This should only be called by system-level logic.
  /// On success, updates the local [User] object and notifies listeners.
  /// Throws an exception if updating IQ points fails.
  Future<void> updateIqPoints(int newIqPoints) async {
    try {
      _user = await _userService.updateIqPoints(newIqPoints);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes the user account from the backend and clears the local user data.
  /// On success, sets the local [User] object to null and notifies listeners.
  /// Throws an exception if deleting the user fails.
  Future<void> deleteUser() async {
    try {
      await _userService.deleteUser();
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
