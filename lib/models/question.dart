// lib/src/models/question.dart
class Question {
  final String id;
  final String categoryId;
  final int difficulty;
  final String text;
  final String answer;

  Question({
    required this.id,
    required this.categoryId,
    required this.difficulty,
    required this.text,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as String,
        categoryId: json['category_id'] as String,
        difficulty: int.parse(json['difficulty'] as String),
        text: json['text'] as String,
        answer: json['answer'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category_id': categoryId,
        'difficulty': difficulty.toString(),
        'text': text,
        'answer': answer,
      };
}
