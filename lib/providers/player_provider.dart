import 'package:flutter/material.dart';
import 'exceptions.dart';

class PlayerProvider extends ChangeNotifier {
  String _playerName = "DEFAULT";
  String _profilePicture = "default"; // Default profile picture
  String _phoneNumber = "";

  String get playerName => _playerName;
  String get profilePicture => _profilePicture;
  String get phoneNumber => _phoneNumber;

  void setPlayerName(String name) {
    _validateUsername(name);
    _playerName = name;
    notifyListeners();
  }

  void setProfilePicture(String picture) {
    _profilePicture = picture;
    notifyListeners();
  }

  void setPhoneNumber(String phone) {
    _validatePhoneNumber(phone);
    _phoneNumber = phone;
    notifyListeners();
  }

  void _validateUsername(String name) {
    if (name.isEmpty) {
      throw EmptyUsernameException();
    } else if (name.contains(' ') || name != name.toUpperCase()) {
      throw InvalidUsernameFormatException();
    }
  }

  void _validatePhoneNumber(String phone) {
    if (phone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(phone)) {
      throw InvalidPhoneNumberException();
    }
  }
}