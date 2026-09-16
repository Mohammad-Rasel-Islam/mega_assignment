import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// API Base URL — points to your XAMPP backend.
// Automatically uses 10.0.2.2 for Android emulator, and localhost for Windows / Web / iOS.
// ─────────────────────────────────────────────
String get kBaseUrl {
  if (kIsWeb) return 'http://localhost/api';
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2/api';
  }
  return 'http://localhost/api';
}

// shared_preferences key for the auth token
const String kTokenKey = 'auth_token';

/// Central colour palette for the Restaurant App — Deep Violet theme.
class AppColors {
  static const Color primary           = Color(0xFF6D28D9); // Deep violet
  static const Color primaryDark       = Color(0xFF4C1D95); // Pressed/active violet
  static const Color primaryLight      = Color(0xFFEDE9FE); // Soft violet tint
  static const Color accentYellow      = Color(0xFFF59E0B); // Warm amber accent
  static const Color accentGreen       = Color(0xFF10B981); // Emerald success
  static const Color categorySelected  = Color(0xFF6D28D9);
  static const Color categorySelectedBorder = Color(0xFF6D28D9);
  static const Color background        = Color(0xFFF5F3FF); // Very light violet wash
  static const Color cardBackground    = Color(0xFFFFFFFF); // Pure white cards
  static const Color textPrimary       = Color(0xFF1E1B4B); // Deep indigo text
  static const Color textSecondary     = Color(0xFF6B7280); // Cool grey
  static const Color border            = Color(0xFFE5E7EB); // Light border
  static const Color ratingStar        = Color(0xFFF59E0B);
  static const Color success           = Color(0xFF10B981);
  static const Color error             = Color(0xFFEF4444);
}

/// All Restaurant REST API endpoints — paths relative to [kBaseUrl].
class ApiEndpoints {
  // Auth
  static const String login     = '/login';
  static const String register  = '/register';
  static const String logout    = '/logout';
  static const String user      = '/user';

  // Restaurant Data
  static const String categories = '/categories';
  static const String banners    = '/banners';
  static const String menuItems  = '/menu-items';
  static String menuItemById(dynamic id) => '/menu-items/$id';
  
  // Legacy aliases
  static const String products   = '/menu-items';
  static String productById(dynamic id) => '/menu-items/$id';

  // Cart
  static const String cart            = '/cart';
  static String cartItem(dynamic id)  => '/cart/$id';

  // Favorites
  static const String favorites              = '/favorites';
  static String favoriteItem(dynamic id)    => '/favorites/$id';
  static const String wishlist               = '/favorites';
  static String wishlistItem(dynamic id)     => '/favorites/$id';

  // Addresses
  static const String addresses              = '/addresses';
  static String addressById(dynamic id)      => '/addresses/$id';

  // Orders
  static const String orders                 = '/orders';
  static String orderById(dynamic id)        => '/orders/$id';
}
