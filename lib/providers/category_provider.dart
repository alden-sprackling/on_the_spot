import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

/// Provider for available categories in a game.
class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService;

  List<Category> _categories = [];
  bool _isLoading = false;

  CategoryProvider(this._categoryService);

  List<Category> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;

  /// Fetch unused categories for the specified game.
  Future<void> fetchCategories(String gameId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _categoryService.getAvailableCategories(gameId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}