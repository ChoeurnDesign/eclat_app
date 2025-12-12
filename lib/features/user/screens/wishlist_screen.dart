import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../data/services/wishlist_service.dart';
import '../../../data/services/cart_service.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Wishlist',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: const Color(0xFFF8F5F0),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons.back,
            color: Color(0xFF2C3E50),
          ),
        ),
      ),
      child: SafeArea(
        child: Consumer<WishlistService>(
          builder: (context, wishlistService, child) {
            if (wishlistService.items.isEmpty) {
              return _buildEmptyWishlist(context);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlistService.items.length,
              itemBuilder: (context, index) {
                final product = wishlistService.items[index];
                return _buildWishlistItem(context, wishlistService, product);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child:  Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.heart,
              size: 80,
              color: const Color(0xFF8A9A5B).withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your wishlist is empty',
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height:  8),
            Text(
              'Save items you love',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF666666).withValues(alpha: 0.7),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 32),
            CupertinoButton(
              color: const Color(0xFF8A9A5B),
              borderRadius: BorderRadius.circular(24),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Continue Shopping',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistItem(
      BuildContext context,
      WishlistService wishlistService,
      dynamic product,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:  const Color(0xFF000000).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit. cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height:  80,
                color: const Color(0xFFE5E7EB),
                child: const Icon(
                  CupertinoIcons.photo,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price. toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A9A5B),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Column(
            children: [
              // Add to Cart
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    final cartService = Provider.of<CartService>(context, listen: false);
                    cartService.addToCart(product);

                    // Show confirmation
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text(
                          'Added to Cart',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        content:  Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${product.name} has been added to your cart!',
                            style: const TextStyle(
                              fontSize:  13,
                              fontWeight: FontWeight.w400,
                              color: CupertinoColors.white,
                              height: 1.4,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF007AFF),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8A9A5B).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.cart_badge_plus,
                      size: 22,
                      color: Color(0xFF8A9A5B),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Remove from Wishlist
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    wishlistService.toggleWishlist(product);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.trash,
                      size: 20,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}