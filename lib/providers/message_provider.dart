import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageProvider extends ChangeNotifier {
  final List<Message> _messages = [];

  /// Returns an unmodifiable list of system messages.
  List<Message> get messages => List.unmodifiable(_messages);

  /// Adds a new [message] if an equivalent message is not already present.
  /// If the message is added, notifies listeners.
  void addMessage(Message message) {
    final exists = _messages.any((m) => m.content == message.content && m.type == message.type);
    if (!exists) {
      _messages.add(message);
      notifyListeners();
    }
  }

  /// Removes the specified [message] from the list.
  /// Notifies listeners after removal.
  void removeMessage(Message message) {
    _messages.removeWhere((m) => m.content == message.content && m.type == message.type);
    notifyListeners();
  }

  /// Clears all system messages.
  /// Empties the list of system messages and notifies listeners.
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
