import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/banner_provider.dart';
import 'providers/category_provider.dart';
import 'providers/menu_item_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/address_provider.dart';
import 'providers/order_provider.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) {
            final auth = AuthProvider(apiService);
            apiService.onUnauthorized = () async {
              await auth.signOut();
            };
            return auth;
          },
        ),
        ChangeNotifierProvider<BannerProvider>(
          create: (_) => BannerProvider(apiService),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(apiService),
        ),
        ChangeNotifierProvider<MenuItemProvider>(
          create: (_) => MenuItemProvider(apiService),
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (_) => FavoriteProvider(apiService),
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
        title: 'Restaurant App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
