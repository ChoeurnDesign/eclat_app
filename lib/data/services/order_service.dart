import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';
import 'cart_service.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ✅ Create order in Firestore
  Future<String? > createOrder({
    required List<CartItem> cartItems,
    required double total,
    required String paymentMethod,
  }) async {
    try {
      final user = _auth.currentUser;

      // ✅ If no user, create order without user ID (for testing)
      final orderId = _firestore.collection('orders').doc().id;

      final order = OrderModel(
        id: orderId,
        items: cartItems
            .map((item) => OrderItem(
          productId: item.product.id,
          productName: item.product.name,
          quantity: item.quantity,
          price: item. product.price,
        ))
            .toList(),
        total: total,
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
      );

      if (user != null) {
        // ✅ Save to user's orders subcollection
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .doc(orderId)
            .set(order.toJson());
      } else {
        // ✅ Save to global orders collection (for guests)
        await _firestore
            .collection('orders')
            .doc(orderId)
            .set(order.toJson());
      }

      debugPrint('✅ Order created successfully:  $orderId');
      return orderId;
    } catch (e) {
      debugPrint('❌ Error creating order: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  /// ✅ Get user's order history
  Stream<List<OrderModel>> getUserOrders() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => OrderModel.fromJson(doc.data()))
        .toList());
  }

  /// ✅ Get single order by ID
  Future<OrderModel? > getOrderById(String orderId) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .doc(orderId)
            .get();

        if (doc.exists) {
          return OrderModel.fromJson(doc.data()!);
        }
      } else {
        // Check global orders
        final doc = await _firestore
            .collection('orders')
            .doc(orderId)
            .get();

        if (doc.exists) {
          return OrderModel.fromJson(doc. data()!);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting order: $e');
      return null;
    }
  }
}