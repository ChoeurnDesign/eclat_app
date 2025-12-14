import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/cart_service.dart';
import '../../../data/services/wishlist_service.dart';
import '../../../data/services/review_service.dart';
import '../../../data/models/review_model.dart';
import 'reviews/product_review_list.dart';
import 'reviews/product_review_dialog.dart';
import '../../../utils/guest_id_util.dart';

class ProductDetailModal extends StatefulWidget {
  final Product product;

  const ProductDetailModal({super.key, required this.product});

  @override
  State<ProductDetailModal> createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal> {
  final ReviewService _reviewService = ReviewService();

  void _addToCart(BuildContext context) {
    final cartService = Provider.of<CartService>(context, listen: false);
    cartService.addToCart(widget.product);
    Navigator.pop(context);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Added to Cart', style: TextStyle(
          fontSize: 17, fontWeight: FontWeight.w600, color: CupertinoColors.white, letterSpacing: 0.5,
        )),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${widget.product.name} has been added to your cart!',
            style: const TextStyle(
              fontSize: 13,
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
              'Continue Shopping',
              style: TextStyle(fontSize: 17, color: Color(0xFF007AFF)),
            ),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cart');
            },
            child: const Text(
              'View Cart',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF007AFF)),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return await GuestIdUtil.getGuestId();
    }
  }

  void _showAddOrEditReview({Review? initialReview, required String userId}) async {
    await showProductReviewDialog(
      context: context,
      productId: widget.product.id.toString(),
      reviewService: _reviewService,
      userId: userId,
      initial: initialReview,
    );
    setState(() {});
  }

  void _handleReviewDelete(String userId) async {
    await _reviewService.deleteReview(widget.product.id.toString(), userId);
    setState(() {});
  }

  Review? _findMyReview(List<Review> reviews, String? userId) {
    for (final r in reviews) {
      if (r.userId == userId) return r;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F5F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // --- Header with close button ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    letterSpacing: 0.3,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: Color(0xFF6B7280),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          // --- Content ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Product Image ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.imageUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
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

                  // --- Product Name ---
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- Price ---
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8A9A5B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Category ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8A9A5B).withValues(alpha: 26), // withOpacity(0.1)
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.product.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8A9A5B),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Description ---
                  const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50), letterSpacing: 0.3)),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description.isEmpty ? 'No description available.' : widget.product.description,
                    style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280), height: 1.6, letterSpacing: 0.2),
                  ),
                  const SizedBox(height: 24),

                  // --- Reviews Section ---
                  FutureBuilder<String?>(
                    future: _getCurrentUserId(),
                    builder: (context, userIdSnapshot) {
                      final userId = userIdSnapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Reviews",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3E50),
                                  letterSpacing: 0.3,
                                ),
                              ),
                              if (userId != null)
                                StreamBuilder<List<Review>>(
                                  stream: _reviewService.getReviewsForProduct(widget.product.id.toString()),
                                  builder: (context, snapshot) {
                                    final myReview = _findMyReview(snapshot.data ?? [], userId);
                                    if (myReview == null) {
                                      return CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => _showAddOrEditReview(userId: userId),
                                        child: const Icon(
                                          CupertinoIcons.plus_circle,
                                          color: Color(0xFF8A9A5B),
                                          size: 24,
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          StreamBuilder<List<Review>>(
                            stream: _reviewService.getReviewsForProduct(widget.product.id.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CupertinoActivityIndicator();
                              }
                              final reviews = snapshot.data ?? [];
                              return ProductReviewList(
                                reviews: reviews,
                                currentUserId: userId,
                                onEdit: (review) => _showAddOrEditReview(initialReview: review, userId: userId!),
                                onDelete: (review) => _handleReviewDelete(review.userId),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- Stock Status ---
                  Row(
                    children: [
                      Icon(
                        widget.product.stock > 0
                            ? CupertinoIcons.checkmark_circle_fill
                            : CupertinoIcons.xmark_circle_fill,
                        color: widget.product.stock > 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.product.stock > 0
                            ? '${widget.product.stock} in stock'
                            : 'Out of stock',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: widget.product.stock > 0
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // --- iOS-Style Bottom Actions (unchanged) ---
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              border: Border(
                top: BorderSide(
                  color: CupertinoColors.separator.withValues(alpha: 77), // withOpacity(0.3)
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Consumer<WishlistService>(
                    builder: (context, wishlistService, child) {
                      final isInWishlist = wishlistService.isInWishlist(widget.product.id);
                      return CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          wishlistService.toggleWishlist(widget.product);
                        },
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            // Always white when selected
                            color: isInWishlist
                                ? CupertinoColors.white
                                : const Color(0xFF000000).withValues(alpha: 10), // withOpacity(0.04)
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Icon(
                            isInWishlist
                                ? CupertinoIcons.heart_fill
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
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: widget.product.stock > 0 ? () => _addToCart(context) : null,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: widget.product.stock > 0
                              ? const Color(0xFF8A9A5B)
                              : const Color(0xFF000000).withValues(alpha: 26), // withOpacity(0.1)
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: widget.product.stock > 0
                              ? [
                            BoxShadow(
                              color: const Color(0xFF8A9A5B).withValues(alpha: 64), // withOpacity(0.25)
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.cart_fill_badge_plus,
                              color: widget.product.stock > 0
                                  ? CupertinoColors.white
                                  : const Color(0xFF000000).withValues(alpha: 77), // withOpacity(0.3)
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: widget.product.stock > 0
                                    ? CupertinoColors.white
                                    : const Color(0xFF000000).withValues(alpha: 77), // withOpacity(0.3)
                                letterSpacing: 0.3,
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
}