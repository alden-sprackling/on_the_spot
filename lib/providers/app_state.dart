import 'package:flutter/material.dart';
import '/widgets/message_banner.dart';

enum MessageType { error, warning, confirmation }

class AppState extends ChangeNotifier {
  String _playerName = "";
  String _profilePicture = "";
  final List<MessageBanner> _messageBanners = [];

  String get playerName => _playerName;
  String get profilePicture => _profilePicture;
  List<MessageBanner> get messageBanners => _messageBanners;

  void setPlayerName(String name) {
    _playerName = name;
    notifyListeners();
  }

  void setProfilePicture(String picture) {
    _profilePicture = picture;
    notifyListeners();
  }

  void showMessage(String message, MessageType type, {bool showForLimitedTime = false}) {
    final newMessageBanner = MessageBanner(message: message, type: type);
    _messageBanners.add(newMessageBanner);
    notifyListeners();

    if (showForLimitedTime) {
      Future.delayed(Duration(seconds: 4), () {
        _messageBanners.remove(newMessageBanner);
        notifyListeners();
      });
    }
  }

  void clearMessages() {
    _messageBanners.clear();
    notifyListeners();
  }
}