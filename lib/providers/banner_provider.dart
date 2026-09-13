import 'package:flutter/material.dart';
import '../models/banner_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

/// Manages promo banners state, fetched from GET /api/banners.
class BannerProvider with ChangeNotifier {
  final ApiService _api;

  List<BannerModel> _banners = [];
  bool _isLoading = false;
  String? _error;

  BannerProvider(this._api);

  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBanners() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _api.get(ApiEndpoints.banners);
      final list = response as List<dynamic>;
      _banners = list
          .map((j) => BannerModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
