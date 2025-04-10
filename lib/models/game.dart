import 'chat.dart';
import 'player.dart';
import 'category.dart';
import 'round.dart';

/// Represents a game session.
class Game {
  final int id; // ID of the game session (game code)
  final int host; // ID of the user hosting the game
  final List<Player> players; // List of players in the game
  final GameState gameState; // Current state of the game
  final List<Category> categories; // List of categories with questions
  final Chat chat; // Game chat
  final Round round; // Current round details

  Game({
    required this.id,
    required this.host,
    required this.players,
    required this.gameState,
    required this.categories,
    required this.chat,
    required this.round,
  });

  /// Creates a [Game] from JSON.
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      host: json['host'], // Parse the host ID
      players: (json['players'] as List)
          .map((playerJson) => Player.fromJson(playerJson))
          .toList(),
      gameState: GameState.values.firstWhere(
          (e) => e.toString().split('.').last == json['game_state']),
      categories: (json['categories'] as List)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList(),
      chat: Chat.fromJson(json['chat']),
      round: Round.fromJson(json['current_round']),
    );
  }

  /// Converts a [Game] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'host': host, // Include the host ID
      'players': players.map((player) => player.toJson()).toList(),
      'game_state': gameState.toString().split('.').last,
      'categories': categories.map((category) => category.toJson()).toList(),
      'chat': chat.toJson(),
      'current_round': round.toJson(),
    };
  }
}

/// Represents the state of the game.
enum GameState {
  waiting, // Waiting for players to join
  inProgress, // Game is currently in progress
  completed, // Game has ended
}