import 'package:flutter/material.dart';
import 'package:on_the_spot/services/game_web_socket_service.dart';
import '../exceptions/exceptions.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../services/chat_web_socket_service.dart';
import '../services/game_service.dart';

class GameProvider extends ChangeNotifier {
  Game? _game;
  final GameService _gameService;
  GameWebSocketService? _gameWS;
  ChatWebSocketService? _chatWS;

  GameProvider({
    required GameService gameService,
  })  : _gameService = gameService;

  /// Returns the current [Game] object.
  Game? get game => _game;

  /// Returns the current game.
  /// Throws a [GameException] if no game is loaded.
  Game get currentGame {
    if (_game == null) {
      throw GameException(GameErrorType.gameNotFound);
    }
    return _game!;
  }

  /// Returns a list of players that are currently connected.
  List<Player> get connectedPlayers {
    return currentGame.players.where((player) => player.isConnected).toList();
  }

  /// Checks for an existing game session by retrieving the saved game ID.
  /// If a saved game ID is found, attempts to load the game and returns it.
  /// If loading fails, the saved game ID is cleared.
  /// Does not update the current game state automatically.
  Future<Game?> restoreGame() async {
    try {
      return await _gameService.restoreGame();
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a new game session on the backend and saves the game ID.
  /// On success, updates the local [Game] object and notifies listeners.
  /// Throws an exception if game creation fails.
  Future<void> createGame() async {
    try {
      _game = await _gameService.createGame();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Loads game session details for the provided [gameId] from the backend.
  /// On success, updates the local [Game] object and notifies listeners.
  /// Throws an exception if loading the game fails.
  Future<void> loadGame(int gameId) async {
    try {
      _game = await _gameService.getGame(gameId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Allows the player to join a game session with the provided [gameId] and saves the game ID.
  /// On success, updates the local [Game] object and notifies listeners.
  /// Throws an exception if joining the game fails.
  Future<void> joinGame(int gameId) async {
    try {
      _game = await _gameService.joinGame(gameId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Connects to the game WebSocket for real-time game updates for the provided [gameId].
  /// Listens to incoming updates and updates the local [Game] object.
  void connectToGameWebSocket(int gameId) {
    try {
      _gameWS = GameWebSocketService(gameId: gameId);
      _gameWS!.gameStream.listen(
        (updatedGame) {
          _game = updatedGame;
          notifyListeners();
        },
        onError: (error) {
          print("Game WebSocket error: $error");
        },
        onDone: () {
          print("Game WebSocket connection closed");
        },
      );
    } catch (e) {
      print("Failed to connect to Game WebSocket: $e");
    }
  }

  /// Connects to the chat WebSocket for receiving new chat messages for the provided [gameId].
  /// Updates the local chat messages list within the [Game] object on receiving a new message.
  void connectToChatWebSocket(int gameId) {
    try {
      _chatWS = ChatWebSocketService(gameId: gameId);
      _chatWS!.chatStream.listen(
        (chatMessage) {
          try {
            // Use the getter to ensure the game is loaded.
            final updatedChatMessages = [
              ...currentGame.chat.chatMessages.map((msg) => msg.toJson()).toList(),
              chatMessage.toJson(),
            ];
            _game = Game.fromJson({
              ..._game!.toJson(),
              'chat': {'messages': updatedChatMessages},
            });
            notifyListeners();
          } catch (e) {
            print("Chat update failed: $e");
          }
        },
        onError: (error) {
          print("Chat WebSocket error: $error");
        },
        onDone: () {
          print("Chat WebSocket connection closed");
        },
      );
    } catch (e) {
      print("Failed to connect to Chat WebSocket: $e");
    }
  }

  /// Disconnects both WebSocket connections.
  void disconnectWebSockets() {
    _gameWS?.disconnect();
    _chatWS?.disconnect();
  }

  /// Sends a start game command through the game WebSocket.
  /// Throws an exception if the command fails to send.
  void startGame() {
    try {
      _gameWS?.startGame();
    } catch (e) {
      rethrow;
    }
  }

  /// Sends a vote for a category through the game WebSocket using [categoryName].
  /// Throws an exception if the vote command fails.
  void voteOnCategory(String categoryName) {
    try {
      _gameWS?.voteOnCategory(categoryName);
    } catch (e) {
      rethrow;
    }
  }

  /// Sends an answer for a question through the game WebSocket with the given [questionId] and [answer].
  /// Throws an exception if the answer command fails.
  void answerQuestion(int questionId, String answer) {
    try {
      _gameWS?.answerQuestion(questionId, answer);
    } catch (e) {
      rethrow;
    }
  }

  /// Sends a chat message through the chat WebSocket using the provided [message].
  /// Throws an exception if sending the chat message fails.
  void sendChat(String message) {
    try {
      _chatWS?.sendChat(message);
    } catch (e) {
      rethrow;
    }
  }
}
