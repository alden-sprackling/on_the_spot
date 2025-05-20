import 'package:flutter/material.dart';
import 'package:on_the_spot/api/endpoints.dart';
import '../services/lobby_service.dart';
import '../models/lobby.dart';
import '../models/lobby_player.dart';
import '../services/socket_service.dart';
import 'user_provider.dart';
import '../models/errors.dart';

class LobbyProvider extends ChangeNotifier {
  final LobbyService _lobbyService = LobbyService();
  final UserProvider _userProvider;
  SocketService? _socketService;

  Lobby? _lobby;
  List<LobbyPlayer> _players = [];
  bool _isLoading = false;
  bool _gameStarted = false;
  String? _gameId;

  Lobby? get lobby => _lobby;
  List<LobbyPlayer> get players => List.unmodifiable(_players);
  bool get isLoading => _isLoading;
  bool get gameStarted => _gameStarted;
  SocketService? get socketService => _socketService;
  String? get gameId => _gameId;

  LobbyProvider(this._userProvider);

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _socketService?.dispose();
    super.dispose();
  }

  /// Create a new lobby, update state, and connect socket
  Future<void> createLobby(String hostId, bool isPublic) async {
    _setLoading(true);
    try {
      final Lobby newLobby = await _lobbyService.createLobby(hostId, isPublic);
      _lobby = newLobby;
      _players = newLobby.players;
      notifyListeners();
      await _initSocket(newLobby.code);
    } catch (e) {
      throw ApiError('Failed to create lobby');
    } finally {
      _setLoading(false);
    }
  }

  /// Join an existing lobby, refresh state, and connect socket
  Future<void> joinLobby(String code, String userId) async {
    _setLoading(true);
    try {
      final Lobby updated = await _lobbyService.joinLobby(code, userId);
      _lobby = updated;
      _players = updated.players;
      notifyListeners();
      await _initSocket(code);
    } catch (e) {
      throw ApiError('Failed to join lobby');
    } finally {
      _setLoading(false);
    }
  }

  /// Auto join a lobby, refresh state, and connect socket
  Future<void> autoJoinLobby(String userId) async {
    _setLoading(true);
    try {
      final Lobby updated = await _lobbyService.autoJoinLobby(userId);
      _lobby = updated;
      _players = updated.players;
      notifyListeners();
      await _initSocket(_lobby!.code);
    } catch (e) {
      throw ApiError('Failed to auto join lobby');
    } finally {
      _setLoading(false);
    }
  }

  /// Leave the lobby and refresh state
  Future<void> leaveLobby(String code, String userId) async {
    _setLoading(true);
    try {
      await _lobbyService.leaveLobby(code, userId);
      _lobby = null;
      _players.clear();
      notifyListeners();
    } catch (e) {
      throw ApiError('Failed to leave lobby');
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle lobby privacy and update state
  Future<void> togglePrivacy(bool isPublic) async {
    if (_lobby == null) return;
    _setLoading(true);
    try {
      // Include hostId from the current user for authorization
      final String hostId = _userProvider.user!.id;
      await _lobbyService.togglePrivacy(_lobby!.code, hostId, isPublic);
      notifyListeners();
    } catch (e) {
      throw ApiError('Failed to update lobby privacy');
    } finally {
      _setLoading(false);
    }
  }

  // Initialize WebSocket connection and listeners
  Future<void> _initSocket(String code) async {
    await _userProvider.fetchProfile();
    if (_userProvider.user == null) {
      throw ApiError('User not authenticated');
    }
    // Dispose previous socket if exists
    _socketService?.dispose();
    _socketService = SocketService(
      Endpoints.wsUrl,
      _userProvider.user!.id,
    );
    // Subscribe to lobby updates
    _socketService!.lobbyUpdate.listen((data) {
      // Build JSON for parsing, always using the known code
      final lobbyJson = {
        'code': code,
        'hostId': data['hostId'],
        'isPublic': data['isPublic'],
        'createdAt': _lobby?.createdAt.toIso8601String() ?? DateTime.now().toIso8601String(),
        'players': data['players'],
      };

      // Parse updated lobby (handles null _lobby too)
      _lobby = Lobby.fromJson(lobbyJson);
      _players = _lobby!.players;
      notifyListeners();
    });
    // Listen for game start
    _socketService!.gameStarted.listen((data) {
      _gameId = data['gameId'] as String;  
      _gameStarted = true;
      notifyListeners();
    });

    _socketService!.joinLobby(_userProvider.user!.id, _lobby!.code);
  }
}