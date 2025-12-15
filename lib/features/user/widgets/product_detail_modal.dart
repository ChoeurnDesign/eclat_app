import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final _reviewService = ReviewService();

  void _addToCart(BuildContext context) {
    final cartService = Provider.of<CartService>(context, listen: false);
    cartService.addToCart(widget.product);
    Navigator.pop(context);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Added to Cart'),
        content: Text('${widget.product.name} has been added to your cart!'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Shopping'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cart');
            },
            child: const Text('View Cart'),
          ),
        ],
      ),
    );
  }

  Future<String?> _getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? await GuestIdUtil.getGuestId();
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
    final borderGray = Colors.grey[600]!; // For wishlist outline
    final p = widget.product;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F5F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Product Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(CupertinoIcons.xmark_circle_fill, color: Color(0xFF6B7280), size: 28),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      p.imageUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 300,
                        color: const Color(0xFFE5E7EB),
                        child: const Center(
                          child: Icon(CupertinoIcons.photo, size: 64, color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Name
                  Text(p.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
                  const SizedBox(height: 12),
                  // --- Row: Price LEFT, category RIGHT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${p.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8A9A5B),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8A9A5B),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          p.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Stock
                  Row(
                    children: [
                      Icon(
                        p.stock > 0 ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.xmark_circle_fill,
                        color: p.stock > 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        p.stock > 0 ? '${p.stock} in stock' : 'Out of stock',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: p.stock > 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.description.isEmpty ? 'No description available.' : p.description,
                    style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 24),
                  // --- Reviews Last ---
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
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
                              ),
                              if (userId != null)
                                StreamBuilder<List<Review>>(
                                  stream: _reviewService.getReviewsForProduct(p.id.toString()),
                                  builder: (context, snapshot) {
                                    final myReview = _findMyReview(snapshot.data ?? [], userId);
                                    if (myReview == null) {
                                      return CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => _showAddOrEditReview(userId: userId),
                                        child: const Icon(CupertinoIcons.plus_circle, color: Color(0xFF8A9A5B), size: 24),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          StreamBuilder<List<Review>>(
                            stream: _reviewService.getReviewsForProduct(p.id.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) return const CupertinoActivityIndicator();
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // --- Actions bar ---
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: const BoxDecoration(
              color: CupertinoColors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0x4DC6C6C8),
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
                      final isInWishlist = wishlistService.isInWishlist(p.id);
                      return CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => wishlistService.toggleWishlist(p),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: borderGray, width: 1.5),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Icon(
                            isInWishlist ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                            color: isInWishlist ? const Color(0xFFFF3B30) : borderGray,
                            size: 28,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: p.stock > 0 ? () => _addToCart(context) : null,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: p.stock > 0
                              ? const Color(0xFF8A9A5B)
                              : const Color(0x1A000000),
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: p.stock > 0
                              ? [
                            BoxShadow(
                              color: const Color(0x408A9A5B),
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
                              color: p.stock > 0 ? CupertinoColors.white : const Color(0x4D000000),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: p.stock > 0 ? CupertinoColors.white : const Color(0x4D000000),
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