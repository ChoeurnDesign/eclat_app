import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../data/models/review_model.dart';
import '../../../../data/services/review_service.dart';

Future<void> showProductReviewDialog({
  required BuildContext context,
  required String productId,
  required ReviewService reviewService,
  required String userId,
  Review? initial,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  String comment = initial?.comment ?? '';
  int rating = initial?.rating ?? 0;
  String userName = user?.displayName ?? 'Guest';
  final commentController = TextEditingController(text: comment);

  await showCupertinoDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) => CupertinoAlertDialog(
        title: Text(
          initial == null ? 'Add Review' : 'Edit Review',
          style: const TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        content: Column(
          children: [
            const SizedBox(height: 12),
            if (user != null) ...[
              CupertinoTextField(
                placeholder: "Your Name",
                controller: TextEditingController(text: userName),
                onChanged: (val) => userName = val,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 16,
                  letterSpacing: 0.3,
                ),
                placeholderStyle: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
            ],
            CupertinoTextField(
              controller: commentController,
              placeholder: "Your Review",
              maxLines: 2,
              onChanged: (val) => comment = val,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
              placeholderStyle: const TextStyle(
                color: CupertinoColors.systemGrey,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (starIdx) {
                return GestureDetector(
                  onTap: () => setState(() { rating = starIdx + 1; }),
                  child: Icon(
                    starIdx < rating ? CupertinoIcons.star_fill : CupertinoIcons.star,
                    size: 28,
                    color: starIdx < rating ? const Color(0xFFFFC700) : CupertinoColors.systemGrey,
                  ),
                );
              }),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                fontSize: 17,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              final saveName = (user == null) ? 'Guest' : (userName.trim().isEmpty ? 'Guest' : userName.trim());
              if (comment.trim().isNotEmpty && rating > 0) {
                final review = Review(
                  userId: userId,
                  userName: saveName,
                  comment: comment.trim(),
                  date: DateTime.now(),
                  rating: rating,
                );
                final navigator = Navigator.of(context);
                await reviewService.addOrUpdateReview(productId, review);
                navigator.pop();
              }
            },
            child: Text(
              initial == null ? 'Submit' : 'Update',
              style: const TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}