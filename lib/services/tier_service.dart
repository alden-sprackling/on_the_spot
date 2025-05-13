// lib/src/services/tier_service.dart

import 'package:dio/dio.dart';
import 'package:on_the_spot/models/errors.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/tier.dart';

/// Service for fetching IQ tier statistics and the current user's tier
class TierService {
  final ApiClient _client = ApiClient();

  /// Retrieve TierStats, which includes counts for each tier and the authenticated user's tier
  Future<TierStats> getTierStats() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(Endpoints.getTiers);
      return TierStats.fromJson(response.data!);
    } on DioException {
      throw ApiError('Failed to fetch tier stats');
    }
  }
}
