import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_cart/api/api_endpoints.dart';
import 'package:quick_cart/core/constants/app_routes.dart';
import 'package:quick_cart/core/services/sensor_service.dart';
import 'package:quick_cart/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:quick_cart/features/cart/presentation/state/cart_state.dart';
import 'package:quick_cart/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:quick_cart/features/products/domain/entities/product.dart';
import 'package:quick_cart/features/products/presentation/viewmodel/product_viewmodel.dart';
import 'package:quick_cart/features/products/presentation/state/product_state.dart';
import 'package:quick_cart/features/wishlist/presentation/viewmodel/wishlist_viewmodel.dart';
import 'package:quick_cart/features/products/presentation/viewmodel/recently_viewed_viewmodel.dart';

// ─── CONSTANTS ──────────────────────────────────────────────────────────────

const _kGold = Color(0xFFFFD700);
const _kOrange = Color(0xFFFFA500);
const _kGradient = LinearGradient(colors: [_kGold, _kOrange]);

final _categories = [
  {'img': 'image 50.png', 'text': 'Lights & Diyas'},
  {'img': 'image 51.png', 'text': 'Diwali Gifts'},
  {'img': 'image 52.png', 'text': 'Appliances'},
  {'img': 'image 39.png', 'text': 'Home & Living'},
  {'img': 'image 41.png', 'text': 'Vegetables'},
  {'img': 'image 42.png', 'text': 'Atta & Dal'},
  {'img': 'image 43.png', 'text': 'Oil & Masala'},
  {'img': 'image 44 (1).png', 'text': 'Dairy & Bread'},
];

// ─── SCREEN ─────────────────────────────────────────────────────────────────

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _searchController = TextEditingController();
  int _selectedIndex = 0;

  final _sensorService = SensorService();
  StreamSubscription<bool>? _shakeSub;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _sensorService.startShakeDetection();
    _shakeSub = _sensorService.shakeStream.listen((_) {
      if (!mounted) return;
      ref.read(cartViewModelProvider.notifier).clearCart();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shake detected — cart cleared!'),
          backgroundColor: _kOrange,
          duration: Duration(seconds: 2),
        ),
      );
    });
    _searchController.addListener(_onSearchChanged);
    Future.microtask(
        () => ref.read(productViewModelProvider.notifier).loadProducts());
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      ref
          .read(productViewModelProvider.notifier)
          .searchProducts(_searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _shakeSub?.cancel();
    _sensorService.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.category);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.cart);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authViewModelProvider).user;
    final userName = authUser?.name ?? 'Guest';
    final profilePicture = authUser?.profilePicture;
    final cartState = ref.watch(cartViewModelProvider);
    final cartVM = ref.read(cartViewModelProvider.notifier);
    final cartCount = cartState.items.fold(0, (s, i) => s + i.quantity);
    final productState = ref.watch(productViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: RefreshIndicator(
          color: _kOrange,
          onRefresh: () =>
              ref.read(productViewModelProvider.notifier).loadProducts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(userName: userName, cartCount: cartCount, profilePicture: profilePicture),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SearchBar(controller: _searchController),
                ),
                const SizedBox(height: 20),
                _StatsRow(cartCount: cartCount),
                const SizedBox(height: 24),
                _CategoriesSection(
                  onCategoryTap: (categoryName) => Navigator.pushNamed(
                      context, AppRoutes.category,
                      arguments: categoryName),
                ),
                const SizedBox(height: 24),
                _RecentlyViewedSection(),
                const SizedBox(height: 24),
                _PopularProductsSection(
                  cartState: cartState,
                  cartVM: cartVM,
                  products: productState.products,
                  isLoading: productState.isLoading,
                  searchQuery: _searchController.text.trim(),
                  sortOption: productState.sortOption,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(cartCount),
    );
  }

  BottomNavigationBar _buildBottomNav(int cartCount) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: _kOrange,
      unselectedItemColor: Colors.grey.shade400,
      selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
      elevation: 12,
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: 'Home'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded), label: 'Categories'),
        BottomNavigationBarItem(
          label: 'Cart',
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_cart_rounded),
              if (cartCount > 0)
                Positioned(
                  right: -6,
                  top: -4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Center(
                      child: Text('$cartCount',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), label: 'Profile'),
      ],
    );
  }
}

