// lib/src/providers/tier_provider.dart

import 'package:flutter/material.dart';
import 'package:on_the_spot/models/errors.dart';
import '../services/tier_service.dart';
import '../models/tier.dart';

/// Manages fetching IQ tier statistics and the current user's tier via TierService
class TierProvider extends ChangeNotifier {
  final TierService _tierService = TierService();

  List<Tier> _tiers = [];
  int? _myTier;
  bool _isLoading = false;

  List<Tier> get tiers => List.unmodifiable(_tiers);
  int? get myTier => _myTier;
  bool get isLoading => _isLoading;

  /// Fetches tier statistics and the authenticated user's tier.
  /// Throws ApiError on failure.
  Future<void> fetchTierStats() async {
    _setLoading(true);
    try {
      final stats = await _tierService.getTierStats();
      _tiers = stats.tiers;
      _myTier = stats.myTier;
      notifyListeners();
    } catch (e) {
      throw ApiError('Failed to fetch tier stats');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
