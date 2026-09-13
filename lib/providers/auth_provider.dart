import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

/// Manages authentication state for the entire app.
///
/// On startup: reads the stored token → calls GET /api/user to validate it.
/// On login / signup: delegates to [AuthService], stores token, updates state.
/// On logout: calls POST /api/logout, clears token, resets state.
class AuthProvider with ChangeNotifier {
  final ApiService _api;
  late final AuthService _authService;
  final StorageService _storage = StorageService();

  UserModel? _user;
  bool _isLoading = true; // true while checking stored token on startup
  String? _errorMessage;

  AuthProvider(this._api) {
    _authService = AuthService(_api);
    _initFromStorage();
  }

  // ── Getters ────────────────────────────────────────────────────────────

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isLoggedIn => isAuthenticated;
  String? get errorMessage => _errorMessage;

  // ── Startup token validation ───────────────────────────────────────────

  Future<void> _initFromStorage() async {
    _isLoading = true;
    notifyListeners();
    try {
      final hasToken = await _storage.hasToken();
      if (hasToken) {
        // Validate token with the server
        _user = await _authService.fetchUser();
      }
    } catch (_) {
      // Token invalid or expired — clear it
      await _storage.clearToken();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Login ──────────────────────────────────────────────────────────────

  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _clearError();
    try {
      _user = await _authService.login(email: email, password: password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_friendlyError(e));
      _setLoading(false);
      return false;
    }
  }

  // ── Register ───────────────────────────────────────────────────────────

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      _user = await _authService.register(
          name: name, email: email, password: password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_friendlyError(e));
      _setLoading(false);
      return false;
    }
  }

  // ── Update profile ─────────────────────────────────────────────────────

  Future<bool> updateProfile({String? name, File? imageFile}) async {
    if (_user == null) return false;
    _setLoading(true);
    _clearError();
    try {
      FormData formData = FormData();
      if (name != null && name.isNotEmpty) {
        formData.fields.add(MapEntry('name', name));
      }
      if (imageFile != null) {
        formData.files.add(MapEntry(
          'photo',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: 'profile.jpg',
          ),
        ));
      }
      // Method spoofing for Laravel PUT with multipart
      formData.fields.add(const MapEntry('_method', 'PUT'));

      final response = await _api.post(
        ApiEndpoints.user,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      _user = UserModel.fromJson(response as Map<String, dynamic>);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_friendlyError(e));
      _setLoading(false);
      return false;
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    try {
      await _authService.logout();
    } catch (_) {
      // Always clear local state even if server call fails
    } finally {
      _user = null;
      notifyListeners();
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _friendlyError(Object e) {
    if (e is ApiException) return e.message;
    return e.toString().replaceAll('Exception: ', '');
  }
}
