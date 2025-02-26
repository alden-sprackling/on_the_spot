import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _playerName = "";
  String _profilePicture = "";

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
