import 'dart:convert';
import 'package:on_the_spot/exceptions/exceptions.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants/constants.dart';
import '../models/chat.dart';

class ChatWebSocketService {
  late final WebSocketChannel _channel;

  /// Creates an instance of [ChatWebSocketService] and connects to the WebSocket
  /// for chat messages for the given [gameId].
  /// Throws a [WebSocketException] if the connection fails.
  ChatWebSocketService({required int gameId}) {
    try {
      final url = '$wsURL/game/$gameId/chat/ws';
      _channel = WebSocketChannel.connect(Uri.parse(url));
    } catch (e) {
      throw WebSocketException(WebSocketErrorType.connectionFailed);
    }
  }

  /// Returns a stream of new chat messages.
  /// Incoming messages are decoded from JSON and transformed into [ChatMessage]
  /// instances. If decoding fails, a [WebSocketException] is thrown.
  Stream<ChatMessage> get chatStream {
    return _channel.stream.map((message) {
      try {
        final data = json.decode(message);
        return ChatMessage.fromJson(data);
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

  /// Sends a chat message using the provided [message] string.
  /// Internally, this method calls [sendMessage] with an action payload.
  /// Throws a [WebSocketException] if sending the chat message fails.
  void sendChat(String message) {
    try {
      sendMessage({'action': 'sendChat', 'message': message});
    } catch (e) {
      throw WebSocketException(WebSocketErrorType.messageError);
    }
  }
}
