import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants/constants.dart';
import '../exceptions/exceptions.dart';
import '../models/game.dart';

class GameWebSocketService {
  late final WebSocketChannel _channel;

  /// Creates an instance of [GameWebSocketService] and connects to the WebSocket
  /// for game updates for the provided [gameId].
  /// Throws a [WebSocketException] if the connection fails.
  GameWebSocketService({required int gameId}) {
    try {
      final url = '$wsURL/game/$gameId/ws';
      _channel = WebSocketChannel.connect(Uri.parse(url));
    } catch (e) {
      throw WebSocketException(WebSocketErrorType.connectionFailed);
    }
  }

  /// Returns a stream for updating the [Game] object.
  /// Incoming messages are decoded from JSON and converted into a [Game] instance.
  /// If decoding fails, a [WebSocketException] is thrown.
  Stream<Game> get gameStream {
    return _channel.stream.map((message) {
      try {
        final data = json.decode(message);
        return Game.fromJson(data);
      } catch (e) {
        throw WebSocketException(WebSocketErrorType.messageError);
      }
    });
  }

  /// Sends a JSON-encoded message over the WebSocket.
  /// The [message] parameter should be a [Map<String, dynamic>] containing the payload.
  /// Throws a [WebSocketException] if sending the message fails.
  void sendMessage(Map<String, dynamic> message) {
    try {
      _channel.sink.add(json.encode(message));
    } catch (e) {
      throw WebSocketException(WebSocketErrorType.messageError);
    }
  }

  /// Closes the WebSocket connection.
  void disconnect() {
    _channel.sink.close();
  }

  /// Tells the server to start the game.
  /// Internally calls [sendMessage] with the appropriate action payload.
  /// Throws a [WebSocketException] if the request fails.
  void startGame() {
    try {
      sendMessage({'action': 'startGame'});
    } catch (e) {
      throw WebSocketException(WebSocketErrorType.messageError);
    }
  }

  /// Adds a vote to the provided category using [categoryName].
  /// The votes will be updated on the backend.
  /// Throws a [WebSocketException] if the request fails.
  void voteOnCategory(String categoryName) {
    try {
      sendMessage({'action': 'voteOnCategory', 'category': categoryName});
    } catch (e) {
      throw WebSocketException(WebSocketErrorType.messageError);
    }
  }

  /// Sends an answer for the given question by providing the [questionId] and [answer].
  /// Internally calls [sendMessage] with the appropriate action payload.
  /// Throws a [WebSocketException] if sending the answer fails.
  void answerQuestion(int questionId, String answer) {
    try {
      sendMessage({'action': 'answerQuestion', 'question_id': questionId, 'answer': answer});
    } catch (e) {
      throw WebSocketException(WebSocketErrorType.messageError);
    }
  }
}