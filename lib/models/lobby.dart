// lib/src/models/lobby.dart

import 'lobby_player.dart';

/// Represents a game lobby with players and settings.
class Lobby {
  final String code;
  final String hostId;
  final bool isPublic;
  final DateTime createdAt;
  final List<LobbyPlayer> players;

  Lobby({
    required this.code,
    required this.hostId,
    required this.isPublic,
    required this.createdAt,
    required this.players,
  });

  /// Creates a Lobby from JSON, handling missing createdAt gracefully
  factory Lobby.fromJson(Map<String, dynamic> json) {
    // Backend createLobby doesn't return createdAt, so default to now()
    final createdAtStr = json['createdAt'] as String?;
    final createdAt = createdAtStr != null
        ? DateTime.parse(createdAtStr)
        : DateTime.now();

    return Lobby(
      code: json['code'] as String,
      hostId: json['hostId'] as String,
      isPublic: json['isPublic'] as bool,
      createdAt: createdAt,
      players: (json['players'] as List<dynamic>)
          .map((p) => LobbyPlayer.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'hostId': hostId,
        'isPublic': isPublic,
        'createdAt': createdAt.toIso8601String(),
        'players': players.map((p) => p.toJson()).toList(),
      };
}
