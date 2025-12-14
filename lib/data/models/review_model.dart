import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String userId;
  final String userName;
  final String comment;
  final DateTime date;
  final int rating;

  Review({
    required this.userId,
    required this.userName,
    required this.comment,
    required this.date,
    required this.rating,
  });

  factory Review.fromFirestore(Map<String, dynamic> json) {
    return Review(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      comment: json['comment'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
      rating: json['rating'] ?? 5,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'date': Timestamp.fromDate(date),
      'rating': rating,
    };
  }
}