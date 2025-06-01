// lib/src/providers/game_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_the_spot/api/endpoints.dart';
import 'package:on_the_spot/models/errors.dart';
import 'package:on_the_spot/models/message.dart';
import 'package:on_the_spot/providers/message_provider.dart';
import '../services/socket_service.dart';
import '../models/category.dart';
import '../models/chat_message.dart';
import '../models/game_player.dart';
import 'user_provider.dart';

enum RoundState {
  idle,
  roundIntroduction,
  categoryVoteUpdate,
  categoryChosen,
  playerUp,
  question,
  answerResult,
  roundLeaderboard,
  finalLeaderboard,
}

/// Manages game state, real-time updates, and actions via services and SocketService
class GameProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final UserProvider _userProvider;
  final MessageProvider _messageProvider;

  SocketService? _socket;

  String? _gameId;
  int _round = 1;
  String _difficulty = 'Very Easy';
  int _points = 10;
  Duration _duration = Duration(seconds: 3);
  List<Category> _categories = [];
  Map<String, int> _voteTally = {};
  String? _chosenCategory;
  String? _playerUp;
  String? _currentQuestionId;
  String? _currentQuestion;
  Map<String, dynamic>? _answerResult;
  List<GamePlayer> _roundLeaderboard = [];
  List<GamePlayer> _finalLeaderboard = [];
  final List<ChatMessage> _chatMessages = [];
  RoundState _roundState = RoundState.roundIntroduction;

  GameProvider(this._userProvider, this._messageProvider);

  String? get gameId => _gameId;
  int get round => _round;
  String get difficulty => _difficulty;
  int get points => _points;
  Duration get duration => _duration;
  List<Category> get categories => List.unmodifiable(_categories);
  Map<String, int> get voteTally => Map.unmodifiable(_voteTally);
  String? get chosenCategory => _chosenCategory;
  String? get playerUp => _playerUp;
  String? get currentQuestionId => _currentQuestionId;
  String? get currentQuestion => _currentQuestion;
  Map<String, dynamic>? get answerResult => _answerResult;
  List<GamePlayer> get roundLeaderboard => List.unmodifiable(_roundLeaderboard);
  List<GamePlayer> get finalLeaderboard => List.unmodifiable(_finalLeaderboard);
  List<ChatMessage> get chatMessages => List.unmodifiable(_chatMessages);
  RoundState get roundState => _roundState;

  /// Initialize game: set gameId, fetch categories, connect socket, and register listeners
  Future<void> initGame(String gameId) async {
    try {
      _gameId = gameId;

      // connect socket
      final token = await _storage.read(key: 'access_token');
      if (token == null) throw ApiError('Not authenticated');
      _socket?.dispose();
      _socket = SocketService(Endpoints.wsUrl, token);

      _socket!.roundIntroduction.listen((data) {
        _round = data['round'] as int;
        _difficulty = data['difficulty'] as String;
        _points = data['points'] as int;
        _duration = Duration(seconds: data['duration'] as int);
        _voteTally.clear();
        _chosenCategory = null;
        _roundState = RoundState.roundIntroduction;
        notifyListeners();
      });

      _socket!.categoryVoteUpdate.listen((data) {
        // 1) votes is always there
        final votes = data['votes'] as List<dynamic>;

        // 2) only overwrite duration if it was sent
        if (data['duration'] != null) {
          _duration = Duration(seconds: data['duration'] as int);
        }

        // 3) only overwrite categories if they were sent
        if (data['availableCategories'] != null) {
          _categories = (data['availableCategories'] as List<dynamic>)
              .map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        // 4) rebuild tally
        _voteTally = {
          for (var v in votes) v['categoryId'] as String : v['count'] as int
        };

        _roundState = RoundState.categoryVoteUpdate;
        notifyListeners();
      });

      _socket!.categoryChosen.listen((data) {
        _chosenCategory = data['categoryId'] as String;
        _duration = Duration(seconds: data['duration'] as int);
        _roundState = RoundState.categoryChosen;
        notifyListeners();
      });

      _socket!.playerUp.listen((data) async {
        _playerUp = data['userId'] as String;
        _duration = Duration(seconds: 3);
        _roundState = RoundState.playerUp;
        notifyListeners();
      });

      _socket!.question.listen((data) {
        _currentQuestionId = data['questionId'] as String;
        _currentQuestion = data['text'] as String;
        _duration = Duration(seconds: data['duration'] as int);
        _roundState = RoundState.question;
        notifyListeners();
      });

      _socket!.answerResult.listen((data) {
        _answerResult = {
          'correct': data['correct'] as bool,
          'pointsAwarded': data['pointsAwarded'] as int,
        };
        _duration = Duration(seconds: data['duration'] as int);
        _roundState = RoundState.answerResult;
        notifyListeners();
      });

      _socket!.roundLeaderboard.listen((data) {
        _roundLeaderboard = (data['standings'] as List<dynamic>)
            .map((e) => GamePlayer.fromJson(e as Map<String, dynamic>))
            .toList();
        _duration = Duration(seconds: data['duration'] as int);
        _roundState = RoundState.roundLeaderboard;
        notifyListeners();
      });

      _socket!.finalLeaderboard.listen((data) {
        _finalLeaderboard = (data['finalStandings'] as List<dynamic>)
            .map((e) => GamePlayer.fromJson(e as Map<String, dynamic>))
            .toList();
        _roundState = RoundState.finalLeaderboard;
        notifyListeners();
      });

      _socket!.chatMessage.listen((data) {
        final msg = ChatMessage.fromJson(data['message']);
        _messageProvider.addMessage(
          Message(
            content: msg.message,
            type: MessageType.chat,
          ),
        );
        _chatMessages.add(msg);
        notifyListeners();
      });
    } catch (e) {
      throw ApiError('Failed to initialize game');
    } 
  }

  /// Vote for a category in current round
  Future<void> voteCategory(String categoryId) async {
    if (_gameId == null || _userProvider.user == null) {
      throw ApiError('Not ready');
    }
    try {
      _socket!.voteCategory(_gameId!, _round, _userProvider.user!.id, categoryId);
    } catch (e) {
      throw ApiError('Failed to vote');
    }
  }

  /// Submit an answer for current round
  Future<void> submitAnswer(String answer) async {
    if (_gameId == null || _userProvider.user == null) {
      throw ApiError('Not ready');
    }
    try {
      _socket!.submitAnswer(_gameId!, _round, _userProvider.user!.id, _currentQuestionId!, _chosenCategory!, answer);
    } catch (e) {
      throw ApiError('Failed to submit answer');
    }
  }

  /// Send chat message
  Future<void> sendMessage(String message) async {
    if (_gameId == null || _userProvider.user == null) {
      throw ApiError('Not ready');
    }
    try {
      _socket!.sendMessage(_gameId!, _userProvider.user!.id, message);
    } catch (e) {
      throw ApiError('Failed to send message');
    }
  }

  @override
  void dispose() {
    _socket?.dispose();
    super.dispose();
  }
}
