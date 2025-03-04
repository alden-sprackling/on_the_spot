import 'package:flutter/material.dart';

class PlayerProvider extends ChangeNotifier {
  String _playerName = "test";
  String _profilePicture = "default"; // Default profile picture

  String get playerName => _playerName;
  String get profilePicture => _profilePicture;

  void setPlayerName(String name) {
    _playerName = name;
    notifyListeners();
  }

  void setProfilePicture(String picture) {
    _profilePicture = picture;
    notifyListeners();
  }
}