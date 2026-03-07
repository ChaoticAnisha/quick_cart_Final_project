import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../api/api_endpoints.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../cart/presentation/viewmodel/cart_viewmodel.dart';
import '../../../wishlist/presentation/viewmodel/wishlist_viewmodel.dart';
import '../viewmodel/recently_viewed_viewmodel.dart';
import '../../domain/entities/product.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  int _qty = 1;
  bool _addedToCart = false;
  late AnimationController _btnAnim;
  late Animation<double> _btnScale;

  static const _orange = Color(0xFFFFA500);
  static const _green = Color(0xFF10B981);
  static const _red = Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _btnAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _btnScale = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _btnAnim, curve: Curves.easeInOut),
    );
    Future.microtask(() {
      if (mounted) {
        ref
            .read(recentlyViewedProvider.notifier)
            .track(widget.product);
      }
    });
  }

  @override
  void dispose() {
    _btnAnim.dispose();
    super.dispose();
  }

  void _onAddToCart() {
    final cartVM = ref.read(cartViewModelProvider.notifier);
    for (int i = 0; i < _qty; i++) {
      cartVM.addToCartById(
        productId: widget.product.id,
        productName: widget.product.name,
        price: widget.product.price,
        productImage: widget.product.image,
      );
    }
    setState(() => _addedToCart = true);

    // Button bounce animation
    _btnAnim.forward().then((_) => _btnAnim.reverse());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$_qty × ${widget.product.name} added to cart',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: _green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.cart),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cartState = ref.watch(cartViewModelProvider);
    final cartItems = cartState.items;
    final cartCount = cartItems.fold<int>(0, (s, i) => s + i.quantity);
    final inCart = cartItems.any((i) => i.productId == product.id);
    final cartQty = inCart
        ? cartItems
            .firstWhere((i) => i.productId == product.id)
            .quantity
        : 0;
    final isWishlisted = ref.watch(wishlistViewModelProvider
        .select((list) => list.any((p) => p.id == product.id)));

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Hero Image AppBar ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.black87,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              // Wishlist heart
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => ref
                      .read(wishlistViewModelProvider.notifier)
                      .toggle(product),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: Icon(
                      isWishlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isWishlisted ? Colors.red : Colors.black87,
                      size: 20,
                    ),
                  ),
                ),
              ),
              // Cart
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: Stack(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.shopping_cart_outlined,
                              color: Colors.black87, size: 20),
                        ),
                        if (cartCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: _orange,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  cartCount > 9 ? '9+' : '$cartCount',
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  InteractiveViewer(
                    maxScale: 4.0,
                    child: Hero(
                      tag: 'product-image-${product.id}',
                      child: ApiEndpoints.isNetworkImage(product.image)
                          ? CachedNetworkImage(
                              imageUrl: ApiEndpoints.getImageUrl(product.image),
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                color: const Color(0xFFF0F0F0),
                                child: const Center(
                                  child: CircularProgressIndicator(color: _orange),
                                ),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: const Color(0xFFF0F0F0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined,
                                        size: 64, color: Colors.grey[400]),
                                    const SizedBox(height: 8),
                                    Text('No image',
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                  ],
                                ),
                              ),
                            )
                          : Image.asset(
                              ApiEndpoints.getAssetImagePath(product.image),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFFF0F0F0),
                                child: Icon(Icons.image_outlined,
                                    size: 64, color: Colors.grey[400]),
                              ),
                            ),
                    ),
                  ),
                  // Bottom gradient for readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Product Info ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Category + Rating row
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category chip
                      if (product.categoryName != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5E6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product.categoryName!,
                            style: const TextStyle(
                              color: _orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],

                      // Product name
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Price + Rating row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Rs. ${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: _orange,
                            ),
                          ),
                          const Spacer(),
                          if (product.rating != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8E1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: Color(0xFFFFD700), size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating!.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF666600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),

                // Stock status
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Icon(
                        product.isInStock
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        size: 18,
                        color: product.isInStock ? _green : _red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.isInStock
                            ? 'In Stock • ${product.stock} available'
                            : 'Out of Stock',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: product.isInStock ? _green : _red,
                        ),
                      ),
                      if (inCart) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.shopping_cart,
                                  size: 12, color: _green),
                              const SizedBox(width: 4),
                              Text(
                                '$cartQty in cart',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: _green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFF0F0F0)),

                // Description
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description.isNotEmpty
                            ? product.description
                            : 'No description available.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF555555),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFF0F0F0)),

                // Quantity selector
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      const Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const Spacer(),
                      _QuantityStepper(
                        qty: _qty,
                        max: product.stock,
                        onChanged: (v) => setState(() {
                          _qty = v;
                          _addedToCart = false;
                        }),
                      ),
                    ],
                  ),
                ),

                // Total line
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF888888),
                        ),
                      ),
                      Text(
                        'Rs. ${(product.price * _qty).toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),

                // Extra bottom padding so FAB doesn't cover content
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      // ── Bottom Action Bar ────────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: MediaQuery.of(context).padding.bottom + 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: product.isInStock
            ? _addedToCart
                // ── After adding: two-button row ──────────────────────────
                ? Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() => _addedToCart = false);
                          },
                          icon: const Icon(Icons.add, color: _orange, size: 18),
                          label: const Text(
                            'Add More',
                            style: TextStyle(color: _orange, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: _orange),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.cart),
                          icon: const Icon(Icons.shopping_cart,
                              color: Colors.white, size: 18),
                          label: Text(
                            'View Cart ($cartCount)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                // ── Before adding: single Add to Cart button ───────────────
                : ScaleTransition(
                    scale: _btnScale,
                    child: ElevatedButton.icon(
                      onPressed: _onAddToCart,
                      icon: const Icon(Icons.shopping_cart_outlined,
                          color: Colors.white),
                      label: Text(
                        'Add $_qty to Cart  •  Rs. ${(widget.product.price * _qty).toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orange,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  )
            // ── Out of stock ──────────────────────────────────────────────
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Out of Stock',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

// ─── Quantity Stepper ────────────────────────────────────────────────────────

class _QuantityStepper extends StatelessWidget {
  final int qty;
  final int max;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({
    required this.qty,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(
            icon: Icons.remove,
            enabled: qty > 1,
            onTap: () => onChanged(qty - 1),
          ),
          Container(
            width: 44,
            alignment: Alignment.center,
            child: Text(
              '$qty',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          _StepBtn(
            icon: Icons.add,
            enabled: qty < max,
            onTap: () => onChanged(qty + 1),
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final bool highlight;
  final VoidCallback onTap;

  const _StepBtn({
    required this.icon,
    required this.enabled,
    required this.onTap,
    this.highlight = false,
  });

  static const _orange = Color(0xFFFFA500);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled && highlight
              ? _orange.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? (highlight ? _orange : const Color(0xFF555555)) : Colors.grey[300],
        ),
      ),
    );
  }
}
