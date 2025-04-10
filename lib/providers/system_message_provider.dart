import 'package:flutter/material.dart';
import '../models/system_message.dart';

class SystemMessageProvider extends ChangeNotifier {
  final List<SystemMessage> _systemMessages = [];

  /// Returns an unmodifiable list of system messages.
  List<SystemMessage> get systemMessages => List.unmodifiable(_systemMessages);

  /// Adds a new [systemMessage] if an equivalent message is not already present.
  /// If the message is added, notifies listeners.
  void addMessage(SystemMessage systemMessage) {
    final exists = _systemMessages.any((m) => m.content == systemMessage.content && m.type == systemMessage.type);
    if (!exists) {
      _systemMessages.add(systemMessage);
      notifyListeners();
    }
  }

  /// Removes the specified [systemMessage] from the list.
  /// Notifies listeners after removal.
  void removeMessage(SystemMessage systemMessage) {
    _systemMessages.removeWhere((m) => m.content == systemMessage.content && m.type == systemMessage.type);
    notifyListeners();
  }

  /// Clears all system messages.
  /// Empties the list of system messages and notifies listeners.
  void clearMessages() {
    _systemMessages.clear();
    notifyListeners();
  }
}
