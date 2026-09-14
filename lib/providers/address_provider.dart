import 'package:flutter/material.dart';
import '../models/address_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

/// Manages saved delivery addresses.
class AddressProvider with ChangeNotifier {
  final ApiService _api;

  List<AddressModel> _addresses = [];
  bool _isLoading = false;
  String? _error;

  AddressProvider(this._api);

  // ── Getters ────────────────────────────────────────────────────────────

  List<AddressModel> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AddressModel? get defaultAddress =>
      _addresses.isNotEmpty ? _addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => _addresses.first,
      ) : null;

  // ── Fetch ──────────────────────────────────────────────────────────────

  /// GET /api/addresses
  Future<void> fetchAddresses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _api.get(ApiEndpoints.addresses);
      if (response is List) {
        _addresses = response
            .whereType<Map>()
            .map((j) => AddressModel.fromJson(Map<String, dynamic>.from(j)))
            .toList();
      }
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Save address ───────────────────────────────────────────────────────

  /// POST /api/addresses — returns the newly created address.
  Future<AddressModel?> saveAddress({
    required String label,
    required String fullAddress,
    double? lat,
    double? lng,
    bool isDefault = false,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.addresses,
        data: {
          'label': label,
          'full_address': fullAddress,
          'lat': lat,
          'lng': lng,
          'is_default': isDefault,
        },
      );
      final address = AddressModel.fromJson(response as Map<String, dynamic>);
      _addresses.add(address);
      notifyListeners();
      return address;
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
      notifyListeners();
      return null;
    }
  }

  // ── Place order ────────────────────────────────────────────────────────

  /// POST /api/orders with the selected address ID.
  /// Returns the created order id on success, or null on failure.
  Future<int?> placeOrder(int addressId) async {
    _error = null;
    try {
      final response = await _api.post(
        ApiEndpoints.orders,
        data: {'address_id': addressId},
      );
      if (response is Map) {
        final rawId = response['id'];
        return int.tryParse(rawId?.toString() ?? '');
      }
      return null;
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
      notifyListeners();
      return null;
    }
  }
}
