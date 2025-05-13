import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import '../models/errors.dart';

/// Provider for available categories in a game.
class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService;

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  CategoryProvider(this._categoryService);

  List<Category> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch unused categories for the specified game.
  Future<void> fetchCategories(String gameId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _categories = await _categoryService.getAvailableCategories(gameId);
    } on ApiError catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}