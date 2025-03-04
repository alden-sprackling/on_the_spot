import 'package:flutter/material.dart';
import '/widgets/message_banner.dart';

enum MessageType { error, warning, confirmation }

class MessageProvider extends ChangeNotifier {
  final List<MessageBanner> _messageBanners = [];

  List<MessageBanner> get messageBanners => _messageBanners;

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