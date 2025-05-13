// lib/src/services/picture_service.dart

import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/profile_picture.dart';

/// Service for fetching profile pictures based on IQ tiers
class PictureService {
  final ApiClient _client = ApiClient();

  /// Fetch avatar pictures that the authenticated user is eligible to use
  ///
  /// Uses the authenticated user's ID from the JWT token; no parameters required.
  Future<List<ProfilePicture>> getPictures() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(Endpoints.getPictures);
      final picturesJson = response.data!['pictures'] as List<dynamic>;
      return picturesJson
          .map((item) => ProfilePicture.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    }
  }
}
