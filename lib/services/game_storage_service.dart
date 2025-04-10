import 'package:shared_preferences/shared_preferences.dart';

class GameStorageService {

  /// Saves the [gameId] persistently.
  /// Returns true if the game ID is successfully saved, or false if an error occurs.
  Future<bool> saveGameId(int gameId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("game_id", gameId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the saved game ID.
  /// Returns the game ID if found, or null if it doesn't exist or an error occurs.
  Future<int?> getGameId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt("game_id");
    } catch (e) {
      return null;
    }
  }

  /// Clears the saved game ID.
  /// Returns true if the game ID is successfully cleared, or false if an error occurs.
  Future<bool> clearGameId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("game_id");
      return true;
    } catch (e) {
      return false;
    }
  }
}