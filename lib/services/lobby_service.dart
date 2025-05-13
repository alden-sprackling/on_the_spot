import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/lobby.dart';

/// Service for creating and managing lobbies
class LobbyService {
  final ApiClient _client = ApiClient();

  /// Create a new lobby. Returns the full Lobby object.
  Future<Lobby> createLobby(
    String hostId,
    bool isPublic,
  ) async {
    final Response<Map<String, dynamic>> response = await _client.post(
      Endpoints.createLobby,
      data: {
        'hostId': hostId,
        'isPublic': isPublic,
      },
    );

    // Parse and return the full Lobby
    return Lobby.fromJson(response.data!);
  }

  /// Retrieve lobby details by code
  Future<Lobby> getLobby(String code) async {
    final Response<Map<String, dynamic>> response = await _client.get(
      Endpoints.getLobby.replaceAll('{code}', code),
    );
    return Lobby.fromJson(response.data!);
  }

  /// Join an existing lobby
  Future<void> joinLobby(String code, String userId) async {
    await _client.post(
      Endpoints.joinLobby.replaceAll('{code}', code),
      data: {'userId': userId},
    );
  }

  /// Leave a lobby
  Future<void> leaveLobby(String code, String userId) async {
    await _client.post(
      Endpoints.leaveLobby.replaceAll('{code}', code),
      data: {'userId': userId},
    );
  }

  /// Toggle lobby privacy (must include hostId for authorization)
  Future<void> togglePrivacy(
    String code,
    String hostId,
    bool isPublic,
  ) async {
    await _client.patch(
      Endpoints.toggleLobbyPrivacy.replaceAll('{code}', code),
      data: {
        'hostId': hostId,
        'isPublic': isPublic,
      },
    );
  }
}