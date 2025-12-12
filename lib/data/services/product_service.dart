import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Get all products (stream)
  Stream<List<Product>> getProductsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  // Get all products (future)
  Future<List<Product>> getAllProducts() async {
    final snapshot = await _firestore
        . collection(_collection)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs. map((doc) => Product.fromFirestore(doc)).toList();
  }

  // Get product by ID
  Future<Product? > getProductById(String id) async {
    final doc = await _firestore. collection(_collection).doc(id).get();
    if (doc.exists) {
      return Product.fromFirestore(doc);
    }
    return null;
  }

  // Add product
  Future<String> addProduct(Product product) async {
    final docRef = await _firestore.collection(_collection).add(product.toFirestore());
    return docRef.id;
  }

  // Update product
  Future<void> updateProduct(String id, Product product) async {
    await _firestore.collection(_collection).doc(id).update(product.toFirestore());
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  // Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('featured', isEqualTo:  true)
        .limit(6)
        .get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    final snapshot = await _firestore. collection(_collection).get();
    final products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();

    return products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase()) ||
          product.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}