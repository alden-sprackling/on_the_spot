// lib/src/providers/game_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_the_spot/api/endpoints.dart';
import 'package:on_the_spot/models/errors.dart';
import 'package:on_the_spot/models/message.dart';
import 'package:on_the_spot/providers/message_provider.dart';
import '../services/category_service.dart';
import '../services/chat_service.dart';
import '../services/socket_service.dart';
import '../models/category.dart';
import '../models/chat_message.dart';
import '../models/game_player.dart';
import '../models/question.dart';
import 'user_provider.dart';

/// Manages game state, real-time updates, and actions via services and SocketService
class GameProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  final ChatService _chatService = ChatService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final UserProvider _userProvider;
  final MessageProvider _messageProvider;

  SocketService? _socket;

  String? _gameId;
  int _round = 0;
  int _difficulty = 1;
  List<Category> _categories = [];
  Map<String, int> _voteTally = {};
  String? _chosenCategory;
  Question? _currentQuestion;
  Map<String, dynamic>? _answerResult;
  List<GamePlayer> _roundLeaderboard = [];
  List<GamePlayer> _finalLeaderboard = [];
  final List<ChatMessage> _chatMessages = [];
  bool _isLoading = false;
  bool _answered = false;

  GameProvider(this._userProvider, this._messageProvider);

  String? get gameId => _gameId;
  int get round => _round;
  int get difficulty => _difficulty;
  List<Category> get categories => List.unmodifiable(_categories);
  Map<String, int> get voteTally => Map.unmodifiable(_voteTally);
  String? get chosenCategory => _chosenCategory;
  Question? get currentQuestion => _currentQuestion;
  Map<String, dynamic>? get answerResult => _answerResult;
  List<GamePlayer> get roundLeaderboard => List.unmodifiable(_roundLeaderboard);
  List<GamePlayer> get finalLeaderboard => List.unmodifiable(_finalLeaderboard);
  List<ChatMessage> get chatMessages => List.unmodifiable(_chatMessages);
  bool get isLoading => _isLoading;
  bool get hasAnswered => _answered;

  /// Initialize game: set gameId, fetch categories, connect socket, and register listeners
  Future<void> initGame(String gameId) async {
    _setLoading(true);
    try {
      _gameId = gameId;
      // initial categories
      _categories = await _categoryService.getAvailableCategories(gameId);

      // connect socket
      final token = await _storage.read(key: 'access_token');
      if (token == null) throw ApiError('Not authenticated');
      _socket?.dispose();
      _socket = SocketService(Endpoints.wsUrl, token);

      _socket!.roundIntroduction.listen((data) {
        _round = data['roundNumber'] as int;
        _difficulty = data['difficulty'] as int;
        _voteTally.clear();
        _chosenCategory = null;
        _answered = false;
        notifyListeners();
      });

      _socket!.categoryVoteUpdate.listen((data) {
        final votes = data['votes'] as List<dynamic>;
        _voteTally = {for (var v in votes) v['categoryId'] as String: v['count'] as int};
        notifyListeners();
      });

      _socket!.categoryChosen.listen((data) {
        _chosenCategory = data['categoryId'] as String;
        notifyListeners();
      });

      _socket!.playerUp.listen((data) async {
        // when it's this player's turn, nothing to do here
      });

      _socket!.question.listen((data) {
        _currentQuestion = Question.fromJson(data);
        notifyListeners();
      });

      _socket!.answerResult.listen((data) {
        _answerResult = data;
        _answered = true;
        notifyListeners();
      });

      _socket!.roundLeaderboard.listen((data) {
        _roundLeaderboard = (data as List<dynamic>)
            .map((e) => GamePlayer.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      });

      _socket!.finalLeaderboard.listen((data) {
        _finalLeaderboard = (data as List<dynamic>)
            .map((e) => GamePlayer.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      });

      _socket!.chatMessage.listen((data) {
        final msg = ChatMessage.fromJson(data);
        // TODO: idk
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
    } finally {
      _setLoading(false);
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
      _socket!.submitAnswer(_gameId!, _round, _userProvider.user!.id, answer);
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
      await _chatService.sendMessage(_gameId!, _userProvider.user!.id, message);
    } catch (e) {
      throw ApiError('Failed to send message');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _socket?.dispose();
    super.dispose();
  }
}
