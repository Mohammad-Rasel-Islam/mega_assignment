import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/product_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/address_provider.dart';
import 'providers/order_provider.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a single shared ApiService instance.
    // All providers receive the SAME instance so they share the Dio client
    // (and therefore the same interceptors, including the 401 auto-logout).
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        // Auth must come first so other providers can read it when needed.
        ChangeNotifierProvider<AuthProvider>(
          create: (_) {
            final auth = AuthProvider(apiService);
            // Wire up the 401 callback on the shared ApiService.
            // When a 401 is received, we call auth.signOut() which clears
            // the token and triggers a navigation to Login via the app.
            apiService.onUnauthorized = () async {
              await auth.signOut();
            };
            return auth;
          },
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(apiService),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(apiService),
        ),
        ChangeNotifierProvider<WishlistProvider>(
          create: (_) => WishlistProvider(apiService),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(apiService),
        ),
        ChangeNotifierProvider<AddressProvider>(
          create: (_) => AddressProvider(apiService),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (_) => OrderProvider(apiService),
        ),
      ],
      child: MaterialApp(
        title: 'Shop App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
