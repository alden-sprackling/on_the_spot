// lib/src/services/chat_service.dart

import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/chat_message.dart';

/// Service for fetching and sending chat messages within a game
class ChatService {
  final ApiClient _client = ApiClient();

  /// Retrieve all chat messages for the given game
  Future<List<ChatMessage>> getMessages(String gameId) async {
    try {
      final response = await _client.get<List<dynamic>>(
        Endpoints.getMessages.replaceAll('{gameId}', gameId),
      );
      final data = response.data!;
      return data
          .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  /// Send a new chat message in the given game
  ///
  /// Provide the `userId` parameter so the backend can associate the message.
  Future<ChatMessage> sendMessage(
    String gameId,
    String userId,
    String message,
  ) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        Endpoints.sendMessage.replaceAll('{gameId}', gameId),
        data: {
          'userId': userId,
          'message': message,
        },
      );
      return ChatMessage.fromJson(response.data!);
    } on DioException {
      rethrow;
    }
  }
}