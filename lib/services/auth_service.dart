// lib/src/services/auth_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/user.dart';

class Tokens {
  final String accessToken;
  final String refreshToken;

  Tokens({required this.accessToken, required this.refreshToken});

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
      );
}

class AuthResult {
  final User user;
  final Tokens tokens;

  AuthResult({required this.user, required this.tokens});

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        user: User.fromJson(json['user'] as Map<String, dynamic>),
        tokens: Tokens.fromJson(json['tokens'] as Map<String, dynamic>),
      );
}

/// Service for authentication-related API calls
class AuthService {
  final ApiClient _client = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Send an SMS verification code to a phone number
  Future<void> sendCode(String phone) async {
    await _client.post<void>(
      Endpoints.sendCode,
      data: {'phone': phone},
    );
  }

  /// Verify the code and retrieve user + tokens, then store tokens
  Future<AuthResult> verifyCode(String phone, String code) async {
    final response = await _client.post<Map<String, dynamic>>(
      Endpoints.verifyCode,
      data: {'phone': phone, 'code': code},
    );
    final AuthResult result = AuthResult.fromJson(response.data!);
    // Persist tokens
    await _storage.write(key: 'access_token', value: result.tokens.accessToken);
    await _storage.write(key: 'refresh_token', value: result.tokens.refreshToken);

    return result;
  }

  /// Refresh access/refresh tokens, store them, and return
  Future<Tokens> refreshTokens(String refreshToken) async {
    final response = await _client.post<Map<String, dynamic>>(
      Endpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );

    // Some controllers wrap tokens inside a `tokens` object
    final tokenJson = (response.data!.containsKey('tokens')
            ? response.data!['tokens']
            : response.data) as Map<String, dynamic>;

    final tokens = Tokens.fromJson(tokenJson);

    // Persist new tokens
    await _storage.write(key: 'access_token', value: tokens.accessToken);
    await _storage.write(key: 'refresh_token', value: tokens.refreshToken);

    return tokens;
  }
}
