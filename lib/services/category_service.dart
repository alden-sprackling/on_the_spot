// lib/src/services/category_service.dart

import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/category.dart';

/// Service for fetching categories available for a game
class CategoryService {
  final ApiClient _client = ApiClient();

  /// Retrieves the list of unused categories for the given game
  Future<List<Category>> getAvailableCategories(String gameId) async {
    try {
      final response = await _client.get<List<dynamic>>(
        Endpoints.getAvailableCategories.replaceAll('{gameId}', gameId),
      );
      final data = response.data!;
      print('Available categories: $data');
      return data
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException {
      // Optionally handle errors, e.g., log or rethrow with custom exception
      rethrow;
    }
  }
}
