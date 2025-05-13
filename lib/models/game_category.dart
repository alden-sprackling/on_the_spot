// lib/src/models/game_category.dart
class GameCategory {
  final String gameId;
  final String categoryId;
  final bool used;

  GameCategory({
    required this.gameId,
    required this.categoryId,
    required this.used,
  });

  factory GameCategory.fromJson(Map<String, dynamic> json) => GameCategory(
        gameId: json['game_id'] as String,
        categoryId: json['category_id'] as String,
        used: json['used'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'game_id': gameId,
        'category_id': categoryId,
        'used': used,
      };
}
