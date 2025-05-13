import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Wrapper around Socket.IO client for real-time game updates.
class SocketService {
  final io.Socket _socket;

  // StreamControllers for various events
  final StreamController<Map<String, dynamic>> _lobbyUpdateController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _gameStartedController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _roundIntroductionController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _categoryVoteUpdateController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _categoryChosenController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _playerUpController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _questionController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _answerResultController = StreamController.broadcast();
  final StreamController<List<Map<String, dynamic>>> _roundLeaderboardController = StreamController.broadcast();
  final StreamController<List<Map<String, dynamic>>> _finalLeaderboardController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _chatMessageController = StreamController.broadcast();

  /// Stream of lobby updates: contains { players, hostId, isPublic }
  Stream<Map<String, dynamic>> get lobbyUpdate => _lobbyUpdateController.stream;
  /// Stream emitting when the game starts: { gameId }
  Stream<Map<String, dynamic>> get gameStarted => _gameStartedController.stream;
  /// Stream emitting round intro info: { round, difficulty, points, duration }
  Stream<Map<String, dynamic>> get roundIntroduction => _roundIntroductionController.stream;
  /// Stream emitting live vote tallies: { votes: List<{categoryId, count}> }
  Stream<Map<String, dynamic>> get categoryVoteUpdate => _categoryVoteUpdateController.stream;
  /// Stream emitting the chosen category: { categoryId }
  Stream<Map<String, dynamic>> get categoryChosen => _categoryChosenController.stream;
  /// Stream for player-up events: { userId, round, categoryId, duration }
  Stream<Map<String, dynamic>> get playerUp => _playerUpController.stream;
  /// Stream emitting question display info: { text, duration }
  Stream<Map<String, dynamic>> get question => _questionController.stream;
  /// Stream emitting answer results: { userId, correct, pointsAwarded }
  Stream<Map<String, dynamic>> get answerResult => _answerResultController.stream;
  /// Stream emitting round leaderboard: List<{ userId, pointsTotal, rank }>
  Stream<List<Map<String, dynamic>>> get roundLeaderboard => _roundLeaderboardController.stream;
  /// Stream emitting final leaderboard: List<{ userId, pointsTotal, oldIQ, iqDelta, newIQ }>
  Stream<List<Map<String, dynamic>>> get finalLeaderboard => _finalLeaderboardController.stream;
  /// Stream emitting new chat messages: { id, gameId, userId, message, sentAt }
  Stream<Map<String, dynamic>> get chatMessage => _chatMessageController.stream;

  SocketService(String uri, String token)
      : _socket = io.io(
          uri,
          io.OptionBuilder()
              .setTransports(['websocket'])
              .setExtraHeaders({'Authorization': 'Bearer \$token'})
              .build(),
        ) {
    _socket.connect();

    _socket.on('lobbyUpdate', (data) {
      _lobbyUpdateController.add(Map<String, dynamic>.from(data));
    });
    _socket.on('gameStarted', (data) {
      _gameStartedController.add(Map<String, dynamic>.from(data));
    });
    _socket.on('roundIntroduction', (data) {
      _roundIntroductionController.add(Map<String, dynamic>.from(data));
    });
    _socket.on('categoryVoteUpdate', (data) {
      _categoryVoteUpdateController.add({'votes': List<Map<String, dynamic>>.from(data)});
    });
    _socket.on('categoryChosen', (data) {
      _categoryChosenController.add(Map<String, dynamic>.from(data));
    });
    _socket.on('playerUp', (data) {
      _playerUpController.add(Map<String, dynamic>.from(data));
    });
    _socket.on('question', (data) {
      _questionController.add(Map<String, dynamic>.from(data));
    });
    _socket.on('answerResult', (data) {
      _answerResultController.add(Map<String, dynamic>.from(data));
    });
    _socket.on('roundLeaderboard', (data) {
      _roundLeaderboardController.add(List<Map<String, dynamic>>.from(data));
    });
    _socket.on('finalLeaderboard', (data) {
      _finalLeaderboardController.add(List<Map<String, dynamic>>.from(data));
    });
    _socket.on('chatMessage', (data) {
      _chatMessageController.add(Map<String, dynamic>.from(data));
    });
  }

  /// Lobby socket actions
  void joinLobby(String userId, String code) {
    _socket.emit('joinLobby', {'userId': userId, 'code': code});
  }

  void leaveLobby(String userId, String code) {
    _socket.emit('leaveLobby', {'userId': userId, 'code': code});
  }

  void togglePrivacy(String hostId, String code, bool isPublic) {
    _socket.emit('togglePrivacy', {'hostId': hostId, 'code': code, 'isPublic': isPublic});
  }

  void startGame(String hostId, String code) {
    _socket.emit('startGame', {'hostId': hostId, 'code': code});
  }

  /// Game socket actions
  void voteCategory(String gameId, int round, String userId, String categoryId) {
    _socket.emit('voteCategory', {
      'gameId': gameId,
      'round': round,
      'userId': userId,
      'categoryId': categoryId,
    });
  }

  void submitAnswer(String gameId, int round, String userId, String answer) {
    _socket.emit('submitAnswer', {
      'gameId': gameId,
      'round': round,
      'userId': userId,
      'answer': answer,
    });
  }

  void sendMessage(String gameId, String userId, String message) {
    _socket.emit('sendMessage', {'gameId': gameId, 'userId': userId, 'message': message});
  }

  /// Disconnect socket and close streams
  void dispose() {
    _socket.dispose();
    _lobbyUpdateController.close();
    _gameStartedController.close();
    _roundIntroductionController.close();
    _categoryVoteUpdateController.close();
    _categoryChosenController.close();
    _playerUpController.close();
    _questionController.close();
    _answerResultController.close();
    _roundLeaderboardController.close();
    _finalLeaderboardController.close();
    _chatMessageController.close();
  }
}
