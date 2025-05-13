// lib/src/models/game.dart
enum GameStatus { waiting, inProgress, ended }

GameStatus _gameStatusFromString(String s) {
  switch (s) {
    case 'waiting':
      return GameStatus.waiting;
    case 'in_progress':
      return GameStatus.inProgress;
    case 'ended':
      return GameStatus.ended;
    default:
      throw Exception('Unknown GameStatus: $s');
  }
}

String _gameStatusToString(GameStatus s) {
  switch (s) {
    case GameStatus.waiting:
      return 'waiting';
    case GameStatus.inProgress:
      return 'in_progress';
    case GameStatus.ended:
      return 'ended';
  }
}

class Game {
  final String id;
  final String? lobbyCode;
  final GameStatus status;
  final int currentRound;
  final DateTime createdAt;

  Game({
    required this.id,
    this.lobbyCode,
    required this.status,
    required this.currentRound,
    required this.createdAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json['id'] as String,
        lobbyCode: json['lobby_code'] as String?,
        status: _gameStatusFromString(json['status'] as String),
        currentRound: json['current_round'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'lobby_code': lobbyCode,
        'status': _gameStatusToString(status),
        'current_round': currentRound,
        'created_at': createdAt.toIso8601String(),
      };
}
