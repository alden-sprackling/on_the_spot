// lib/src/services/game_service.dart

import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/game_player.dart';

/// Vote tally for a category in a round
class VoteCount {
  final String categoryId;
  final int count;

  VoteCount({required this.categoryId, required this.count});

  factory VoteCount.fromJson(Map<String, dynamic> json) => VoteCount(
        categoryId: json['categoryId'] as String,
        count: json['count'] as int,
      );
}

/// Result of submitting an answer: correctness and points awarded
class AnswerResult {
  final bool correct;
  final int pointsAwarded;

  AnswerResult({required this.correct, required this.pointsAwarded});

  factory AnswerResult.fromJson(Map<String, dynamic> json) => AnswerResult(
        correct: json['correct'] as bool,
        pointsAwarded: json['pointsAwarded'] as int,
      );
}

/// Service for game-related actions (vote, answer, leaderboard)
class GameService {
  final ApiClient _client = ApiClient();

  /// Submit a vote for a category in a specific round
  Future<List<VoteCount>> submitVote(
    String gameId,
    int round,
    String userId,
    String categoryId,
  ) async {
    try {
      final response = await _client.post<List<dynamic>>(
        Endpoints.submitVote.replaceAll('{gameId}', gameId),
        data: {
          'round': round,
          'userId': userId,
          'categoryId': categoryId,
        },
      );
      final data = response.data!;
      return data
          .map((item) => VoteCount.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  /// Submit an answer for a specific round
  Future<AnswerResult> submitAnswer(
    String gameId,
    int round,
    String userId,
    String answerText,
  ) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        Endpoints.submitAnswer.replaceAll('{gameId}', gameId),
        data: {
          'round': round,
          'userId': userId,
          'answer': answerText,
        },
      );
      return AnswerResult.fromJson(response.data!);
    } on DioException {
      rethrow;
    }
  }

  /// Fetch the leaderboard for the given game
  Future<List<GamePlayer>> getLeaderboard(String gameId) async {
    try {
      final response = await _client.get<List<dynamic>>(
        Endpoints.getLeaderboard.replaceAll('{gameId}', gameId),
      );
      final data = response.data!;
      return data
          .map((item) => GamePlayer.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    }
  }
}
