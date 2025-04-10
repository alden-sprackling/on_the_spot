/// Represents a category with a list of questions.
class Category {
  final String name;
  final List<Question> questions; // List of questions in the category
  int votes; // Number of votes for this category

  Category({
    required this.name,
    required this.questions,
    this.votes = 0, // Default to 0 votes
  });

  /// Creates a [Category] from JSON.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      questions: (json['questions'] as List)
          .map((questionJson) => Question.fromJson(questionJson))
          .toList(),
      votes: json['votes'] ?? 0,
    );
  }

  /// Converts a [Category] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'questions': questions.map((question) => question.toJson()).toList(),
      'votes': votes,
    };
  }
}

/// Represents a question.
class Question {
  final int id; // ID of the question
  final String question;
  final String answer;
  bool hasBeenAnswered; // Tracks if the question has been answered

  Question({
    required this.id,
    required this.question,
    required this.answer,
    this.hasBeenAnswered = false, // Default to false (unanswered)
  });

  /// Creates a [Question] from JSON.
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'], 
      question: json['question'],
      answer: json['answer'],
      hasBeenAnswered: json['has_been_answered'] ?? false, // Default to false if not provided
    );
  }

  /// Converts a [Question] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'question': question,
      'answer': answer,
      'has_been_answered': hasBeenAnswered, 
    };
  }

  /// Marks the question as answered.
  void markAsAnswered() {
    hasBeenAnswered = true;
  }
}