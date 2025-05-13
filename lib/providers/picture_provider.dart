// lib/src/providers/picture_provider.dart

import 'package:flutter/material.dart';
import 'package:on_the_spot/models/errors.dart';
import '../services/picture_service.dart';
import '../models/profile_picture.dart';

/// Manages fetching profile pictures available to the authenticated user via PictureService
class PictureProvider extends ChangeNotifier {
  final PictureService _pictureService = PictureService();

  List<ProfilePicture> _pictures = [];
  bool _isLoading = false;

  List<ProfilePicture> get pictures => List.unmodifiable(_pictures);
  bool get isLoading => _isLoading;

  /// Fetches all profile pictures the user is eligible for.
  /// Throws ApiError on failure.
  Future<void> fetchPictures() async {
    _setLoading(true);
    try {
      _pictures = await _pictureService.getPictures();
      notifyListeners();
    } catch (e) {
      throw ApiError('Failed to fetch profile pictures');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
