import 'package:flutter/cupertino.dart';
import '../../../../data/models/review_model.dart';
import 'product_review_item.dart';

class ProductReviewList extends StatelessWidget {
  final List<Review> reviews;
  final String? currentUserId;
  final void Function(Review review)? onEdit;
  final void Function(Review review)? onDelete;

  const ProductReviewList({
    super.key,
    required this.reviews,
    required this.currentUserId,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Text(
        'No reviews yet.',
        style: TextStyle(color: Color(0xFF6B7280)),
      );
    }
    return Column(
      children: reviews.map((review) {
        final isMine = currentUserId != null && review.userId == currentUserId;
        return ProductReviewItem(
          review: review,
          isMine: isMine,
          onEdit: isMine && onEdit != null ? () => onEdit!(review) : null,
          onDelete: isMine && onDelete != null ? () => onDelete!(review) : null,
        );
      }).toList(),
    );
  }
}