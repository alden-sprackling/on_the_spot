// lib/src/models/game_player.dart
class GamePlayer {
  final String gameId;
  final String userId;
  final int pointsTotal;
  final int? finalIq;

  GamePlayer({
    required this.gameId,
    required this.userId,
    required this.pointsTotal,
    this.finalIq,
  });

  factory GamePlayer.fromJson(Map<String, dynamic> json) => GamePlayer(
        gameId: json['game_id'] as String,
        userId: json['user_id'] as String,
        pointsTotal: json['points_total'] as int,
        finalIq: json['final_iq'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'game_id': gameId,
        'user_id': userId,
        'points_total': pointsTotal,
        'final_iq': finalIq,
      };
}
