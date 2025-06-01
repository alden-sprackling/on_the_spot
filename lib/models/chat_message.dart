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
        gameId: json['gameId'] as String,
        userId: json['userId'] as String,
        message: json['message'] as String,
        sentAt: DateTime.parse(json['sentAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameId': gameId,
        'userId': userId,
        'message': message,
        'sentAt': sentAt.toIso8601String(),
      };
}
