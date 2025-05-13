// lib/src/models/answer.dart
class Answer {
  final String gameId;
  final int round;
  final String userId;
  final String? answerText;
  final bool correct;
  final int pointsAwarded;

  Answer({
    required this.gameId,
    required this.round,
    required this.userId,
    this.answerText,
    required this.correct,
    required this.pointsAwarded,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        gameId: json['game_id'] as String,
        round: json['round'] as int,
        userId: json['user_id'] as String,
        answerText: json['answer_text'] as String?,
        correct: json['correct'] as bool,
        pointsAwarded: json['points_awarded'] as int,
      );

  Map<String, dynamic> toJson() => {
        'game_id': gameId,
        'round': round,
        'user_id': userId,
        'answer_text': answerText,
        'correct': correct,
        'points_awarded': pointsAwarded,
      };
}
