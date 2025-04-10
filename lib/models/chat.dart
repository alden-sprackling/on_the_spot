import 'player.dart';

/// Encapsulates the chat functionality for a game session.
class Chat {
  final List<ChatMessage> chatMessages;

  Chat({required this.chatMessages});

  /// Creates a [Chat] from JSON.
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatMessages: (json['messages'] as List)
          .map((msgJson) => ChatMessage.fromJson(msgJson))
          .toList(),
    );
  }

  /// Converts a [Chat] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'messages': chatMessages.map((msg) => msg.toJson()).toList(),
    };
  }
}

/// Represents a message exchanged during the game.
class ChatMessage {
  final String content; // The content of the in-game message
  final Player sender; // The player who sent the message
  final DateTime timestamp; // The time the message was sent

  ChatMessage({
    required this.content,
    required this.sender,
    required this.timestamp,
  });

  /// Creates a [ChatMessage] from JSON.
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'],
      sender: Player.fromJson(json['sender']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  /// Converts a [ChatMessage] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'sender': sender.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}