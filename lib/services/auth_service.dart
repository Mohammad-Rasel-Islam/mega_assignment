import '../utils/constants.dart';
import 'api_service.dart';
import 'storage_service.dart';
import '../models/user_model.dart';

/// Handles all authentication API calls (login, register, logout, fetch user).
class AuthService {
  final ApiService _api;
  final StorageService _storage = StorageService();

  AuthService(this._api);

  // ── Login ──────────────────────────────────────────────────────────────

  /// POST /api/login → saves token & returns [UserModel].
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      ApiEndpoints.login,
      data: {'email': email.trim(), 'password': password},
    );
    return _parseAuthResponse(response);
  }

  // ── Register ───────────────────────────────────────────────────────────

  /// POST /api/register → saves token & returns [UserModel].
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      ApiEndpoints.register,
      data: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'password_confirmation': password,
      },
    );
    return _parseAuthResponse(response);
  }

  // ── Helper to extract token & user from API response ─────────────────────

  Future<UserModel> _parseAuthResponse(dynamic response) async {
    Map<String, dynamic> map = {};
    if (response is Map<String, dynamic>) {
      map = response;
    }

    // Support 'token', 'access_token', or nested 'data.token' / 'data.access_token'
    final token = map['token'] ??
        map['access_token'] ??
        map['data']?['token'] ??
        map['data']?['access_token'];

    if (token != null && token.toString().isNotEmpty) {
      await _storage.saveToken(token.toString());
    }

    // Extract user map (supports 'user', 'data.user', 'data', or top-level map)
    dynamic userMap = map['user'] ?? map['data']?['user'] ?? map['data'] ?? map;
    if (userMap is Map<String, dynamic>) {
      return UserModel.fromJson(userMap);
    }
    
    throw const ApiException('Invalid authentication response structure from server.');
  }

  // ── Logout ─────────────────────────────────────────────────────────────

  /// POST /api/logout → revokes token & clears local storage.
  Future<void> logout() async {
    try {
      await _api.post(ApiEndpoints.logout);
    } catch (_) {
      // Always clear local token even if server call fails
    } finally {
      await _storage.clearToken();
    }
  }

  // ── Fetch current user ─────────────────────────────────────────────────

  /// GET /api/user → validates stored token and returns [UserModel].
  Future<UserModel> fetchUser() async {
    final response = await _api.get(ApiEndpoints.user);
    Map<String, dynamic> userMap = {};
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        userMap = response['data'] as Map<String, dynamic>;
      } else if (response['user'] is Map<String, dynamic>) {
        userMap = response['user'] as Map<String, dynamic>;
      } else {
        userMap = response;
      }
    }
    return UserModel.fromJson(userMap);
  }
}
