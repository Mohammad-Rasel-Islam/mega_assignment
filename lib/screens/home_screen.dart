import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/category_icon.dart';
import '../widgets/product_card.dart';
import '../widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      'title': 'Summer Sale 50% OFF',
      'subtitle': 'Explore vibrant trends & styles',
      'image':
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&q=80',
    },
    {
      'title': 'Luxury Beauty Essentials',
      'subtitle': 'Radiant skin care & cosmetics',
      'image':
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80',
    },
    {
      'title': 'Exclusive Sneaker Drop',
      'subtitle': 'Step into comfort & high speed',
      'image':
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=800&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
    // Initial data fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData({bool forceRefresh = false}) async {
    final catProv = context.read<CategoryProvider>();
    final prodProv = context.read<ProductProvider>();

    await Future.wait([
      catProv.fetchCategories(),
      prodProv.fetchProducts(
        categoryId: catProv.selectedCategoryId,
      ),
    ]);
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        final nextIndex = (_currentBannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _onSearch(String query) async {
    final catProv = context.read<CategoryProvider>();
    await context.read<ProductProvider>().fetchProducts(
          categoryId: catProv.selectedCategoryId,
          search: query.trim().isEmpty ? null : query.trim(),
        );
  }

  Future<void> _onCategoryTap(int index) async {
    final catProv = context.read<CategoryProvider>();
    catProv.selectCategory(index);
    await context.read<ProductProvider>().fetchProducts(
          categoryId: catProv.selectedCategoryId,
          search: _searchController.text.trim().isEmpty
              ? null
              : _searchController.text.trim(),
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
    final authProvider = context.watch<AuthProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadData(forceRefresh: true),
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              // ── Header ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${authProvider.user?.name ?? 'Shopper'} 👋',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Discover your next favourite item',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Search Bar ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.textSecondary),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded,
                                  color: AppColors.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                _onSearch('');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),

              // ── Promotional Banner ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  height: 160,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        controller: _bannerController,
                        onPageChanged: (index) =>
                            setState(() => _currentBannerIndex = index),
                        itemCount: _banners.length,
                        itemBuilder: (context, index) {
                          final banner = _banners[index];
                          return Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: banner['image']!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => const ShimmerBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.black.withOpacity(0.2),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          banner['title']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          banner['subtitle']!,
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // Carousel Indicators
                      Positioned(
                        bottom: 10,
                        child: Row(
                          children: List.generate(
                            _banners.length,
                            (idx) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentBannerIndex == idx ? 20 : 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: _currentBannerIndex == idx
                                    ? AppColors.primary
                                    : Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Categories Header ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (categoryProvider.selectedIndex != 0)
                        TextButton(
                          onPressed: () => _onCategoryTap(0),
                          child: const Text('Reset',
                              style: TextStyle(color: AppColors.primary)),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Category Row ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 54,
                  child: categoryProvider.isLoading
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: 5,
                          itemBuilder: (_, __) => const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child:
                                ShimmerBox(width: 90, height: 44, borderRadius: 22),
                          ),
                        )
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            // "All" category
                            CategoryIconWidget(
                              isAll: true,
                              isSelected: categoryProvider.selectedIndex == 0,
                              onTap: () => _onCategoryTap(0),
                            ),
                            ...List.generate(
                              categoryProvider.categories.length,
                              (i) {
                                final cat = categoryProvider.categories[i];
                                final listIndex = i + 1;
                                return CategoryIconWidget(
                                  category: cat,
                                  isSelected: categoryProvider.selectedIndex ==
                                      listIndex,
                                  onTap: () => _onCategoryTap(listIndex),
                                );
                              },
                            ),
                          ],
                        ),
                ),
              ),

              // ── Product Grid Header ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        categoryProvider.selectedIndex == 0
                            ? 'All Products'
                            : '${categoryProvider.categories[categoryProvider.selectedIndex - 1].name} Products',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${productProvider.products.length} items',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Product Grid ───────────────────────────────────────────
              if (productProvider.isLoading)
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (_, __) => const ShimmerBox(
                          width: double.infinity, height: 200, borderRadius: 16),
                      childCount: 6,
                    ),
                  ),
                )
              else if (productProvider.error != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.wifi_off_rounded,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          productProvider.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadData,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (productProvider.products.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.shopping_bag_outlined,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        const Text(
                          'No Products Found',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          ProductCard(product: productProvider.products[index]),
                      childCount: productProvider.products.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
