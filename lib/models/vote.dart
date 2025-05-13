// lib/src/models/vote.dart
class Vote {
  final String gameId;
  final int round;
  final String userId;
  final String categoryId;

  Vote({
    required this.gameId,
    required this.round,
    required this.userId,
    required this.categoryId,
  });

  factory Vote.fromJson(Map<String, dynamic> json) => Vote(
        gameId: json['game_id'] as String,
        round: json['round'] as int,
        userId: json['user_id'] as String,
        categoryId: json['category_id'] as String,
      );

  Map<String, dynamic> toJson() => {
        'game_id': gameId,
        'round': round,
        'user_id': userId,
        'category_id': categoryId,
      };
}
