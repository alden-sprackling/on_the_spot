import 'player.dart';
import 'category.dart';

/// Represents the current round in the game.
class Round {
  final int roundNumber; // Current round number
  late Player playerUp; // The player whose turn it is (set later)
  late Category category; // The category chosen for this round (set later)
  late Question question; // The question chosen for this round (set later)
  RoundState roundState; // The current state of the round

  Round({
    required this.roundNumber,
    this.roundState = RoundState.showingRoundNumber, // Default state
  });

  /// Creates a [Round] from JSON.
  factory Round.fromJson(Map<String, dynamic> json) {
    final round = Round(
      roundNumber: json['round_number'],
      roundState: RoundState.values.firstWhere(
        (e) => e.toString().split('.').last == json['state'],
        orElse: () => RoundState.showingRoundNumber,
      ),
    );
    if (json['player_up'] != null) {
      round.playerUp = Player.fromJson(json['player_up']);
    }
    if (json['category_chosen'] != null) {
      round.category = Category.fromJson(json['category_chosen']);
    }
    if (json['question_chosen'] != null) {
      round.question = Question.fromJson(json['question_chosen']);
    }
    return round;
  }

  /// Converts a [Round] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'round_number': roundNumber,
      'player_up': playerUp.toJson(),
      'category_chosen': category.toJson(),
      'question_chosen': question.toJson(),
      'state': roundState.toString().split('.').last, // Serialize the state
    };
  }

  /// Updates the state of the round.
  void updateState(RoundState newState) {
    roundState = newState;
  }
}

/// Represents the state of a round.
enum RoundState {
  showingRoundNumber,    // Showing the round number
  choosingPlayer,        // Choosing the player for the round
  choosingCategory,      // Choosing the category for the round
  answeringQuestion,     // Answering the question
  completed,             // Round is completed
}