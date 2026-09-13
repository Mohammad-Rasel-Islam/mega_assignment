import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// API Base URL — change this one constant to
// point the whole app at your Laravel backend.
// ─────────────────────────────────────────────
// For Android Studio Emulator connecting to Vanilla PHP in XAMPP:
const String kBaseUrl = 'http://10.0.2.2/api';

// shared_preferences key for the auth token
const String kTokenKey = 'auth_token';

/// Central colour palette for the app.
class AppColors {
  static const Color primary = Color(0xFFFF6B35);        // Orange accent
  static const Color primaryLight = Color(0xFFFFF0EB);
  static const Color categorySelected = Color(0xFFE0F2FE); // Light blue
  static const Color categorySelectedBorder = Color(0xFF38BDF8);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color ratingStar = Color(0xFFFFB800);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
}

/// All Laravel API endpoints — paths relative to [kBaseUrl].
class ApiEndpoints {
  // Auth
  static const String login     = '/login';
  static const String register  = '/register';
  static const String logout    = '/logout';
  static const String user      = '/user';

  // Catalogue
  static const String categories = '/categories';
  static const String products   = '/products';
  static String productById(dynamic id) => '/products/$id';

  // Cart
  static const String cart            = '/cart';
  static String cartItem(dynamic id)  => '/cart/$id';

  // Wishlist
  static const String wishlist               = '/wishlist';
  static String wishlistItem(dynamic id)     => '/wishlist/$id';

  // Addresses
  static const String addresses              = '/addresses';
  static String addressById(dynamic id)      => '/addresses/$id';

  // Orders
  static const String orders                 = '/orders';
  static String orderById(dynamic id)        => '/orders/$id';
}
