import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/address_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainWrapperScreen extends StatefulWidget {
  final int initialIndex;

  const MainWrapperScreen({
    Key? key,
    this.initialIndex = 2, // Default to Home tab
  }) : super(key: key);

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initUserProviders();
    });
  }

  void _initUserProviders() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoggedIn) {
      Provider.of<CartProvider>(context, listen: false).fetchCart();
      Provider.of<WishlistProvider>(context, listen: false).fetchWishlist();
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),     // Index 0: Categories (Home)
      const WishlistScreen(), // Index 1: Wishlist
      const HomeScreen(),     // Index 2: Home (Center FAB)
      const CartScreen(),     // Index 3: Cart
      const ProfileScreen(),  // Index 4: Profile
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
