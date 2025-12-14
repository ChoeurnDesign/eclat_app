import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Review>> getReviewsForProduct(String productId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Review.fromFirestore(doc.data())).toList());
  }

  Future<void> addOrUpdateReview(String productId, Review review) async {
    final reviewRef = _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .doc(review.userId);
    await reviewRef.set(review.toMap());
  }

  Future<void> deleteReview(String productId, String userId) async {
    await _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .doc(userId)
        .delete();
  }
}