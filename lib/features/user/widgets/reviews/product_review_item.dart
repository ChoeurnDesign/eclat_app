import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/review_model.dart';

class ProductReviewItem extends StatelessWidget {
  final Review review;
  final bool isMine;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductReviewItem({
    super.key,
    required this.review,
    required this.isMine,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(CupertinoIcons.person, size: 24, color: Color(0xFF8A9A5B)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and icons in a row, spaced apart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Username left
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.3,
                      ),
                    ),
                    // Icons right (if mine)
                    if (isMine)
                      Row(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onEdit,
                              child: const Padding(
                                padding: EdgeInsets.only(bottom: 2, right: 2),
                                child: Icon(Icons.edit, size: 20, color: Color(0xFF8A9A5B)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onDelete,
                              child: const Padding(
                                padding: EdgeInsets.only(bottom: 2),
                                child: Icon(CupertinoIcons.delete, size: 20, color: Color(0xFFEB5757)),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                // Stars
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      starIndex < review.rating
                          ? CupertinoIcons.star_fill
                          : CupertinoIcons.star,
                      color: starIndex < review.rating
                          ? const Color(0xFFFFC700)
                          : CupertinoColors.systemGrey,
                      size: 16,
                    );
                  }),
                ),
                // Comment
                Text(
                  review.comment,
                  style: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.3,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                // Date
                Text(
                  '${review.date.year}-${review.date.month.toString().padLeft(2, '0')}-${review.date.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}