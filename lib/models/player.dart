import 'user.dart';
import 'category.dart';

/// Represents a user in the context of a game session.
class Player {
  final User user; // The base user profile
  int points; // Points specific to the game session
  bool hasPlayedCurrentRound; // Tracks if the player has taken their turn in the current round
  bool hasVoted; // Tracks if the player has voted in the current round
  List<Category> previousCategories; // List of categories already chosen for this player
  bool isConnected; // Tracks if the player is connected to the game

  Player({
    required this.user,
    this.points = 0, // Default to 0 for a new game session
    this.hasPlayedCurrentRound = false, // Default to false
    this.hasVoted = false, // Default to false
    this.previousCategories = const [], // Default to an empty list
    this.isConnected = true, // Default to true (player is connected by default)
  });

  /// Creates a [Player] from JSON.
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      user: User.fromJson(json['user']),
      points: json['points'] ?? 0,
      hasPlayedCurrentRound: json['has_played_this_round'] ?? false,
      hasVoted: json['has_voted'] ?? false,
      previousCategories: (json['previous_categories'] as List)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList(),
      isConnected: json['is_connected'] ?? true, // Default to true if not provided
    );
  }

  /// Converts a [Player] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'points': points,
      'has_played_this_round': hasPlayedCurrentRound,
      'has_voted': hasVoted,
      'previous_categories': previousCategories.map((category) => category.toJson()).toList(),
      'is_connected': isConnected, // Include the isConnected field
    };
  }

  /// Checks if a category has already been picked for this player.
  bool hasCategoryBeenChosen(Category category) {
    return previousCategories.any((pickedCategory) => pickedCategory.name == category.name);
  }

  /// Adds a category to the list of previously picked categories for this player.
  void addChosenCategory(Category category) {
    if (!hasCategoryBeenChosen(category)) {
      previousCategories.add(category);
    }
  }
}