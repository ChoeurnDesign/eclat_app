import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stock;
  final String imageUrl;
  final bool featured;
  final DateTime?  createdAt;

  Product({
    required this. id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    required this.imageUrl,
    this.featured = false,
    this.createdAt,
  });

  // From Firestore
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price:  (data['price'] ??  0).toDouble(),
      category: data['category'] ?? '',
      stock: data['stock'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      featured: data['featured'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description':  description,
      'price': price,
      'category': category,
      'stock': stock,
      'imageUrl': imageUrl,
      'featured': featured,
      'createdAt': createdAt != null ?  Timestamp. fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  // CopyWith for editing
  Product copyWith({
    String? id,
    String?  name,
    String? description,
    double? price,
    String? category,
    int?  stock,
    String? imageUrl,
    bool? featured,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this. id,
      name: name ??  this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this. category,
      stock: stock ??  this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      featured: featured ?? this.featured,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}