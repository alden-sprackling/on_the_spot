import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../exceptions/exceptions.dart';
import '../models/game.dart';
import 'auth_storage_service.dart';
import 'game_storage_service.dart';

class GameService {
  final String _baseUrl = baseURL;
  final AuthStorageService _authStorageService = AuthStorageService();
  final GameStorageService _gameStorageService = GameStorageService();

  /// Creates a new game session on the backend.
  /// Returns the created [Game] object if the game is successfully created.
  /// Throws a [GameServiceException] if the game creation fails.
  Future<Game> createGame() async {
    final token = await _authStorageService.getSessionToken();
    final url = Uri.parse('$_baseUrl/game');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final game = Game.fromJson(data);
      await _gameStorageService.saveGameId(game.id);
      return game;
    } else {
      throw GameServiceException(GameServiceErrorType.creationFailed);
    }
  }

  /// Retrieves game session details from the backend for the provided [gameId].
  /// Returns the [Game] object if the fetch is successful.
  /// Throws a [GameServiceException] if fetching the game details fails.
  Future<Game> getGame(int gameId) async {
    final token = await _authStorageService.getSessionToken();
    final url = Uri.parse('$_baseUrl/game/$gameId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Game.fromJson(data);
    } else {
      throw GameServiceException(GameServiceErrorType.fetchFailed);
    }
  }

  /// Restores a game session using the saved game ID.
  /// If a saved game ID is found, attempts to fetch the game details by calling [getGame].
  /// If loading the game fails, the saved game ID is cleared and the error is rethrown.
  /// Returns the [Game] object if the restore is successful, or null if no saved game exists.
  Future<Game?> restoreGame() async {
    final savedGameId = await _gameStorageService.getGameId();
    try {
      if (savedGameId != null) {
        return await getGame(savedGameId);
      } else {
        return null;
      }
    } catch (e) {
      // If loading fails (e.g., fetch failed), clear the saved game id.
      await _gameStorageService.clearGameId();
      rethrow;
    }
  }

  /// Allows a player to join an existing game session with the provided [gameId].
  /// Returns the updated [Game] object if join is successful.
  /// Throws a [GameServiceException] if joining the game fails.
  Future<Game> joinGame(int gameId) async {
    final token = await _authStorageService.getSessionToken();
    final url = Uri.parse('$_baseUrl/game/$gameId/join');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final game = Game.fromJson(data);
      await _gameStorageService.saveGameId(game.id);
      return game;
    } else {
      throw GameServiceException(GameServiceErrorType.joinFailed);
    }
  }
}