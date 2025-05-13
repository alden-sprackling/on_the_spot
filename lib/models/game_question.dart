// lib/src/models/game_question.dart
class GameQuestion {
  final String gameId;
  final String questionId;

  GameQuestion({
    required this.gameId,
    required this.questionId,
  });

  factory GameQuestion.fromJson(Map<String, dynamic> json) => GameQuestion(
        gameId: json['game_id'] as String,
        questionId: json['question_id'] as String,
      );

  Map<String, dynamic> toJson() => {
        'game_id': gameId,
        'question_id': questionId,
      };
}
