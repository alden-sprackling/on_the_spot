import 'dart:async';
import 'socket_service.dart';

/// Service to expose real-time question events via WebSocket.
class QuestionService {
  final SocketService _socketClient;

  QuestionService(this._socketClient);

  /// Stream of question events: each event contains keys 'text' (String) and 'duration' (int seconds).
  Stream<Map<String, dynamic>> get questionStream => _socketClient.question;
}
