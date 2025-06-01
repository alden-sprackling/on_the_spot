// lib/src/models/game_player.dart
class GamePlayer {
  final String userId;
  final int pointsTotal;
  final int? oldIQ;
  final int? iqDelta;
  final int? newIQ;

  GamePlayer({
    required this.userId,
    required this.pointsTotal,
    this.oldIQ,
    this.iqDelta,
    this.newIQ,
  });

  factory GamePlayer.fromJson(Map<String, dynamic> json) => GamePlayer(
        userId: json['userId'] as String,
        pointsTotal: json['pointsTotal'] as int,
        oldIQ: json['oldIQ'] as int?,
        iqDelta: json['iqDelta'] as int?,
        newIQ: json['finalIQ'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'pointsTotal': pointsTotal,
        'oldIQ': oldIQ,
        'iqDelta': iqDelta,
        'finalIQ': newIQ,
      };
}
