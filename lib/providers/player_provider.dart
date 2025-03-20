import 'package:flutter/material.dart';
import 'exceptions.dart';

class PlayerProvider extends ChangeNotifier {
  String _playerName = "DEFAULT";
  String _profilePicture = "default";

  String get playerName => _playerName;
  String get profilePicture => _profilePicture;

  void setPlayerName(String name) {
    _validateUsername(name);
    _playerName = name;
    notifyListeners();
  }

  void setProfilePicture(String picture) {
    _profilePicture = picture;
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