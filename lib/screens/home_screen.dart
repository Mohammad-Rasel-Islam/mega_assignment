import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/category_provider.dart';
import '../providers/menu_item_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';
import '../widgets/category_pill.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/shimmer_loading.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _banners = [
    {
      'title': 'Free Delivery\nToday! 🚀',
      'subtitle': 'On orders above ৳500',
      'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=900&q=80',
    },
    {
      'title': 'Lunch Special\n30% OFF 🍱',
      'subtitle': 'Available 12 PM – 3 PM every day',
      'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=900&q=80',
    },
    {
      'title': 'New! Sizzling\nBurgers 🍔',
      'subtitle': 'Crafted with love, delivered hot',
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=900&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData({bool forceRefresh = false}) async {
    final catProv = context.read<CategoryProvider>();
    await Future.wait([
      catProv.fetchCategories(),
      context.read<MenuItemProvider>().fetchMenuItems(categoryId: catProv.selectedCategoryId),
      context.read<FavoriteProvider>().fetchFavorites(),
      context.read<CartProvider>().fetchCart(),
    ]);
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          (_currentBannerIndex + 1) % _banners.length,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _onSearch(String query) async {
    final catProv = context.read<CategoryProvider>();
    await context.read<MenuItemProvider>().fetchMenuItems(
          categoryId: catProv.selectedCategoryId,
          search: query.trim().isEmpty ? null : query.trim(),
        );
  }

  Future<void> _onCategoryTap(int index) async {
    final catProv = context.read<CategoryProvider>();
    catProv.selectCategory(index);
    await context.read<MenuItemProvider>().fetchMenuItems(
          categoryId: catProv.selectedCategoryId,
          search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
        );
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final menuProvider = context.watch<MenuItemProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadData(forceRefresh: true),
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              // ── 1. Header ───────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildHeader()),
              // ── 2. Search bar ───────────────────────────────────────────
              SliverToBoxAdapter(child: _buildSearchBar()),
              // ── 3. Promo banner ─────────────────────────────────────────
              SliverToBoxAdapter(child: _buildBannerSection()),
              // ── 4. Categories ────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildCategories(categoryProvider)),
              // ── 5. Quick & Easy header ───────────────────────────────────
              SliverToBoxAdapter(child: _buildMenuHeader(categoryProvider, menuProvider)),
              // ── 5. Menu grid ─────────────────────────────────────────────
              ..._buildMenuSliver(menuProvider),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Header: "What are you cooking today?" + settings icon
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                children: [
                  TextSpan(
                    text: 'What are you\n',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  TextSpan(
                    text: 'cooking today?',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Settings icon
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.settings_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Search bar: white pill with search icon
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearch,
          decoration: InputDecoration(
            hintText: 'Search any food',
            hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded,
                        color: AppColors.textSecondary, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      _onSearch('');
                      setState(() {});
                    },
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          ),
          onTap: () => setState(() {}),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Promo banner with bleeding food image on right edge
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildBannerSection() {
    return Column(
      children: [
        SizedBox(
          height: 185,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _bannerController,
                onPageChanged: (i) => setState(() => _currentBannerIndex = i),
                itemCount: _banners.length,
                itemBuilder: (_, i) => _BannerCard(banner: _banners[i]),
              ),
              // Dot indicators
              Positioned(
                bottom: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_banners.length, (idx) {
                    final active = _currentBannerIndex == idx;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Categories section
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildCategories(CategoryProvider categoryProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 26, 20, 12),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: categoryProvider.isLoading
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 5,
                  itemBuilder: (_, _) => const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: ShimmerBox(width: 90, height: 38, borderRadius: 22),
                  ),
                )
              : ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    CategoryPill(
                      isAll: true,
                      isSelected: categoryProvider.selectedIndex == 0,
                      onTap: () => _onCategoryTap(0),
                    ),
                    ...List.generate(categoryProvider.categories.length, (i) {
                      final listIndex = i + 1;
                      return CategoryPill(
                        category: categoryProvider.categories[i],
                        isSelected: categoryProvider.selectedIndex == listIndex,
                        onTap: () => _onCategoryTap(listIndex),
                      );
                    }),
                  ],
                ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Menu section header: "Quick & Easy" + "View all"
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildMenuHeader(CategoryProvider catProv, MenuItemProvider menuProv) {
    final title = catProv.selectedIndex == 0
        ? 'Quick & Easy'
        : catProv.categories[catProv.selectedIndex - 1].name;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'View all',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Menu sliver content (loading / error / empty / grid)
  // ────────────────────────────────────────────────────────────────────────────
  List<Widget> _buildMenuSliver(MenuItemProvider menuProvider) {
    if (menuProvider.isLoading) {
      return [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, _) => const ShimmerBox(
                  width: double.infinity, height: 220, borderRadius: 18),
              childCount: 6,
            ),
          ),
        ),
      ];
    }

    if (menuProvider.error != null) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.primaryLight),
                const SizedBox(height: 16),
                Text(
                  menuProvider.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    if (menuProvider.menuItems.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(Icons.restaurant_menu_rounded, size: 64, color: AppColors.primaryLight),
                const SizedBox(height: 16),
                const Text(
                  'No Items Found',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Try a different category or search term',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.70,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => MenuItemCard(item: menuProvider.menuItems[index]),
            childCount: menuProvider.menuItems.length,
          ),
        ),
      ),
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Banner Card: violet gradient bg + bleeding food image on right
// ─────────────────────────────────────────────────────────────────────────────
class _BannerCard extends StatelessWidget {
  final Map<String, String> banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background circle decoration
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
            Positioned(
              right: 80,
              bottom: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            // Food image bleeding off right edge
            Positioned(
              right: -8,
              top: 0,
              bottom: 0,
              child: CachedNetworkImage(
                imageUrl: banner['image']!,
                width: 155,
                fit: BoxFit.cover,
                placeholder: (_, _) => const SizedBox.shrink(),
                errorWidget: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
            // Left-to-right gradient so text stays readable
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.primaryDark.withValues(alpha: 0.98),
                    AppColors.primary.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.52, 1.0],
                ),
              ),
            ),
            // Text content
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 105, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    banner['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    banner['subtitle']!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  // White pill button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      'Order Now',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


