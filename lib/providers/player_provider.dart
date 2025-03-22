import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'exceptions.dart';

class PlayerProvider extends ChangeNotifier {
  String _playerName = "DEFAULT";
  String _profilePicture = "default";
  int _iqPoints = 0;

  String get playerName => _playerName;
  String get profilePicture => _profilePicture;
  int get iqPoints => _iqPoints;

  /// Loads the username, profile picture, and IQ points from SharedPreferences.
  Future<void> loadPlayerData() async {
    final prefs = await SharedPreferences.getInstance();
    _playerName = prefs.getString('username') ?? "DEFAULT";
    _profilePicture = prefs.getString('profilePicture') ?? "default";
    _iqPoints = prefs.getInt('iqPoints') ?? 0;
    notifyListeners();
  }

  /// Sets and saves the username in SharedPreferences.
  Future<void> setPlayerName(String name) async {
    _validateUsername(name);
    _playerName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
    notifyListeners();
  }

  /// Sets and saves the profile picture in SharedPreferences.
  Future<void> setProfilePicture(String picture) async {
    _profilePicture = picture;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profilePicture', picture);
    notifyListeners();
  }

  /// Sets and saves the IQ points in SharedPreferences.
  Future<void> setIqPoints(int iq) async {
    _iqPoints = iq;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('iqPoints', iq);
    notifyListeners();
  }

  void _validateUsername(String name) {
    if (name.isEmpty) {
      throw EmptyUsernameException();
    } else if (name.contains(' ') || name != name.toUpperCase()) {
      throw InvalidUsernameFormatException();
    }
  }
}
