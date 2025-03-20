import 'package:flutter/material.dart';

enum MessageType { error, warning, confirmation }

class Message {
  final String message;
  final MessageType type;

  Message({required this.message, required this.type});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          type == other.type;

  @override
  int get hashCode => message.hashCode ^ type.hashCode;
}

class MessageProvider extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  void showMessage(String message, MessageType type, {bool showForLimitedTime = true}) {
    final newMessage = Message(message: message, type: type);
    if (!_messages.contains(newMessage)) {
      _messages.add(newMessage);
      notifyListeners();

      if (showForLimitedTime) {
        Future.delayed(Duration(seconds: 4), () {
          _messages.remove(newMessage);
          notifyListeners();
        });
      }
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}