import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:on_the_spot/services/auth_storage_service.dart';
import '../constants/constants.dart';
import '../exceptions/exceptions.dart';
import '../models/user.dart';

class UserService {
  final String _baseUrl = baseURL;
  final AuthStorageService _authStorageService = AuthStorageService();

  /// Gets the current user's information using the stored session token.
  /// Returns the [User] object if the fetch is successful.
  /// Throws a [UserServiceException] if fetching the user information fails.
  Future<User> getUser() async {
    final token = await _authStorageService.getSessionToken(); 
    final url = Uri.parse('$_baseUrl/user');
    final response = await http.get(
      url, 
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw UserServiceException(UserServiceErrorType.fetchFailed);
    }
  }

  /// Creates a new user on the backend with the provided [username] and [profilePicture].
  /// Returns the created [User] object if successful.
  /// Throws a [UserServiceException] if the creation fails.
  Future<User> createUser(String username, ProfilePicture profilePicture) async {
    final token = await _authStorageService.getSessionToken();
    final url = Uri.parse('$_baseUrl/user');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'profile_picture': profilePicture.toJson(),
      }),
    );
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw UserServiceException(UserServiceErrorType.createFailed);
    }
  }

  /// Updates the user's username on the backend with the provided [username].
  /// Returns the updated [User] object if successful.
  /// Throws a [UserServiceException] if updating the username fails.
  Future<User> updateUsername(String username) async {
    final token = await _authStorageService.getSessionToken(); 
    final url = Uri.parse('$_baseUrl/user/username');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'username': username}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw UserServiceException(UserServiceErrorType.updateUsernameFailed);
    }
  }

  /// Updates the user's profile picture on the backend with the provided [profilePicture].
  /// Returns the updated [User] object if successful.
  /// Throws a [UserServiceException] if updating the profile picture fails.
  Future<User> updateProfilePicture(ProfilePicture profilePicture) async {
    final token = await _authStorageService.getSessionToken();
    final url = Uri.parse('$_baseUrl/user/profilePicture');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'profile_picture': profilePicture.toJson()}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw UserServiceException(UserServiceErrorType.profilePictureUpdateFailed);
    }
  }

  // Updates the user's IQ points on the backend with the provided [iqPoints].
  /// **Note:** This method should only be called by system-level logic.
  /// Returns the updated [User] object if successful.
  /// Throws a [UserServiceException] if updating the IQ points fails.
  Future<User> updateIqPoints(int iqPoints) async {
    final token = await _authStorageService.getSessionToken(); 
    final url = Uri.parse('$_baseUrl/user/iqPoints');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'iq_points': iqPoints}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw UserServiceException(UserServiceErrorType.iqPointsUpdateFailed);
    }
  }

  /// Deletes the user account on the backend and clears secure storage.
  /// Returns true if deletion is successful.
  /// Throws a [UserServiceException] if deleting the user fails.
  Future<bool> deleteUser() async {
    final token = await _authStorageService.getSessionToken();
    final url = Uri.parse('$_baseUrl/user');
    final response = await http.delete(
      url, 
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
    if (response.statusCode == 200) {
      return _authStorageService.deleteTokens();
    } else {
      throw UserServiceException(UserServiceErrorType.deleteUserFailed);
    }
  }
}