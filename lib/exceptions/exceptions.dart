// Phone number exception
class InputException implements Exception {
  final InputErrorType type;
  final String message;

  InputException(this.type, [this.message = '']);

  @override
  String toString() {
    final defaultMessages = {
      InputErrorType.invalidPhoneNumberFormat: "Phone number must be exactly 10 digits after the country code.",
      InputErrorType.invalidUsernameFormat: "Username cannot contain spaces.",
      InputErrorType.invalidUsernameLength: "Username must be 1 to 12 characters long.",
    };

    return message.isNotEmpty 
      ? message 
      : defaultMessages[type] ?? "Invalid input.";
  }
}

enum InputErrorType { 
  invalidPhoneNumberFormat,
  invalidUsernameFormat,
  invalidUsernameLength,
}

// User Service exception (for errors in fetching, creating, or updating user data)
class UserServiceException implements Exception {
  final UserServiceErrorType type;
  final String message;

  UserServiceException(this.type, [this.message = '']);

  @override
  String toString() {
    final defaultMessages = {
      UserServiceErrorType.fetchFailed: "Failed to fetch user data.",
      UserServiceErrorType.createFailed: "Failed to create user.",
      UserServiceErrorType.updateFailed: "Failed to update user.",
      UserServiceErrorType.updateUsernameFailed: "Failed to update username.",
      UserServiceErrorType.profilePictureUpdateFailed: "Failed to update profile picture.",
      UserServiceErrorType.iqPointsUpdateFailed: "Failed to update IQ points.",
      UserServiceErrorType.deleteUserFailed: "Failed to delete user.",
    };

    return message.isNotEmpty 
      ? message 
      : defaultMessages[type] ?? "User service failed.";
  }
}

enum UserServiceErrorType { 
  fetchFailed, 
  createFailed, 
  updateFailed, 
  updateUsernameFailed, 
  profilePictureUpdateFailed, 
  iqPointsUpdateFailed,
  deleteUserFailed
}

/// Custom exception thrown when a game is not loaded.
class GameException implements Exception {
  final GameErrorType type;
  final String message;

  GameException(this.type, [this.message = '']);

  @override
  String toString() {
    final defaultMessages = {
      GameErrorType.gameNotFound: "Game not found.",
    };

    return message.isNotEmpty
        ? message
        : defaultMessages[type] ?? "Game failed.";
  }
}

/// Enum for different types of GameNotLoaded errors.
enum GameErrorType {
  gameNotFound,
}

/// Custom exception for game service errors.
class GameServiceException implements Exception {
  final GameServiceErrorType type;
  final String message;

  GameServiceException(this.type, [this.message = '']);

  @override
  String toString() {
    final defaultMessages = {
      GameServiceErrorType.creationFailed: "Failed to create game.",
      GameServiceErrorType.fetchFailed: "Failed to fetch game details.",
      GameServiceErrorType.joinFailed: "Failed to join game.",
      GameServiceErrorType.updateFailed: "Failed to update game.",
      GameServiceErrorType.startFailed: "Failed to start game.",
      GameServiceErrorType.voteFailed: "Failed to vote on category.",
      GameServiceErrorType.answerFailed: "Failed to submit answer.",
      GameServiceErrorType.chatFailed: "Failed to send chat message.",
    };

    return message.isNotEmpty
        ? message
        : defaultMessages[type] ?? "Game service failed.";
  }
}

enum GameServiceErrorType {
  creationFailed,
  fetchFailed,
  joinFailed,
  updateFailed,
  startFailed,
  voteFailed,
  answerFailed,
  chatFailed,
}

// Authentication exception (for code verification, etc.)
class AuthenticationException implements Exception {
  final AuthenticationErrorType type;
  final String message;

  AuthenticationException(this.type, [this.message = '']);

  @override
  String toString() {
    final defaultMessages = {
      AuthenticationErrorType.failedToSend: "Failed to send authentication code.",
      AuthenticationErrorType.failedToVerify: "Authentication verification failed.",
      AuthenticationErrorType.invalidCode: "Invalid authentication code provided.",
    };

    return message.isNotEmpty 
      ? message 
      : defaultMessages[type] ?? "Authentication failed.";
  }
}

enum AuthenticationErrorType { 
  failedToSend, 
  failedToVerify, 
  invalidCode 
}

// Auth Service exception (for errors in token management, auto sign in, etc.)
class AuthServiceException implements Exception {
  final AuthServiceErrorType type;
  final String message;

  AuthServiceException(this.type, [this.message = '']);

  @override
  String toString() {
    final defaultMessages = {
      AuthServiceErrorType.tokenNotFound: "No session token found. Please authenticate.",
      AuthServiceErrorType.signInFailed: "Automatic sign in failed.",
      AuthServiceErrorType.refreshFailed: "Failed to refresh the access token.",
    };

    return message.isNotEmpty 
      ? message 
      : defaultMessages[type] ?? "Authentication service failed.";
  }
}

enum AuthServiceErrorType { 
  tokenNotFound, 
  signInFailed, 
  refreshFailed, 
}

class WebSocketException implements Exception {
  final WebSocketErrorType type;
  final String message;

  WebSocketException(this.type, [this.message = '']);

  @override
  String toString() {
    final defaultMessages = {
      WebSocketErrorType.connectionFailed: "WebSocket connection failed.",
      WebSocketErrorType.messageError: "Error processing WebSocket message.",
    };

    return message.isNotEmpty ? message : defaultMessages[type] ?? "WebSocket error.";
  }
}

enum WebSocketErrorType {
  connectionFailed,
  messageError,
}