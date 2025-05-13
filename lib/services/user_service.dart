// lib/src/services/user_service.dart

import 'package:dio/dio.dart';
import 'package:on_the_spot/models/errors.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/user.dart';

/// Service for retrieving and updating the authenticated user's profile
class UserService {
  final ApiClient _client = ApiClient();

  /// Fetch the current user's profile
  Future<User> getProfile() async {
    try {
      final Response<dynamic> response =
          await _client.get<dynamic>(Endpoints.getProfile);
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('user')) {
        return User.fromJson(data['user'] as Map<String, dynamic>);
      } else if (data is Map<String, dynamic>) {
        return User.fromJson(data);
      } else {
        throw ApiError('Unexpected response format');
      }
    } on DioException {
      throw ApiError('Failed to load profile');
    }
  }

  /// Update the current user's profile fields
  Future<User> updateProfile({
    String? name,
    String? profilePic,
    int? iq,
  }) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (profilePic != null) data['profile_pic'] = profilePic;
    if (iq != null) data['iq'] = iq;

    try {
      final Response<dynamic> response =
          await _client.put<dynamic>(
        Endpoints.updateProfile,
        data: data,
      );
      final body = response.data;
      if (body is Map<String, dynamic> && body.containsKey('user')) {
        return User.fromJson(body['user'] as Map<String, dynamic>);
      } else if (body is Map<String, dynamic>) {
        return User.fromJson(body);
      } else {
        throw ApiError('Unexpected response format');
      }
    } on DioException {
      throw ApiError('Failed to update profile');
    }
  }
}
