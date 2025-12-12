import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/cart_service.dart';
import '../../../data/services/wishlist_service.dart';
import 'product_detail_modal.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String price;
  final String imageUrl;
  final Product?   product;

  const ProductCard({
    super.key,
    required this.   name,
    required this.price,
    required this.imageUrl,
    this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  void _viewProductDetails() {
    if (widget.product == null) return;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => ProductDetailModal(product: widget.product!),
    );
  }

  // ✅ iOS-Style Alert Dialog with White Text
  void _addToCart() {
    if (widget.product == null) return;

    final cartService = Provider.of<CartService>(context, listen: false);
    cartService.addToCart(widget.   product!);

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          'Added to Cart',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.white, // ✅ White text
            letterSpacing: 0.5,
          ),
        ),
        content:   Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${widget.name} has been added to your cart!',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: CupertinoColors.white, // ✅ White text
              height: 1.4,
              letterSpacing: 0.3,
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed:  () => Navigator.pop(context),
            child: const Text(
              'Continue Shopping',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Color(0xFF007AFF), // ✅ iOS blue
                letterSpacing: 0.2,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed:  () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cart');
            },
            child:   const Text(
              'View Cart',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight. w600,
                color: Color(0xFF007AFF), // ✅ iOS blue
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleWishlist() {
    if (widget.product == null) return;

    final wishlistService = Provider.of<WishlistService>(context, listen:  false);
    wishlistService.toggleWishlist(widget.product!);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap:  _viewProductDetails,
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withValues(alpha: _isHovered ? 0.15 : 0.08),
                blurRadius: _isHovered ? 16 : 8,
                offset:    Offset(0, _isHovered ? 6 : 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                child: Stack(
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      child: Image.network(
                        widget.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFE5E7EB),
                          child: const Center(
                            child: Icon(CupertinoIcons.photo, size: 48, color: Color(0xFF9CA3AF)),
                          ),
                        ),
                      ),
                    ),

                    // Wishlist Button
                    if (widget.product != null)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Consumer<WishlistService>(
                          builder: (context, wishlistService, child) {
                            final isInWishlist = wishlistService.  isInWishlist(widget.   product!.  id);
                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: _toggleWishlist,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.white.  withValues(alpha: 0.95),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF000000).withValues(alpha: 0.15),
                                        blurRadius: 8,
                                        offset:  const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isInWishlist ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                    size: 20,
                                    color: isInWishlist ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

              // Product Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment. start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3E50),
                        letterSpacing: 0.2, // ✅ Professional spacing
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment:   MainAxisAlignment.  spaceBetween,
                      children: [
                        Text(
                          widget.price,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8A9A5B),
                            letterSpacing: 0.3, // ✅ Professional spacing
                          ),
                        ),
                        // Add to Cart Icon Button
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: _addToCart,
                            child: Container(
                              padding:  const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:  const Color(0xFF8A9A5B).withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.  cart_badge_plus,
                                size: 22,
                                color: Color(0xFF8A9A5B),
                              ),
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
      ),
    );
  }
}