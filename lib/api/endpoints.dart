// lib/src/api/endpoints.dart

class Endpoints {
  /// Base URL of your API
  static const String apiUrl = 'https://api.onthespotgame.com';
  static const String wsUrl = 'wss://ws.onthespotgame.com';

  // Authentication
  static const String sendCode = '/auth/send';
  static const String verifyCode = '/auth/verify';
  static const String refreshToken = '/auth/refresh';

  // Lobby
  static const String createLobby = '/lobbies';
  static const String getLobby = '/lobbies/{code}';
  static const String joinLobby = '/lobbies/{code}/join';
  static const String leaveLobby = '/lobbies/{code}/leave';
  static const String toggleLobbyPrivacy = '/lobbies/{code}/privacy';

  // Tier
  static const String getTiers = '/tiers';

  // Profile Pictures
  static const String getPictures = '/pictures';

  // User Profile
  static const String getProfile = '/users/profile';
  static const String updateProfile = '/users/profile';

  // Games (actions)
  static const String submitVote = '/games/{gameId}/vote';
  static const String submitAnswer = '/games/{gameId}/answer';
  static const String getLeaderboard = '/games/{gameId}/leaderboard';

  // Chat (within a game)
  static const String getMessages = '/games/{gameId}/chat';
  static const String sendMessage = '/games/{gameId}/chat';

  // Categories (within a game)
  static const String getAvailableCategories = '/games/{gameId}/categories';
}
