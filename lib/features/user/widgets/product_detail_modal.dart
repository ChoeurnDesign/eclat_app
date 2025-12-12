import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/cart_service.dart';
import '../../../data/services/wishlist_service.dart';

class ProductDetailModal extends StatelessWidget {
  final Product product;

  const ProductDetailModal({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color:  Color(0xFFF8F5F0),
        borderRadius:   BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header with close button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical:  12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Product Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                    letterSpacing: 0.3, // ✅ Professional spacing
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(
                    CupertinoIcons. xmark_circle_fill,
                    color: Color(0xFF6B7280),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image. network(
                      product.imageUrl,
                      width: double.infinity,
                      height: 300,
                      fit:  BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 300,
                        color: const Color(0xFFE5E7EB),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.photo,
                            size: 64,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                      letterSpacing: 0.3, // ✅ Professional spacing
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Text(
                    '\$${product.price. toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8A9A5B),
                      letterSpacing:  0.5, // ✅ Professional spacing
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:  const Color(0xFF8A9A5B).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.category. toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8A9A5B),
                        letterSpacing: 1.5, // ✅ Good for uppercase
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                      letterSpacing: 0.3, // ✅ Professional spacing
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description. isEmpty
                        ? 'No description available.'
                        : product.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                      letterSpacing:  0.2, // ✅ Professional spacing
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stock Status
                  Row(
                    children: [
                      Icon(
                        product.stock > 0
                            ? CupertinoIcons.checkmark_circle_fill
                            : CupertinoIcons. xmark_circle_fill,
                        color: product.stock > 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product. stock > 0
                            ?  '${product.stock} in stock'
                            : 'Out of stock',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: product. stock > 0
                              ?  const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          letterSpacing: 0.2, // ✅ Professional spacing
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // iOS-Style Bottom Actions
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              border: Border(
                top: BorderSide(
                  color: CupertinoColors.separator. withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // iOS-Style Wishlist Button
                  Consumer<WishlistService>(
                    builder: (context, wishlistService, child) {
                      final isInWishlist = wishlistService. isInWishlist(product. id);
                      return CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          wishlistService.toggleWishlist(product);
                        },
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isInWishlist
                                ?  const Color(0xFFFF3B30).withValues(alpha: 0.1)
                                : const Color(0xFF000000).withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Icon(
                            isInWishlist
                                ?  CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: isInWishlist
                                ? const Color(0xFFFF3B30)
                                : const Color(0xFF000000),
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),

                  // iOS-Style Add to Cart Button
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: product.stock > 0 ? () => _addToCart(context) : null,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: product.stock > 0
                              ? const Color(0xFF8A9A5B)
                              : const Color(0xFF000000).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: product.stock > 0
                              ? [
                            BoxShadow(
                              color: const Color(0xFF8A9A5B).withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                              : null,
                        ),
                        child:  Row(
                          mainAxisAlignment:  MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.cart_fill_badge_plus,
                              color: product. stock > 0
                                  ? CupertinoColors.white
                                  : const Color(0xFF000000).withValues(alpha: 0.3),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: product. stock > 0
                                    ? CupertinoColors.white
                                    : const Color(0xFF000000).withValues(alpha: 0.3),
                                letterSpacing: 0.3, // ✅ Professional spacing
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Professional Letter Spacing in Alert Dialog
  void _addToCart(BuildContext context) {
    final cartService = Provider.of<CartService>(context, listen: false);
    cartService.addToCart(product);

    Navigator.pop(context);

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          'Added to Cart',
          style: TextStyle(
            fontSize:  17,
            fontWeight:  FontWeight.w600,
            color: CupertinoColors.white,
            letterSpacing: 0.5, // ✅ Professional spacing
          ),
        ),
        content: Padding(
          padding:  const EdgeInsets.only(top: 8),
          child: Text(
            '${product.name} has been added to your cart!',
            style:  const TextStyle(
              fontSize:  13,
              fontWeight:  FontWeight.w400,
              color: CupertinoColors. white,
              height: 1.4,
              letterSpacing: 0.3, // ✅ Professional spacing
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Continue Shopping',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight. w400,
                color: Color(0xFF007AFF),
                letterSpacing: 0.2, // ✅ Professional spacing
              ),
            ),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed:  () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cart');
            },
            child: const Text(
              'View Cart',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF007AFF),
                letterSpacing: 0.2, // ✅ Professional spacing
              ),
            ),
          ),
        ],
      ),
    );
  }
}