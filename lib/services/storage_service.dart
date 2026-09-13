import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

/// Handles persisting and retrieving the Bearer token from device storage.
/// This is the single source of truth for authentication state on-device.
class StorageService {
  // ── Token ─────────────────────────────────────────────────────────────────

  /// Persist the auth token received after a successful login / register.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kTokenKey, token);
  }

  /// Retrieve the stored auth token, or null if none exists.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kTokenKey);
  }

  /// Clear the auth token from storage (called on logout).
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kTokenKey);
  }

  /// Returns true when a token is currently saved on the device.
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
