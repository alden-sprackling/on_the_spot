// lib/src/models/chat_message.dart
class ChatMessage {
  final String id;
  final String gameId;
  final String userId;
  final String message;
  final DateTime sentAt;

  ChatMessage({
    required this.id,
    required this.gameId,
    required this.userId,
    required this.message,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        gameId: json['game_id'] as String,
        userId: json['user_id'] as String,
        message: json['message'] as String,
        sentAt: DateTime.parse(json['sent_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'game_id': gameId,
        'user_id': userId,
        'message': message,
        'sent_at': sentAt.toIso8601String(),
      };
}