// ─── HEADER ─────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String userName;
  final int cartCount;
  final String? profilePicture;

  const _Header({required this.userName, required this.cartCount, this.profilePicture});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = (profilePicture != null && profilePicture!.isNotEmpty)
        ? ApiEndpoints.getImageUrl(profilePicture!)
        : null;

    return Container(
      decoration: const BoxDecoration(
        gradient: _kGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withValues(alpha: 0.35),
                      backgroundImage: avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl == null
                          ? Text(
                              userName.isNotEmpty ? userName[0].toUpperCase() : 'G',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(userName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3)),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.shopping_cart_outlined,
                          color: Colors.white, size: 24),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          child: Center(
                            child: Text('$cartCount',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white70, size: 14),
              const SizedBox(width: 4),
              Text('Delivery in 16 minutes',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── SEARCH BAR ─────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: _kOrange),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}

// ─── STATS ROW ──────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int cartCount;
  const _StatsRow({required this.cartCount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _StatCard(
              label: 'Cart Items',
              value: '$cartCount',
              icon: Icons.shopping_cart_rounded,
              gradient: _kGradient),
          const SizedBox(width: 12),
          _StatCard(
              label: 'Total Orders',
              value: '0',
              icon: Icons.inventory_2_rounded,
              gradient: const LinearGradient(
                  colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)])),
          const SizedBox(width: 12),
          _StatCard(
              label: 'Delivery',
              value: '16 min',
              icon: Icons.delivery_dining_rounded,
              gradient: const LinearGradient(
                  colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)])),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Gradient gradient;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text(label,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── CATEGORIES ─────────────────────────────────────────────────────────────

class _CategoriesSection extends StatelessWidget {
  final void Function(String? categoryName) onCategoryTap;
  const _CategoriesSection({required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shop by Category',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              TextButton(
                onPressed: () => onCategoryTap(null),
                child: const Text('View All',
                    style: TextStyle(
                        color: _kOrange, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: _kGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _categories.length,
            itemBuilder: (_, i) =>
                _CategoryCard(item: _categories[i], onTap: onCategoryTap),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Map<String, String> item;
  final void Function(String? categoryName) onTap;
  const _CategoryCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(item['text']),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/${item['img']}',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.category, color: _kOrange, size: 28),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item['text'] ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── RECENTLY VIEWED ────────────────────────────────────────────────────────

class _RecentlyViewedSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(recentlyViewedProvider);
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recently Viewed',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.category),
                child: const Text('See All',
                    style: TextStyle(
                        color: _kOrange, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final product = items[i];
              final imageUrl = ApiEndpoints.getImageUrl(product.image);
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  ctx,
                  AppRoutes.productDetails,
                  arguments: product,
                ),
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14)),
                        child: SizedBox(
                          height: 76,
                          width: double.infinity,
                          child: imageUrl.isNotEmpty
                              ? Image.network(imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade100,
                                    child: const Icon(Icons.image,
                                        color: Colors.grey, size: 28),
                                  ))
                              : Container(
                                  color: Colors.grey.shade100,
                                  child: const Icon(Icons.image,
                                      color: Colors.grey, size: 28),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          'Rs.${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 10,
                              color: _kOrange,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── POPULAR PRODUCTS ───────────────────────────────────────────────────────

class _PopularProductsSection extends ConsumerWidget {
  final CartState cartState;
  final CartViewModel cartVM;
  final List<Product> products;
  final bool isLoading;
  final String searchQuery;
  final SortOption sortOption;

  const _PopularProductsSection({
    required this.cartState,
    required this.cartVM,
    required this.products,
    required this.isLoading,
    required this.searchQuery,
    required this.sortOption,
  });

  static const _sortLabels = {
    SortOption.none: 'Default',
    SortOption.priceAsc: 'Price ↑',
    SortOption.priceDesc: 'Price ↓',
    SortOption.nameAsc: 'A–Z',
    SortOption.ratingDesc: 'Top Rated',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayProducts = products.length > 6 ? products.sublist(0, 6) : products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Popular Products',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.category),
                child: const Text('View All',
                    style: TextStyle(
                        color: _kOrange, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        // Sort chips
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: SortOption.values.map((opt) {
              final selected = sortOption == opt;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_sortLabels[opt] ?? ''),
                  selected: selected,
                  onSelected: (_) => ref
                      .read(productViewModelProvider.notifier)
                      .sortProducts(opt),
                  selectedColor: _kOrange,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selected ? _kOrange : Colors.grey.shade300,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isLoading
              ? _buildLoadingGrid()
              : products.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              searchQuery.isNotEmpty
                                  ? Icons.search_off_rounded
                                  : Icons.inventory_2_outlined,
                              size: 56,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              searchQuery.isNotEmpty
                                  ? 'No results for "$searchQuery"'
                                  : 'No products available',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: displayProducts.length,
                      itemBuilder: (_, i) => _ProductCard(
                        product: displayProducts[i],
                        inCart: cartState.items
                            .any((c) => c.productId == displayProducts[i].id),
                        onAdd: () => cartVM.addToCart(displayProducts[i]),
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.productDetails,
                            arguments: displayProducts[i]),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(_kOrange),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  final Product product;
  final bool inCart;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.inCart,
    required this.onAdd,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWishlisted = ref.watch(wishlistViewModelProvider
        .select((list) => list.any((p) => p.id == product.id)));
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 10,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'product-image-${product.id}',
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFFF9F9F9),
                        padding: const EdgeInsets.all(12),
                        child: ApiEndpoints.isNetworkImage(product.image)
                            ? Image.network(
                                ApiEndpoints.getImageUrl(product.image),
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                    size: 40),
                                loadingBuilder: (_, child, progress) =>
                                    progress == null
                                        ? child
                                        : const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      _kOrange),
                                            ),
                                          ),
                              )
                            : Image.asset(
                                ApiEndpoints.getAssetImagePath(product.image),
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                    size: 40),
                              ),
                      ),
                    ),
                  ),
                  // Wishlist heart
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => ref
                          .read(wishlistViewModelProvider.notifier)
                          .toggle(product),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isWishlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isWishlisted ? Colors.red : Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black87)),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.access_time, size: 11, color: Colors.grey),
                      SizedBox(width: 2),
                      Text('16 MINS',
                          style:
                              TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹${product.price.toInt()}',
                          style: const TextStyle(
                              color: _kOrange,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: onAdd,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: inCart
                                ? const LinearGradient(colors: [
                                    Color(0xFF66BB6A),
                                    Color(0xFF2E7D32),
                                  ])
                                : _kGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            inCart ? '✓ Added' : '+ Add',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
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
